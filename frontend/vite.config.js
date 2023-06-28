import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import replace from '@rollup/plugin-replace'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({command}) => { return {
  base: './',
  plugins: [
    replace({
      // production / development environment api base
      __WEBSITE_BASE__: command === 'build' ? JSON.stringify('/packages')
                                            : JSON.stringify(''),
      __API_BASE__: command === 'build' ? JSON.stringify('https://bioarchlinux.org')
                                        : JSON.stringify(''),
      preventAssignment: true,
    }),
    vue(),
  ],
  // for import alias
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    // used for development, bypass CORS policy
    proxy: {
      '/api': 'https://bioarchlinux.org'
    }
  }
}})
