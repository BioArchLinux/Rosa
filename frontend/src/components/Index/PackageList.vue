<script setup>
import { ref, watch } from 'vue';
import { displayPackages } from '@/state'
import moment from 'moment'

const tableHeaders = [
  { text: 'Name', field: 'name' },
  { text: 'Version', field: 'version' },
  { text: 'Description', field: 'desc' },
  { text: 'Last Build', field: 'builddate' },
]

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

  <div class="table-scroll-wrapper">
    <table id="index-table">
      <thead>
        <tr>
          <td v-for="head in tableHeaders">{{ head.text }}</td>
        </tr>
      </thead>

      <tbody>
        <!-- <PackageListItem :pkgname="pkg.name" @click="navigatorToItem(pkg.name)"></PackageListItem> -->
        <tr v-for="pkg in currentDisplay" :key="pkg.name">
          <td v-for="heading in tableHeaders">
            <router-link v-if="heading.field == 'name'" :to="`/${pkg.name}`">{{pkg.name}}</router-link>
            <time v-else-if="heading.field == 'builddate'" :datetime="moment.unix(pkg.builddate).format()">{{ moment.unix(pkg.builddate).format('YYYY-MM-DD') }}</time>
            <span v-else>{{ pkg[heading.field] }}</span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>

  <div style="display: flex;">
    <p>{{ count }} packages. page {{ currentPage }} of {{ pages }}.</p>
    <div style="margin-left: auto;">
      <a href="#" @click.prevent="pageUp" style="margin-right: 2em;">&lt; Prev</a>
      <a href="#" @click.prevent="pageDown">Next &gt;</a>
    </div>
  </div>
</template>
