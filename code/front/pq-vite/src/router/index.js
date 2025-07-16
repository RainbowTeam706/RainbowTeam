import { createRouter, createWebHistory } from 'vue-router'
import Login from '../components/Login.vue'
import Main from '../components/Main.vue'
import Myself from '../components/Myself.vue'
import NavBottom from '../components/NavBottom.vue'
import Speech from '../components-student/speech.vue'


const routes = [
  { path: '/login', component: Login },



  { path: '/navbottom', component: NavBottom , children: [
    { path: '/myself', component: Myself },
    { path: '/main', component: Main },
    { path: '', redirect: 'main' },
  ]},
  { path: '/speech', component: Speech },


]

const router = createRouter({
  history: createWebHistory(),
  routes:routes
})

export default router 