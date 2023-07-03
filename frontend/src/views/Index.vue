<script setup>
import { ref, watch } from 'vue'
import PackageList from '@/components/Index/PackageList.vue'

import Index from 'flexsearch/dist/module/index'

import { requestPackageIndex } from '../api'

import { displayPackages } from '@/state'

let packageIndex = null
const searchIndex = new Index({ tokenize: 'forward' })

let searchInput = ref("")

function updateSearchIndex(pkglist) {
  pkglist.forEach((content, index) => {
    searchIndex.add(index, content.name)
  })
}

requestPackageIndex()
  .then((obj) => {
    packageIndex = obj
    displayPackages.value = obj
    updateSearchIndex(obj)
  })

watch(searchInput, async(newVal, oldVal) => {
  if (searchInput.value.length === 0) {
    displayPackages.value = packageIndex
  }
  else {
    const searchResult = searchIndex.search(searchInput.value)
    const finalResult = []
    searchResult.forEach((idx) => {
      finalResult.push(packageIndex[idx])
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
