<script setup>
import { onMounted, watch } from 'vue'
import GlobalQuizReceiver from './components-student/GlobalQuizReceiver.vue'
import { useUserInfoStore } from './stores/userInfo.js'
import { useQuizWsStore } from './stores/quizWs.js'

const userInfoStore = useUserInfoStore()
const quizWsStore = useQuizWsStore()

onMounted(() => {
  if (userInfoStore.id) {
    quizWsStore.ensureConnected(userInfoStore.id)
  }
})

// 登录后或刷新恢复用户信息后，自动补连并订阅个人频道
watch(
  () => userInfoStore.id,
  (newId) => {
    if (newId) {
      quizWsStore.ensureConnected(newId)
    }
  },
  { immediate: true }
)
</script>

<template>
  <router-view></router-view>
  <GlobalQuizReceiver />
</template>

<style scoped>

</style>
