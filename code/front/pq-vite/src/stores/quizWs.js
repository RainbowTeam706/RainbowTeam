import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useQuizWsStore = defineStore('quizWs', () => {
  const status = ref('disconnected')
  const statusText = ref('未连接')

  const lastMessage = ref(null)
  const lastMessageSeq = ref(0)
  const lastTeacherMessage = ref(null)
  const lastTeacherMessageSeq = ref(0)

  let stompClient = null
  let studentSubscription = null
  let teacherSubscription = null
  let isConnecting = false
  let subscribedUserId = null
  let subscribedActivityId = null

  const loadLibraries = () => {
    return new Promise((resolve, reject) => {
      if (window.SockJS && window.Stomp) {
        resolve()
        return
      }

      let loaded = 0
      const done = () => {
        loaded += 1
        if (loaded === 2) {
          resolve()
        }
      }

      const fail = (msg) => reject(new Error(msg))

      const sockjsScript = document.createElement('script')
      sockjsScript.src = 'https://cdn.bootcdn.net/ajax/libs/sockjs-client/1.5.1/sockjs.min.js'
      sockjsScript.onload = done
      sockjsScript.onerror = () => fail('SockJS 加载失败')
      document.head.appendChild(sockjsScript)

      const stompScript = document.createElement('script')
      stompScript.src = 'https://cdn.bootcdn.net/ajax/libs/stomp.js/2.3.3/stomp.min.js'
      stompScript.onload = done
      stompScript.onerror = () => fail('STOMP 加载失败')
      document.head.appendChild(stompScript)
    })
  }

  const subscribeUserTopic = (userId) => {
    if (!stompClient || !stompClient.connected) return

    if (studentSubscription) {
      studentSubscription.unsubscribe()
      studentSubscription = null
    }

    subscribedUserId = userId
    studentSubscription = stompClient.subscribe('/topic/quiz/' + userId, (message) => {
      try {
        lastMessage.value = JSON.parse(message.body)
        lastMessageSeq.value += 1
      } catch (e) {
        // ignore parse error
      }
    })
  }

  const subscribeTeacherTopic = (activityId) => {
    if (!stompClient || !stompClient.connected || !activityId) return

    if (teacherSubscription) {
      teacherSubscription.unsubscribe()
      teacherSubscription = null
    }

    subscribedActivityId = activityId
    teacherSubscription = stompClient.subscribe('/topic/file-ingest/' + activityId, (message) => {
      try {
        lastTeacherMessage.value = JSON.parse(message.body)
        lastTeacherMessageSeq.value += 1
      } catch (e) {
        // ignore parse error
      }
    })
  }

  const ensureConnected = async (userId) => {
    if (stompClient && stompClient.connected) {
      if (userId && String(subscribedUserId) !== String(userId)) {
        subscribeUserTopic(userId)
      }
      return
    }

    if (isConnecting) return

    isConnecting = true
    status.value = 'connecting'
    statusText.value = '连接中...'

    try {
      await loadLibraries()

      const socket = new SockJS('http://localhost:8080/ws/quiz')
      stompClient = Stomp.over(socket)
      stompClient.reconnect_delay = 5000
      stompClient.debug = null

      await new Promise((resolve, reject) => {
        const timeout = setTimeout(() => reject(new Error('连接超时')), 10000)
        stompClient.connect({}, () => {
          clearTimeout(timeout)
          status.value = 'connected'
          statusText.value = '已连接'
          if (userId) {
            subscribeUserTopic(userId)
          }
          resolve()
        }, (err) => {
          clearTimeout(timeout)
          reject(err)
        })
      })
    } catch (e) {
      status.value = 'disconnected'
      statusText.value = '连接失败'
      setTimeout(() => {
        if (status.value === 'disconnected') {
          ensureConnected(userId)
        }
      }, 5000)
    } finally {
      isConnecting = false
    }
  }

  return {
    status,
    statusText,
    lastMessage,
    lastMessageSeq,
    lastTeacherMessage,
    lastTeacherMessageSeq,
    ensureConnected,
    subscribeTeacherTopic
  }
}, {
  persist: false
})
