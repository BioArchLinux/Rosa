<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  pkginfo: Object
})

const issueQuerys = ref(new URLSearchParams)

watch(
  () => props.pkginfo,
  newVal => {
    if (newVal === undefined) { return }
    // https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue#creating-an-issue-from-a-url-query
    issueQuerys.value = new URLSearchParams({
      title: `[BUG] ${newVal.name}:`,
      labels: 'bug',
      template: 'packages-bug-.md'
    })
  }
)
</script>

<template>
<div id="actionlist">
  <h4>Package Actions</h4>
  <ul class="small">
    <li>
      <a :href="`https://github.com/BioArchLinux/Packages/tree/master/BioArchLinux/${pkginfo.base}`">Source Files</a>
    </li>
    <li>
      <a :href="`https://github.com/BioArchLinux/Packages/issues/new?${issueQuerys.toString()}`">Bug Reports</a>
    </li>
    <li>
      <a :href="`https://wiki.bioarchlinux.org/index.php?search=${pkginfo.name}`">Search Wiki</a>
    </li>
    <li>
      <a :href="`https://repo.bioarchlinux.org/${pkginfo.arch}/${pkginfo.name}-${pkginfo.version}-${pkginfo.arch}.pkg.tar.zst`">Download From Mirror</a>
    </li>
  </ul>
</div>
</template>
