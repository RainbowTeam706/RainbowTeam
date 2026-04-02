<!-- 此页面为“老师”点击主页面某一具体活动后跳转，显示活动信息、PPT预览、活动详情、底部导航 -->
<template>
  <div class="speech-page">
    <!-- 顶部导航栏 -->
    <div class="top-nav">
      <el-button class="back-btn" @click="$router.back()" link>
        <el-icon size="20"><ArrowLeft /></el-icon>
      </el-button>
      <div class="nav-title">
        <span>{{ activity.title }}({{ activity.createName }})</span>
        <el-tag
          :type="getStatusType(activity.status)"
          size="small"
          class="status-tag"
          >{{ getStatusText(activity.status) }}</el-tag
        >
      </div>
    </div>
    <!-- 活动简介小字 -->
    <!-- 内容区 -->

    <el-scrollbar max-height="560px" style="margin-top: 20px;">
      <div class="main-content">
        <!-- 活动详情 -->
        <div class="detail-content">
          <div class="invite-code small-invite center-invite">邀请码：{{ activity.inviteCode }}</div>
          <div class="activity-info-row multi-info-row">
            <span class="item-label" style="margin-left: 5px;">地点：</span>
            <span class="item-value">{{ activity.location }}</span>
            <span class="item-label" style="margin-left:18px;">人数：</span>
            <span class="item-value">{{ activity.curNum }}</span>
            <span class="item-label" style="margin-left:18px;"></span>
            <span class="item-value" style="margin-top: 5px;">{{ formatDate(activity.startTime) }} ~ {{ formatDate(activity.endTime) }}</span>
          </div>
          <div class="activity-content-brief" :title="activity.content">
            <span class="item-label">内容：</span>{{ activity.content }}
          </div>
        </div>
      </div>
 <el-dialog v-model="popquizDialogVisible" title="发题设置" width="350px">
  <el-form :model="popquizForm">
    <el-form-item label="题目数量(1-10)">
      <el-input v-model.number="popquizForm.count" type="number" min="1" max="10" placeholder="请输入题目数量" />
    </el-form-item>
    <el-form-item label="答题时长(分钟 1-30)">
      <el-input v-model.number="popquizForm.duration" type="number" min="1" max="30" placeholder="请输入总时长" />
    </el-form-item>
  </el-form>
  <template #footer>
    <el-button @click="popquizDialogVisible = false">取消</el-button>
    <el-button type="primary" @click="submitPopquiz">确定</el-button>
  </template>
</el-dialog>

<div class="popquiz-btn-row">
  <el-upload
    :show-file-list="false"
    :before-upload="handleFileUpload"
    :disabled="isActivityEnded"
    accept=".txt,.pdf,.pptx,.docx,.webm,.wav,.mp3,.m4a,.ogg"
  >
    <el-button type="primary" :disabled="isActivityEnded">上传文件（TXT/PDF/PPTX/DOCX/音频）</el-button>
  </el-upload>
</div>

<div class="record-btn-row">
  <el-button
    type="success"
    :disabled="isActivityEnded || isRecording"
    @click="startRecording"
  >
    开始录音
  </el-button>
  <el-button
    type="warning"
    :disabled="!isRecording"
    @click="stopRecording"
  >
    停止录音
  </el-button>
  <el-button
    type="primary"
    :disabled="isActivityEnded || !recordedBlob || isRecording"
    @click="uploadRecording"
  >
    上传录音
  </el-button>
</div>

