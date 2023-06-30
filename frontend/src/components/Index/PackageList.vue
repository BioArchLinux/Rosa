<script setup>
import { ref, watch } from 'vue';
import PackageListItem from './PackageListItem.vue'
import { displayPackages } from '@/state'
import { useRouter } from 'vue-router'

const router = useRouter()

const currentDisplay = ref([])
const count = ref(0)

// Paging
let PAGE_ITEM_SIZE = 100
let pages = 0
let currentPage = 1

function performPaging() {
  pages = Math.ceil(count.value / PAGE_ITEM_SIZE)
  currentPage = 1
  displayPage()
}

function displayPage() {
  let start = (currentPage - 1) * PAGE_ITEM_SIZE
  currentDisplay.value = displayPackages.value.slice(start, start + PAGE_ITEM_SIZE)
}

function pageUp() { if (currentPage > 1) { --currentPage; displayPage(); } }
function pageDown() { if (currentPage < pages) { ++currentPage; displayPage(); } }

function navigatorToItem(pkg) {
  router.push(`/${pkg}`)
}

watch(
  displayPackages,
  async newVal => {
    count.value = newVal.length
    performPaging()
  }
)
</script>

<template>
  <div style="display: flex;">
    <p>{{ count }} packages. page {{ currentPage }} of {{ pages }}.</p>
    <div style="margin-left: auto;">
      <a href="#" @click.prevent="pageUp" style="margin-right: 2em;">&lt; Prev</a>
      <a href="#" @click.prevent="pageDown">Next &gt;</a>
    </div>
  </div>

  <table id="index-table">
    <thead>
      <tr>
        <td>Name</td>
        <td>Version</td>
        <td>Description</td>
        <td>Last Build</td>
      </tr>
    </thead>
    
    <tbody v-for="pkg in currentDisplay" :key="pkg">
      <PackageListItem :pkgname="pkg" @click="navigatorToItem(pkg)"></PackageListItem>
    </tbody>
  </table>

  <div style="display: flex;">
    <p>{{ count }} packages. page {{ currentPage }} of {{ pages }}.</p>
    <div style="margin-left: auto;">
      <a href="#" @click.prevent="pageUp" style="margin-right: 2em;">&lt; Prev</a>
      <a href="#" @click.prevent="pageDown">Next &gt;</a>
    </div>
  </div>
</template>

<style>
#index-table {
  width: 100%;
}
</style>
