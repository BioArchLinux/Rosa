<script setup>
const props = defineProps({
  name: String,
  type: String,
  dist: String
})

function generatePackageLinkUrl(name, dist) {
  switch (dist) {
    case 'arch':
      return `https://archlinux.org/packages/?q=${name}`
    case 'bioarch':
      return `https://bioarchlinux.org/packages/${name}`
    default:
      console.log('generatePackageLinkUrl(): unreachable')
  }
}
</script>

<template>
  <p><a :href="generatePackageLinkUrl(name, dist)">{{ name }}</a><span v-if="type !== 'dep'"> ({{ type }})</span></p>
</template>
