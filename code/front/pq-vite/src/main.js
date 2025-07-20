import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
//import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/reset.css';
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import router from './router'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'


const app = createApp(App)
const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)
app.use(pinia)



app.use(router)
// app.use(createPinia())
app.use(ElementPlus)
app.mount('#app')





