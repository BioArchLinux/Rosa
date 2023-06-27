<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'

import ViewDetail from '@/components/PackageInfo/ViewDetail.vue'

import moment from 'moment'
import { requestPackageInfo } from '@/api'
import { calculateSize } from '@/utils/sizing'

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

    depends.value = obj.depends.split('\n').filter((elem) => elem.length > 0)
    optdepends.value = obj.optdepends.split('\n').filter((elem) => elem.length > 0)
    makedepends.value = obj.makedepends.split('\n').filter((elem) => elem.length > 0)
    files.value = obj.files.split('\n').filter((elem) => elem.length > 0)
    builddate.value = moment.unix(obj.builddate).format('YYYY-MM-DD HH:MM:SS')
  })
</script>

<template>
  <div class="box">
    <h2 class="pkgname-header">{{ pkginfo.name }} {{ pkginfo.version }}</h2>

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
          <td>{{ pkginfo.packager }}</td>
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
    <p v-for="dep in depends"> {{ dep }}</p>
    <p v-for="optdep in optdepends"> {{ optdep }} (optional)</p>
    <p v-for="makedep in makedepends"> {{ makedep }} (make)</p>

    <h3 class="pkginfo-section">Package Content</h3>
    <ViewDetail :message="`View the file list for ${pkginfo.name}`">
      <p v-for="file in files"> {{ file }}</p>
    </ViewDetail>

  </div>
</template>
