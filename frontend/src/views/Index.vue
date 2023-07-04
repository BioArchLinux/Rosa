<script setup>
import { ref, watch } from 'vue'
import PackageList from '@/components/Index/PackageList.vue'

import Index from 'flexsearch/dist/module/index'

import { requestPackageIndex } from '../api'

import { packageIndex, displayPackages } from '@/state'

const searchIndex = new Index({ tokenize: 'forward' })

let searchInput = ref("")

function updateSearchIndex(pkglist) {
  pkglist.forEach((content, index) => {
    searchIndex.add(index, content.name)
  })
}

requestPackageIndex()
  .then((obj) => {
    packageIndex.value = obj
    displayPackages.value = obj
    updateSearchIndex(obj)
  })

watch(searchInput, async(newVal, oldVal) => {
  if (searchInput.value.length === 0) {
    displayPackages.value = packageIndex.value
  }
  else {
    const searchResult = searchIndex.search(searchInput.value)
    const finalResult = []
    searchResult.forEach((idx) => {
      finalResult.push(packageIndex.value[idx])
    })
    displayPackages.value = finalResult
  }
})
</script>

<template>
  <div class="box" style="margin-bottom: 15px;">
    <h2>Package Search</h2>
    <label for="search-input">Keyword</label>
    <input class="search" type="text" id="search-input" v-model="searchInput">
  </div>
  <div class="box">
    <PackageList></PackageList>
  </div>
</template>