<div class="ingest-task-list" v-if="ingestTaskList.length > 0">
  <div class="ingest-task-title">解析需要1~2分钟，请耐心等待...</div>
  <div class="ingest-task-item" v-for="task in ingestTaskList" :key="task.taskId">
    <div class="task-main">
      <div class="task-name">{{ task.fileName }}</div>
      <div class="task-error" v-if="task.errorMessage">{{ task.errorMessage }}</div>
    </div>
    <div class="task-side">
      <el-tag :type="getIngestStatusTagType(task.status)">{{ task.status }}</el-tag>
      <div class="task-actions">
        <el-button
          class="task-popquiz-btn"
          type="success"
          size="small"
          :disabled="!canSendPopQuiz(task)"
          @click="openPopQuizDialog(task)"
        >
          Pop quiz
        </el-button>
        <el-button
          class="task-result-btn"
          type="primary"
          plain
          size="small"
          :disabled="canSendPopQuiz(task)"
          @click="handleViewResult(task)"
        >
          答题结果
        </el-button>
      </div>
    </div>
  </div>
</div>
    </el-scrollbar>
    
    
    <!-- 统计弹窗 -->
    <el-dialog v-model="statDialogVisible" title="测试统计" width="90%">
      <div v-if="statData">
        <div style="margin-bottom: 16px;">
          <b>总题数：</b>{{ statData.totalQuestions }}
          <b style="margin-left: 24px;">总作答人数：</b>{{ statData.totalUsers }}
          <b style="margin-left: 24px;">总正确率：</b>{{ statData.overallAccuracy }}%
        </div>
        <div class="stat-questions-list">
          <div
            v-for="(q, idx) in statData.questions"
            :key="q.questionId"
            class="stat-question-card"
          >
            <div class="stat-q-content">{{ q.content }}</div>
            <ul class="stat-q-options">
              <li v-for="(opt, i) in q.options" :key="i">
                {{ formatOptionForStat(opt, i) }}
              </li>
            </ul>
            <div class="stat-q-info">
              <span>正确答案：<b>{{ q.correctAnswer }}</b></span>
              <span style="margin-left: 24px;">参与：{{ q.answeredCount }}</span>
              <span style="margin-left: 16px;">正确：{{ q.correctCount }}</span>
              <span style="margin-left: 16px;">正确率：{{ q.accuracy }}%</span>
            </div>
          </div>
        </div>
        <div style="width: 320px; height: 240px; margin: 24px auto 0;">
          <div id="stat-pie" style="width: 100%; height: 100%;"></div>
        </div>
      </div>
      <div v-else style="text-align:center;padding:40px 0;">
        <el-icon><Loading /></el-icon>
        <span>加载中...</span>
      </div>
    </el-dialog>

    <!-- 反馈弹窗 -->
    <el-dialog
      v-model="feedbackDialogVisible"
      title="💬 学生反馈"
      width="90%"
      :close-on-click-modal="false"
      class="feedback-dialog"
    >
      <div class="feedback-content">
        <div class="feedback-header">
          <span class="feedback-title">实时反馈统计</span>
          <el-button
            type="primary"
            size="small"
            @click="refreshFeedback"
            :loading="loadingFeedback"
          >
            刷新
          </el-button>
        </div>

        <div class="feedback-body">
          <!-- 实时反馈统计 -->
          <div class="feedback-stats">
            <!-- 节奏反馈 -->
            <div class="feedback-card">
              <h4 class="card-title">
                <el-icon><Loading /></el-icon>
                课堂节奏
              </h4>
              <div class="feedback-chart">
                <div class="chart-item">
                  <span class="chart-label">太快</span>
                  <div class="chart-bar">
                    <div class="chart-fill fast" :style="{ width: getFeedbackPercentage('pace', 'fast') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.pace.fast }}人</span>
                </div>
                <div class="chart-item">
                  <span class="chart-label">正好</span>
                  <div class="chart-bar">
                    <div class="chart-fill normal" :style="{ width: getFeedbackPercentage('pace', 'normal') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.pace.normal }}人</span>
                </div>
                <div class="chart-item">
                  <span class="chart-label">太慢</span>
                  <div class="chart-bar">
                    <div class="chart-fill slow" :style="{ width: getFeedbackPercentage('pace', 'slow') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.pace.slow }}人</span>
                </div>
              </div>
            </div>

            <!-- 难度反馈 -->
            <div class="feedback-card">
              <h4 class="card-title">
                <el-icon><Loading /></el-icon>
                内容难度
              </h4>
              <div class="feedback-chart">
                <div class="chart-item">
                  <span class="chart-label">太难</span>
                  <div class="chart-bar">
                    <div class="chart-fill hard" :style="{ width: getFeedbackPercentage('difficulty', 'hard') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.difficulty.hard }}人</span>
                </div>
                <div class="chart-item">
                  <span class="chart-label">适中</span>
                  <div class="chart-bar">
                    <div class="chart-fill normal" :style="{ width: getFeedbackPercentage('difficulty', 'normal') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.difficulty.normal }}人</span>
                </div>
                <div class="chart-item">
                  <span class="chart-label">太易</span>
                  <div class="chart-bar">
                    <div class="chart-fill easy" :style="{ width: getFeedbackPercentage('difficulty', 'easy') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.difficulty.easy }}人</span>
                </div>
              </div>
            </div>

            <!-- 理解程度 -->
            <div class="feedback-card">
              <h4 class="card-title">
                <el-icon><Loading /></el-icon>
                理解程度
              </h4>
              <div class="feedback-chart">
                <div class="chart-item">
                  <span class="chart-label">清楚</span>
                  <div class="chart-bar">
                    <div class="chart-fill clear" :style="{ width: getFeedbackPercentage('understanding', 'clear') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.understanding.clear }}人</span>
                </div>
                <div class="chart-item">
                  <span class="chart-label">困惑</span>
                  <div class="chart-bar">
                    <div class="chart-fill confused" :style="{ width: getFeedbackPercentage('understanding', 'confused') + '%' }"></div>
                  </div>
                  <span class="chart-value">{{ feedbackData.understanding.confused }}人</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 评论区弹窗 -->
    <!-- 替换为讨论区弹窗 -->
    <DiscussionArea
      v-model:visible="commentDialogVisible"
      :activity-id="activity.id"
      :my-user-id="userInfoStore.id"
      :my-user-name="userInfoStore.nickname || userInfoStore.username"
      :my-role="'teacher'"
      title="💬 讨论区"
      :activity-create-id="activity.createId"
    />

    <!-- 底部功能按钮组 -->
    <div class="bottom-action-bar">
      <div class="action-buttons-container">

        <!-- 反馈按钮 -->
        <el-button
          :type="activeTab === 'feedback' ? 'primary' : ''"
          class="action-btn"
          @click="goToFeedback"
        >
          <el-icon><ChatDotRound /></el-icon>
          <span>反馈</span>
        </el-button>

        <!-- 评论区按钮 -->
        <el-button
          :type="activeTab === 'comment' ? 'primary' : ''"
          class="action-btn"
          @click="showComment"
        >
          <el-icon><Comment /></el-icon>
          <span>评论区</span>
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import './Speech-Teacher.css'
import { ref, nextTick, watch, onMounted, onBeforeUnmount } from "vue";
import {
  ArrowLeft,
  Document,
  ChatDotRound,
  Comment,
  Loading,
} from "@element-plus/icons-vue";
import { useRoute } from 'vue-router'
import { useActivityStore } from '../stores/activity'
import { useQuizWsStore } from '../stores/quizWs.js'
import { computed } from 'vue'
import {
  getFeedbackStats,
} from '../api/feedback'
//文本提交相关
import { ElMessage } from "element-plus"
import { sendPopquiz, GetExamStat, uploadIngestFile, getIngestStatus, getIngestTaskList } from "../api/activity"

