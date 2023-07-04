<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'

import PackageActions from '@/components/PackageInfo/PackageActions.vue'
import PackageDependency from '@/components/PackageInfo/PackageDependency.vue'
import ViewDetail from '@/components/PackageInfo/ViewDetail.vue'

import moment from 'moment'

import { requestPackageInfo, requestPackageList } from '@/api'
import { calculateSize } from '@/utils/sizing'
import { formatPackager } from '@/utils/packager'

const route = useRoute()

const pkginfo = ref({})

const depends = ref([])
const optdepends = ref([])
const makedepends = ref([])
const files = ref([])
const builddate = ref("")

requestPackageInfo(route.params.packageName)
  .then(obj => {
    pkginfo.value = obj

    files.value = obj.files.split('\n').filter((elem) => elem.length > 0)
    builddate.value = moment.unix(obj.builddate).format('YYYY-MM-DD HH:MM:SS')
    
    const o_depends = obj.depends.split('\n').filter((elem) => elem.length > 0)
    const o_optdepends = obj.optdepends.split('\n').filter((elem) => elem.length > 0)
    const o_makedepends = obj.makedepends.split('\n').filter((elem) => elem.length > 0)

    requestPackageList()
      .then((list) => {
        list.forEach((bioarchPackageName) => {
          function mapPackageDistribution(pkg) {
            if (bioarchPackageName === pkg) {
              return { name: pkg, dist: 'bioarch' }
            }
            else {
              return { name: pkg, dist: 'arch' }
            }
          }
          depends.value = o_depends.map(mapPackageDistribution)
          optdepends.value = o_optdepends.map(mapPackageDistribution)
          makedepends.value = o_makedepends.map(mapPackageDistribution)
        })
      })
  })
</script>

<template>
  <div class="box">
    <h2>{{ pkginfo.name }} {{ pkginfo.version }}</h2>

    <div class="right-things">
      <PackageActions :pkginfo="pkginfo"></PackageActions>
    </div>

    <table class="pkginfo">
      <tbody>
        <tr>
          <th>Architecture:</th>
          <td>{{ pkginfo.arch }}</td>
        </tr>
        <tr>
          <th>Description:</th>
          <td>{{ pkginfo.desc }}</td>
        </tr>
        <tr>
          <th>Upstream URL:</th>
          <td><a :href="pkginfo.url">{{ pkginfo.url }}</a></td>
        </tr>
        <tr>
          <th>License(s):</th>
          <td>{{ pkginfo.license }}</td>
        </tr>
        <tr>
          <th>Packager:</th>
          <td v-html="formatPackager(pkginfo.packager)"></td>
        </tr>
        <tr>
          <th>Package Size:</th>
          <td>{{ calculateSize(pkginfo.csize) }}</td>
        </tr>
        <tr>
          <th>Installed Size:</th>
          <td>{{ calculateSize(pkginfo.isize) }}</td>
        </tr>
        <tr>
          <th>Build Date:</th>
          <td>{{ builddate }}</td>
        </tr>
      </tbody>
    </table>

    <h3 class="pkginfo-section">Dependencies</h3>
    <PackageDependency :name="dep.name" :dist="dep.dist" type="dep" v-for="dep in depends"></PackageDependency>
    <PackageDependency :name="optdep.name" :dist="optdep.dist" type="optional" v-for="optdep in optdepends"></PackageDependency>
    <PackageDependency :name="makedep.name" :dist="makedep.dist" type="make" v-for="makedep in makedepends"></PackageDependency>

    <h3 class="pkginfo-section">Package Content</h3>
    <ViewDetail :message="`View the file list for ${pkginfo.name}`">
      <p v-for="file in files"> {{ file }}</p>
    </ViewDetail>

  </div>
</template>
