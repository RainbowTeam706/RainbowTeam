import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server:{
    proxy:{
      '/api':{
        target:'http://192.168.1.107:8080',//后端地址
        changeOrigin:true,
        rewrite:(path)=>path.replace(/^\/api/,'')
      }
    },
    host: '0.0.0.0',
    port: 5173, // 你的端口号，默认5173
  }
})