/** 1. 引入echarts和相关状态变量 */
import * as echarts from 'echarts'
const statDialogVisible = ref(false)
const statData = ref(null)

/** 2. 测试列表项点击后弹窗统计 */
const showStat = async (popQuizId) => {
  statDialogVisible.value = true
  statData.value = null
  try {
    

    const result = await GetExamStat(popQuizId)
    if (result.data.success) {
      statData.value = result.data.data
      nextTick(() => renderPieChart())
    } else {
      ElMessage.error(result.errorMsg || '获取统计失败')
      statDialogVisible.value = false
    }
  } catch (e) {
    ElMessage.error('获取统计失败')
    statDialogVisible.value = false
  }
}

/** 3. 渲染饼图 */
const renderPieChart = () => {
  if (!statData.value) return
  const chartDom = document.getElementById('stat-pie')
  if (!chartDom) return
  const myChart = echarts.init(chartDom)
  myChart.setOption({
    title: { text: '总正确/错误分布', left: 'center', top: 10, textStyle: { fontSize: 16 } },
    tooltip: { trigger: 'item' },
    legend: { bottom: 0, left: 'center' },
    series: [{
      name: '答题情况',
      type: 'pie',
      radius: '60%',
      data: [
        { value: statData.value.totalCorrect, name: '答对' },
        { value: statData.value.totalAnswered - statData.value.totalCorrect, name: '答错' }
      ]
    }]
  })
}

