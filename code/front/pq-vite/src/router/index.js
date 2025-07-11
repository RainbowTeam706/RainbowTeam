import { createRouter, createWebHistory } from 'vue-router'
import Login from '../components/Login.vue'


const routes = [
  { path: '/login', component: Login },


]

const router = createRouter({
  history: createWebHistory(),
  routes:routes
})

export default router 