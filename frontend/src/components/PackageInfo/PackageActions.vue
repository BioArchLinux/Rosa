<script setup>
const props = defineProps({
  pkginfo: Object
})
</script>

<template>
<div id="actionlist">
  <h4>Package Actions</h4>
  <ul class="small">
    <li>
      <a :href="`https://github.com/BioArchLinux/Packages/tree/master/BioArchLinux/${pkginfo.base}`">Source Files</a>
    </li>
    <li>
      <a>Bug Reports</a>
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
