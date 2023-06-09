import { createRouter, createWebHistory } from 'vue-router'

import Index from './views/Index.vue'
import Package from './views/Package.vue'

const router = createRouter({
  history: createWebHistory(__WEBSITE_BASE__),
  routes: [
    { path: '/', component: Index },
    { path: '/:packageName', component: Package }
  ]
})

export default router
