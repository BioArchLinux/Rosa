<script setup>
import {ref} from 'vue'
const props = defineProps({
  message: String
})

const expand = ref(false)
</script>

<template>
  <slot v-if="expand"></slot>
  <a href="#" v-else @click.prevent="expand = true">{{ message }}</a>
</template>
