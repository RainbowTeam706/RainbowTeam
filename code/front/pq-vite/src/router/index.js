import { createRouter, createWebHistory } from 'vue-router'
import Login from '../components/Login.vue'
import Main from '../components/Main.vue'

const routes = [
  { path: '/login', component: Login },
  { path: '/main', component: Main }
]

const router = createRouter({
  history: createWebHistory(),
  routes:routes
})

export default router 