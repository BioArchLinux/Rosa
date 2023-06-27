<script setup>
import { ref, watch } from 'vue'
import PackageList from '@/components/Index/PackageList.vue'

import Index from 'flexsearch/dist/module/index'

import { requestPackageInfo, requestPackageList } from '../api'

import { displayPackages } from '@/state'

let packageList = null
const searchIndex = new Index({ tokenize: 'forward' })

let searchInput = ref("")

function updateSearchIndex(pkglist) {
  pkglist.forEach((content, index) => {
    searchIndex.add(index, content)
  })
}

requestPackageList()
  .then((obj) => {
    packageList = obj
    displayPackages.value = obj
    updateSearchIndex(obj)
  })

watch(searchInput, async(newVal, oldVal) => {
  if (searchInput.value.length === 0) {
    displayPackages.value = packageList
  }
  else {
    const searchResult = searchIndex.search(searchInput.value)
    const finalResult = []
    searchResult.forEach((elem) => {
      finalResult.push(packageList[elem])
    })
    displayPackages.value = finalResult
  }
})
</script>

<template>
  <div class="box" style="margin-bottom: 15px;">
    <input class="search" type="text" v-model="searchInput">
  </div>
  <div class="box">
    <PackageList></PackageList>
  </div>
</template>

<style>
.search {
  width: 100%;

  margin: 15px 0;

  font-size: 15px;
  padding: .5em .5em;
}
</style>