const popquizText = ref("")
const popquizDialogVisible = ref(false)
const popquizForm = ref({ count: 3, duration: 3 })
const selectedTaskForQuiz = ref(null)


// 反馈相关状态
const feedbackDialogVisible = ref(false) // 反馈弹窗
const loadingFeedback = ref(false) // 加载状态

// 反馈数据
const feedbackData = ref({
  pace: { fast: 12, normal: 25, slow: 3 },
  difficulty: { hard: 8, normal: 28, easy: 4 },
  understanding: { clear: 32, confused: 8 }
})

const commentDialogVisible = ref(false)


//查询活动信息
const route = useRoute()
const activityStore = useActivityStore()
const quizWsStore = useQuizWsStore()

const activity = computed(() => activityStore.getActivityById(route.params.id) || {})
const isActivityEnded = computed(() => Number(activity.value?.status) === 2)


// 打开反馈弹窗
async function goToFeedback() {
  activeTab.value = 'feedback' // 设置激活状态
  feedbackDialogVisible.value = true
  await refreshFeedback()
}

// 切换到评论区
function showComment() {
  activeTab.value = 'comment'
  commentDialogVisible.value = true
}

// 监听反馈弹窗关闭，重置按钮状态
watch(feedbackDialogVisible, (newVal) => {
  if (!newVal && activeTab.value === 'feedback') {
    // 弹窗关闭时，如果当前是反馈状态，则重置为默认状态
    activeTab.value = ''
  }
})

// 监听评论区弹窗关闭，重置按钮状态
watch(commentDialogVisible, (newVal) => {
  if (!newVal && activeTab.value === 'comment') {
    // 弹窗关闭时，如果当前是评论区状态，则重置为默认状态
    activeTab.value = ''
  }
})

// 反馈相关方法
// 计算反馈百分比
function getFeedbackPercentage(category, type) {
  const data = feedbackData.value[category]
  const total = Object.values(data).reduce((sum, count) => sum + count, 0)
  return total > 0 ? Math.round((data[type] / total) * 100) : 0
}

// 刷新反馈数据
async function refreshFeedback() {
  loadingFeedback.value = true
  try {
    // 获取反馈统计数据
    
    const statsResponse = await getFeedbackStats(route.params.id)
    console.log(route.params.id)
    // 更新反馈统计数据
    if (statsResponse.data && statsResponse.data.success) {
      const stats = statsResponse.data.data
      feedbackData.value.pace = stats.pace || { fast: 0, normal: 0, slow: 0 }
      feedbackData.value.difficulty = stats.difficulty || { hard: 0, normal: 0, easy: 0 }
      feedbackData.value.understanding = stats.understanding || { clear: 0, confused: 0 }
    }

    ElMessage.success('反馈数据已刷新')
  } catch (error) {
    console.error('刷新反馈数据失败:', error)
    ElMessage.error('刷新失败，请稍后重试')
  } finally {
    loadingFeedback.value = false
  }
}

