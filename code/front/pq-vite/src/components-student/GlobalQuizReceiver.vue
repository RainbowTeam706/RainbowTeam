<template>
  <div style="display: none"></div>
</template>

<script setup>
import { watch } from 'vue'
import { ElMessage, ElNotification } from 'element-plus'
import { useRouter, useRoute } from 'vue-router'
import { useQuizWsStore } from '../stores/quizWs.js'
import { useActivityStore } from '../stores/activity.js'

const quizWsStore = useQuizWsStore()
const activityStore = useActivityStore()
const router = useRouter()
const route = useRoute()

watch(
  () => quizWsStore.lastMessageSeq,
  () => {
    const msg = quizWsStore.lastMessage
    if (!msg) return

    const activityId = msg.activityId
    if (!activityId) {
      ElMessage.warning('收到新的 Pop Quiz，但缺少活动信息')
      return
    }

    const activity = activityStore.getActivityById(activityId)
    const activityName = activity?.title || `活动ID:${activityId}`
    const lastTimeSeconds = Number(msg.lastTime)
    const durationText = Number.isFinite(lastTimeSeconds) && lastTimeSeconds > 0
      ? `，限时 ${lastTimeSeconds} 秒`
      : ''

    // 如果当前已经在对应活动页，给简单提示即可
    if (route.name === 'speechStudent' && String(route.params?.id) === String(activityId)) {
      ElMessage.success(`收到新的 Pop Quiz（${activityName}${durationText}）`)
      return
    }

    // 全局通知：可点击快速跳转到对应活动页面
    const notification = ElNotification({
      title: '收到新题',
      message: `活动：${activityName}${durationText}（点击跳转）`,
      type: 'success',
      duration: 3000,
      onClick: () => {
        notification.close()
        router.push({ name: 'speechStudent', params: { id: activityId } })
      }
    })
  }
)
</script>
