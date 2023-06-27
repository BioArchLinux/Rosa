<script setup>
import { requestPackageInfo } from '@/api'
import { ref } from 'vue'
import moment from 'moment'

const props = defineProps({
  pkgname: String
})

let info_name = ref("...")
let info_version = ref("...")
let info_desc = ref("...")
let info_date = ref("...")

// https://bioarchlinux.org/api/abacas.json

requestPackageInfo(props.pkgname)
  .then(obj => {
    info_name.value = obj.name
    info_version.value = obj.version
    info_desc.value = obj.desc
    info_date.value = moment.unix(obj.builddate).format('YYYY-MM-DD')
  })
</script>

<template>
  <tr class="index-item">
    <td>{{ info_name }}</td>
    <td>{{ info_version }}</td>
    <td>{{ info_desc }}</td>
    <td>{{ info_date }}</td>
  </tr>
</template>