// 格式化时间显示
function formatTimeForDisplay(timeString) {
  if (!timeString) return ''

  try {
    const date = new Date(timeString)
    return date.toLocaleTimeString('zh-CN', {
      hour: '2-digit',
      minute: '2-digit'
    })
  } catch (error) {
    console.error('时间格式化失败:', error)
    return timeString
  }
}


const ingestTaskList = ref([])
const wsStatusText = computed(() => quizWsStore.statusText)
let ingestPollTimers = new Map()

// 录音相关状态
const isRecording = ref(false)
const recordedBlob = ref(null)
const recordedMimeType = ref('audio/webm')
let mediaRecorder = null
let mediaStream = null
let recordedChunks = []

watch(() => activity.value?.id, async (newId, oldId) => {
  if (newId && newId !== oldId) {
    quizWsStore.subscribeTeacherTopic(newId)
    await loadIngestTaskList()
  }
})

async function uploadFileToIngest(file) {
  if (isActivityEnded.value) {
    ElMessage.warning('活动已结束，不能上传文件')
    return false
  }

  try {
    const uploadRes = await uploadIngestFile(file, activity.value.id)
    const accepted = uploadRes?.data?.data || uploadRes?.data
    const taskId = accepted?.taskId
    if (!taskId) {
      ElMessage.error('上传成功但未返回任务ID')
      return false
    }

    ingestTaskList.value.unshift({
      taskId,
      fileName: file.name,
      status: accepted?.status || 'PENDING',
      popQuizId: null,
      sent: 0,
      createdAt: Date.now(),
      textLength: 0,
      errorMessage: ''
    })

    ElMessage.success('文件已上传，后台正在解析')
    startStatusPolling(taskId)
    return true
  } catch (e) {
    ElMessage.error('文件上传失败')
    return false
  }
}

// 处理文件上传（后端解析）
async function handleFileUpload(file) {
  await uploadFileToIngest(file)
  // 阻止 el-upload 默认上传行为
  return false
}

async function startRecording() {
  if (isActivityEnded.value) {
    ElMessage.warning('活动已结束，不能录音')
    return
  }
  try {
    mediaStream = await navigator.mediaDevices.getUserMedia({ audio: true })
    const supportedType = MediaRecorder.isTypeSupported('audio/webm;codecs=opus')
      ? 'audio/webm;codecs=opus'
      : 'audio/webm'

    mediaRecorder = new MediaRecorder(mediaStream, { mimeType: supportedType })
    recordedChunks = []

    mediaRecorder.ondataavailable = (event) => {
      if (event.data && event.data.size > 0) {
        recordedChunks.push(event.data)
      }
    }

    mediaRecorder.onstop = () => {
      if (recordedChunks.length > 0) {
        const mime = mediaRecorder?.mimeType || 'audio/webm'
        recordedMimeType.value = mime
        recordedBlob.value = new Blob(recordedChunks, { type: mime })
      }

      if (mediaStream) {
        mediaStream.getTracks().forEach(track => track.stop())
        mediaStream = null
      }
      mediaRecorder = null
      recordedChunks = []
      isRecording.value = false
      ElMessage.success('录音完成，可点击“上传录音”')
    }

    mediaRecorder.start()
    isRecording.value = true
    recordedBlob.value = null
    ElMessage.success('开始录音')
  } catch (error) {
    console.error('开始录音失败:', error)
    ElMessage.error('无法访问麦克风，请检查浏览器权限')
  }
}

function stopRecording() {
  if (!mediaRecorder || !isRecording.value) return
  mediaRecorder.stop()
}

