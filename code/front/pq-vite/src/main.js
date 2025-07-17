import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'
import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/reset.css';
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import router from './router'


const pinia = createPinia()
const app = createApp(App)

app.use(pinia)
app.use(router)
app.use(ElementPlus)
app.mount('#app')