async function uploadRecording() {
  if (isActivityEnded.value) {
    ElMessage.warning('活动已结束，不能上传录音')
    return
  }
  if (!recordedBlob.value) {
    ElMessage.warning('暂无可上传的录音')
    return
  }

  const ext = recordedMimeType.value.includes('ogg') ? 'ogg' : 'webm'
  const fileName = `recording-${Date.now()}.${ext}`
  const audioFile = new File([recordedBlob.value], fileName, { type: recordedMimeType.value || 'audio/webm' })

  const ok = await uploadFileToIngest(audioFile)
  if (ok) {
    recordedBlob.value = null
  }
}

function startStatusPolling(taskId) {
  if (ingestPollTimers.has(taskId)) return

  const timer = setInterval(async () => {
    try {
      const res = await getIngestStatus(taskId)
      const statusData = res?.data?.data || res?.data
      if (!statusData) return

      const idx = ingestTaskList.value.findIndex(t => t.taskId === taskId)
      if (idx >= 0) {
        ingestTaskList.value[idx].status = statusData.status
        ingestTaskList.value[idx].textLength = statusData.textLength || 0
        ingestTaskList.value[idx].errorMessage = statusData.errorMessage || ''
        if (statusData.popQuizId) ingestTaskList.value[idx].popQuizId = statusData.popQuizId
      }

      if (statusData.status === 'SUCCESS' || statusData.status === 'FAILED') {
        clearInterval(timer)
        ingestPollTimers.delete(taskId)
        if (statusData.status === 'SUCCESS') {
          ElMessage.success(`文件解析完成：${taskId}`)
        } else {
          ElMessage.error(`文件解析失败：${statusData.errorMessage || '未知错误'}`)
        }
      }
    } catch (e) {
      // 轮询失败时不打断，下一轮继续
    }
  }, 4000)

  ingestPollTimers.set(taskId, timer)
}

function getIngestStatusTagType(status) {
  if (status === 'SUCCESS') return 'success'
  if (status === 'FAILED') return 'danger'
  if (status === 'PROCESSING') return 'warning'
  return 'info'
}

function applyIngestStatusMessage(msg) {
  if (!msg || msg.type !== 'FILE_INGEST_STATUS') return
  const taskId = msg.taskId
  if (!taskId) return

  const idx = ingestTaskList.value.findIndex(t => t.taskId === taskId)
  if (idx < 0) return

  ingestTaskList.value[idx].status = msg.status || ingestTaskList.value[idx].status
  ingestTaskList.value[idx].errorMessage = msg.errorMessage || ''
  if (typeof msg.textLength === 'number') {
    ingestTaskList.value[idx].textLength = msg.textLength
  }
  if (msg.popQuizId) {
    ingestTaskList.value[idx].popQuizId = msg.popQuizId
  }

  if (msg.status === 'SUCCESS' || msg.status === 'FAILED') {
    const timer = ingestPollTimers.get(taskId)
    if (timer) {
      clearInterval(timer)
      ingestPollTimers.delete(taskId)
    }
  }
}
async function loadIngestTaskList() {
  if (!activity.value?.id) return
  try {
    const res = await getIngestTaskList(activity.value.id)
    const list = res?.data?.data || res?.data || []
    ingestTaskList.value = list.map(item => ({
      taskId: item.taskId,
      fileName: item.fileName,
      status: item.status,
      popQuizId: item.popQuizId || null,
      sent: Number(item.sent || 0),
      textLength: item.textLength || 0,
      errorMessage: item.errorMessage || '',
      createdAt: item.createdAt || Date.now()
    }))
  } catch (e) {
    // ignore load history failure
  }
}

function canSendPopQuiz(task) {
  return !isActivityEnded.value && !!task && task.status === 'SUCCESS' && !!task.popQuizId && Number(task.sent || 0) === 0
}

function openPopQuizDialog(task) {
  if (isActivityEnded.value) {
    ElMessage.warning('活动已结束，不能发题')
    return
  }
  if (!canSendPopQuiz(task)) {
    ElMessage.warning('当前任务不可发题')
    return
  }
  selectedTaskForQuiz.value = task
  popquizDialogVisible.value = true
}

// Popquiz按钮提交（一个测验只允许发一次）
async function submitPopquiz() {
  if (isActivityEnded.value) {
    ElMessage.warning('活动已结束，不能发题')
    popquizDialogVisible.value = false
    return
  }

  if (!selectedTaskForQuiz.value || !selectedTaskForQuiz.value.popQuizId) {
    ElMessage.error('未选择可发题的测验')
    return
  }
  if (!popquizForm.value.count || !popquizForm.value.duration) {
    ElMessage.error('请填写题目数量和时长')
    return
  }

  const count = Number(popquizForm.value.count)
  const duration = Number(popquizForm.value.duration)
  if (!Number.isInteger(count) || count < 1 || count > 10) {
    ElMessage.error('题目数量必须是1到10之间的整数')
    return
  }
  if (!Number.isInteger(duration) || duration < 1 || duration > 30) {
    ElMessage.error('答题时长必须是1到30分钟之间的整数')
    return
  }

  try {
    await sendPopquiz({
      popQuizId: selectedTaskForQuiz.value.popQuizId,
      questionCount: popquizForm.value.count,
      lastTime: popquizForm.value.duration
    })

    const idx = ingestTaskList.value.findIndex(t => t.taskId === selectedTaskForQuiz.value.taskId)
    if (idx >= 0) {
      ingestTaskList.value[idx].sent = 1
    }

    ElMessage.success('发题成功')
    popquizDialogVisible.value = false
    selectedTaskForQuiz.value = null
  } catch (e) {
    ElMessage.error(e?.response?.data?.errorMsg || '发题失败')
  }
}

const activeTab = ref("");
const getStatusText = (status) => {
  switch (status) {
    case 0:
      return "未开始";
    case 1:
      return "进行中";
    case 2:
      return "已结束";
    default:
      return "未知";
  }
};
function getStatusType(status) {
  switch (status) {
    case 0:
      return "primary";
    case 1:
      return "success";
    case 2:
      return "info";
    default:
      return "warning";
  }
}
// 格式化时间
function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleString('zh-CN', { hour12: false });
}

// 统计弹窗选项文案：避免后端已带 A./B. 时前端再次拼接导致重复
function formatOptionForStat(opt, index) {
  const text = String(opt ?? '').trim()
  const prefixReg = /^[A-D][\.、\s]+/i
  if (prefixReg.test(text)) {
    return text
  }
  return `${String.fromCharCode(65 + index)}. ${text}`
}

const handleViewResult = async (task) => {
  if (!task || !task.popQuizId) {
    ElMessage.warning('该任务暂无可查看的答题结果')
    return
  }

  // 规则：Pop quiz可点击时，答题结果不可点击
  if (canSendPopQuiz(task)) {
    ElMessage.warning('请先发题后再查看答题结果')
    return
  }

  try {
    await showStat(task.popQuizId)
  } catch (e) {
    ElMessage.error('打开答题结果失败')
  }
}

onMounted(async () => {
  await quizWsStore.ensureConnected(userInfoStore.id)
  if (activity.value?.id) {
    quizWsStore.subscribeTeacherTopic(activity.value.id)
    await loadIngestTaskList()
  }
})

watch(() => quizWsStore.lastTeacherMessageSeq, () => {
  applyIngestStatusMessage(quizWsStore.lastTeacherMessage)
})

onBeforeUnmount(() => {
  ingestPollTimers.forEach((timer) => clearInterval(timer))
  ingestPollTimers.clear()
})

import DiscussionArea from '../components/DiscussionArea.vue'
import { useUserInfoStore } from '../stores/userInfo.js'
const userInfoStore = useUserInfoStore()
</script>

