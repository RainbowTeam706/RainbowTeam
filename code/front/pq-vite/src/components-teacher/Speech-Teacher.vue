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
       <!-- 文本输入框 /////////////////////////////////-->
        <!-- 文本输入区 -->
<el-input
  v-model="popquizText"
  type="textarea"
  :rows="14"
  placeholder="请在此输入或上传文件自动填充文本"
  class="popquiz-input"
></el-input>

<el-dialog v-model="popquizDialogVisible" title="生成题目" width="350px">
  <el-form :model="popquizForm">
    <el-form-item label="题目数量">
      <el-input v-model.number="popquizForm.count" type="number" min="1" placeholder="请输入题目数量" />
    </el-form-item>
    <el-form-item label="答题时长(分钟)">
      <el-input v-model.number="popquizForm.duration" type="number" min="1" placeholder="请输入总时长" />
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
    accept=".pdf,.ppt,.pptx"
  >
    <el-button type="primary">上传PDF/PPT</el-button>
  </el-upload>
  <el-button
    :type="isRecording ? 'danger' : 'primary'"
    @click="toggleRecording"
    style="margin-left: 20px;"
  >
    {{ isRecording ? '停止录音' : '开始录音转文本' }}
  </el-button>
  <el-button type="success" @click="popquizDialogVisible = true" style="margin-left: 16px;">Popquiz</el-button>
</div>
    </el-scrollbar>
    
    <!-- 测试列表弹窗 -->
    <el-dialog
      v-model="testListDialogVisible"
      title="📋 测试列表"
      width="90%"
      :close-on-click-modal="false"
      class="test-list-dialog"
    >
      <div class="test-list-content">
        <div class="test-list-header">
          <span class="test-list-title">活动测试记录</span>
          <el-button 
            type="primary" 
            size="small" 
            @click="refreshTestList"
            :loading="loadingTestList"
          >
            刷新
          </el-button>
        </div>
        
        <div class="test-list-body">
          <div v-if="testListData.length === 0" class="empty-state">
            <el-icon size="48" color="#C0C4CC"><Document /></el-icon>
            <p>暂无测试记录</p>
          </div>
          
          <div v-else class="test-items">
            <div 
              v-for="(test, index) in testListData" 
              :key="test.id"
              class="test-item"
              @click="showStat(test.id)"
            >
              <div class="test-item-header">
                <span class="test-title">测试{{ index + 1 }}</span>
                <span class="test-status" :class="getTestStatusClass(test.status)">
                  {{ getTestStatusText(test.status) }}
                </span>
              </div>
              <div class="test-item-content">
                <div class="test-info">
                  <span class="info-label">开始时间：</span>
                  <span class="info-value">{{ formatDateTime(test.startTime) }}</span>
                </div>
                <div class="test-info">
                  <span class="info-label">结束时间：</span>
                  <span class="info-value">{{ formatDateTime(test.endTime) }}</span>
                </div>
                <div class="test-info">
                  <span class="info-label">持续时间：</span>
                  <span class="info-value">{{ test.durationMinutes }} 分钟</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
    
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
                {{ String.fromCharCode(65 + i) }}. {{ opt }}
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
    <el-dialog
      v-model="commentDialogVisible"
      title="💬 学生提问"
      width="90%"
      :close-on-click-modal="false"
      class="comment-dialog"
    >
      <div class="comment-content">
        <div class="comment-header">
          <span class="comment-title">学生提问列表</span>
          <el-button
            type="primary"
            size="small"
            @click="refreshComments"
            :loading="loadingComments"
          >
            刷新
          </el-button>
        </div>

        <div class="comment-body">
          <!-- 筛选按钮 -->
          <div class="filter-buttons">
            <el-button
              :type="commentFilter === 'all' ? 'primary' : ''"
              size="small"
              @click="commentFilter = 'all'"
            >
              全部 ({{ commentData.questions.length }})
            </el-button>
            <el-button
              :type="commentFilter === 'unanswered' ? 'primary' : ''"
              size="small"
              @click="commentFilter = 'unanswered'"
            >
              未解答 ({{ unansweredCountComment }})
            </el-button>
            <el-button
              :type="commentFilter === 'answered' ? 'primary' : ''"
              size="small"
              @click="commentFilter = 'answered'"
            >
              已解答 ({{ answeredCountComment }})
            </el-button>
          </div>

          <div class="questions-list">
            <div
              v-for="question in filteredComments"
              :key="question.id"
              class="question-item"
              :class="{
                'answered': question.answered,
                'unanswered': !question.answered
              }"
            >
              <div class="question-header">
                <span class="question-time">{{ question.time }}</span>
                <div class="question-tags">
                  <el-tag v-if="question.anonymous" size="small" type="info">匿名</el-tag>
                  <el-tag v-if="question.answered" size="small" type="success">
                    <el-icon><Check /></el-icon>
                    已解答
                  </el-tag>
                  <el-tag v-if="!question.answered" size="small" type="warning">
                    <el-icon><QuestionFilled /></el-icon>
                    待解答
                  </el-tag>
                </div>
              </div>
              <div class="question-content">{{ question.content }}</div>
              <div class="question-actions" v-if="!question.answered">
                <el-button
                  size="small"
                  type="success"
                  @click="markAsAnswered(question.id)"
                  :loading="markingAnsweredComment === question.id"
                >
                  <el-icon><Check /></el-icon>
                  标记为已解答
                </el-button>
              </div>
            </div>

            <!-- 空状态 -->
            <div v-if="filteredComments.length === 0" class="empty-state">
              <el-icon size="48"><ChatDotRound /></el-icon>
              <p>{{ getCommentEmptyStateText() }}</p>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 底部功能按钮组 -->
    <div class="bottom-action-bar">
      <div class="action-buttons-container">
        <!-- 测试列表按钮 -->
        <el-button
          :type="activeTab === 'test' ? 'primary' : ''"
          class="action-btn"
          @click="showTestList"
        >
          <el-icon><Document /></el-icon>
          <span>测试列表</span>
        </el-button>

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
import { ref, nextTick, watch } from "vue";
import {
  ArrowLeft,
  Document,
  ChatDotRound,
  Comment,
  CircleCheck,
  CircleClose,
  Timer,
  Check,
  QuestionFilled,
  Loading,
} from "@element-plus/icons-vue";
import { useRoute } from 'vue-router'
import { useActivityStore } from '../stores/activity'
import { computed } from 'vue'
import {
  getFeedbackStats,
  getQuestions,
  markQuestionAnswered
} from '../api/feedback'
//文本提交相关
import * as pdfjsLib from "pdfjs-dist"
pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdf.worker.js"
import JSZip from "jszip" //解析ppt文件
//import PPTX from "pptxjs"
import { ElMessage } from "element-plus"
import { sendPopquiz,ExamList,GetExamStat } from "../api/activity" // 你需要实现这个API

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
const popquizForm = ref({ count: 1, duration: 10 })

// 测试列表相关状态
const testListDialogVisible = ref(false) // 测试列表弹窗
const testListData = ref([]) // 测试列表数据
const loadingTestList = ref(false) // 加载状态

// 反馈相关状态
const feedbackDialogVisible = ref(false) // 反馈弹窗
const loadingFeedback = ref(false) // 加载状态

// 反馈数据
const feedbackData = ref({
  pace: { fast: 12, normal: 25, slow: 3 },
  difficulty: { hard: 8, normal: 28, easy: 4 },
  understanding: { clear: 32, confused: 8 }
})




//评论区相关状态
const commentDialogVisible = ref(false) // 评论区弹窗
const commentData = ref({ // 评论区数据
  questions: [
    {
      id: 1,
      content: "这个概念能再解释一下吗？PPT第3页的内容有点难理解。",
      time: "10:30",
      anonymous: true,
      answered: false
    },
    {
      id: 2,
      content: "PPT第5页的公式推导过程能详细说明一下吗？",
      time: "10:25",
      anonymous: false,
      answered: false
    },
    {
      id: 3,
      content: "能举个具体的实际应用例子吗？",
      time: "10:20",
      anonymous: true,
      answered: true
    },
    {
      id: 4,
      content: "这个理论在实际工作中如何应用？",
      time: "10:15",
      anonymous: false,
      answered: false
    }
  ]
})
const loadingComments = ref(false) // 评论区加载状态
const commentFilter = ref('all') // 评论区问题筛选
const markingAnsweredComment = ref(null) // 正在标记为已解答的评论区问题ID

//查询活动信息
const route = useRoute()
const activityStore = useActivityStore()

const activity = computed(() => activityStore.getActivityById(route.params.id) || {})

// 反馈相关计算属性
const unansweredCountComment = computed(() =>
  commentData.value.questions.filter(q => !q.answered).length
)

const answeredCountComment = computed(() =>
  commentData.value.questions.filter(q => q.answered).length
)

// 评论区相关计算属性
const filteredComments = computed(() => {
  switch (commentFilter.value) {
    case 'unanswered':
      return commentData.value.questions.filter(q => !q.answered)
    case 'answered':
      return commentData.value.questions.filter(q => q.answered)
    default:
      return commentData.value.questions
  }
})

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
  refreshComments() // 刷新评论区数据
}

// 监听测试列表弹窗关闭，重置按钮状态
watch(testListDialogVisible, (newVal) => {
  if (!newVal && activeTab.value === 'test') {
    // 弹窗关闭时，如果当前是测试列表状态，则重置为默认状态
    activeTab.value = ''
  }
})

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

// 评论区相关方法
// 刷新评论区数据
async function refreshComments() {
  loadingComments.value = true
  try {
    const response = await getQuestions(route.params.id, {
      status: commentFilter.value === 'all' ? 'all' : commentFilter.value,
      page: 1,
      size: 100
    })

    if (response.data && response.data.success) {
      const questions = response.data.data.questions || []
      commentData.value.questions = questions.map(q => ({
        id: q.id,
        content: q.content,
        time: formatTimeForDisplay(q.time),
        anonymous: q.anonymous,
        answered: q.answered
      }))
    }
    ElMessage.success('评论区数据已刷新')
  } catch (error) {
    console.error('刷新评论区数据失败:', error)
    ElMessage.error('刷新失败，请稍后重试')
  } finally {
    loadingComments.value = false
  }
}

// 标记问题已解答
async function markAsAnswered(questionId) {
  // 防止重复点击
  if (markingAnsweredComment.value === questionId) {
    return
  }

  markingAnsweredComment.value = questionId

  try {
    // 调用API标记已解答
    const response = await markQuestionAnswered(questionId)

    if (response.data && response.data.success) {
      // 立即更新本地状态，提供即时反馈
      const question = commentData.value.questions.find(q => q.id === questionId)
      if (question) {
        question.answered = true
      }

      ElMessage({
        message: '问题已标记为已解答',
        type: 'success',
        duration: 2000,
        showClose: true
      })

      // 刷新问题列表以确保数据同步
      await refreshComments()
    } else {
      ElMessage.error(response.data?.message || '标记失败，请重试')
    }
  } catch (error) {
    console.error('标记已解答失败:', error)
    ElMessage.error('网络错误，请检查连接后重试')
  } finally {
    markingAnsweredComment.value = null
  }
}

// 标记评论区问题已解答
async function markAsAnsweredComment(questionId) {
  // 防止重复点击
  if (markingAnsweredComment.value === questionId) {
    return
  }

  markingAnsweredComment.value = questionId

  try {
    // 调用API标记已解答
    const response = await markQuestionAnswered(questionId)

    if (response.data && response.data.success) {
      // 立即更新本地状态，提供即时反馈
      const question = commentData.value.questions.find(q => q.id === questionId)
      if (question) {
        question.answered = true
      }

      ElMessage({
        message: '问题已标记为已解答',
        type: 'success',
        duration: 2000,
        showClose: true
      })

      // 刷新问题列表以确保数据同步
      await refreshComments()
    } else {
      ElMessage.error(response.data?.message || '标记失败，请重试')
    }
  } catch (error) {
    console.error('标记已解答失败:', error)
    ElMessage.error('网络错误，请检查连接后重试')
  } finally {
    markingAnsweredComment.value = null
  }
}

// 获取评论区空状态文本
function getCommentEmptyStateText() {
  switch (commentFilter.value) {
    case 'unanswered':
      return '暂无待解答的问题'
    case 'answered':
      return '暂无已解答的问题'
    default:
      return '暂无学生提问'
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


const isRecording = ref(false)
let recognition = null
//录音按钮
function toggleRecording() {
  if (!isRecording.value) {
    startRecording()
  } else {
    stopRecording()
  }
}
//录音内容
function startRecording() {
  // 兼容性判断
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
  if (!SpeechRecognition) {
    ElMessage.error("当前浏览器不支持语音识别")
    return
  }
  recognition = new SpeechRecognition()
  recognition.lang = "zh-CN" // 可根据需要设置语言
  recognition.continuous = false
  recognition.interimResults = false

  recognition.onstart = () => {
    isRecording.value = true
    ElMessage.info("开始录音，请说话...")
  }
  recognition.onerror = (event) => {
    isRecording.value = false
    ElMessage.error("录音出错: " + event.error)
  }
  recognition.onend = () => {
    isRecording.value = false
    ElMessage.info("录音结束")
  }
  recognition.onresult = (event) => {
    const transcript = event.results[0][0].transcript
    popquizText.value = transcript // 覆盖文本框
    ElMessage.success("识别成功，已填入文本框")
  }

  recognition.start()
}

function stopRecording() {
  if (recognition) {
    recognition.stop()
  }
}
// 处理文件上传
async function handleFileUpload(file) {
  console.log('upload',file)
  const ext = file.name.split('.').pop().toLowerCase()
  if (ext === 'pdf') {
    await readPdf(file)
  } else if (ext === 'pptx') {
    await readPptx(file)
  } else {
    ElMessage.error("只支持PDF或PPTX文件")
    return false
  }
  return false // 阻止自动上传
}
// 读取PDF文本
async function readPdf(file) {
  try {
    const arrayBuffer = await file.arrayBuffer()
   // console.log('arrayBuffer', arrayBuffer)
    const pdf = await pdfjsLib.getDocument({ data: arrayBuffer }).promise
  //  console.log('pdf loaded', pdf)
    let text = ""
    for (let i = 1; i <= pdf.numPages; i++) {
   //   console.log('reading page', i)
      const page = await pdf.getPage(i)
      const content = await page.getTextContent()
   //   console.log('page content', content)
      text += content.items.map(item => item.str).join(" ") + "\n"
    }
  //  console.log('text', text)
    popquizText.value = text
  } catch (e) {
    console.error('readPdf error', e)
  }
}
// 读取PPTX文本
async function readPptx(file) {
  try {
    const arrayBuffer = await file.arrayBuffer()
    const zip = await JSZip.loadAsync(arrayBuffer)
    let text = ""

    // 找到所有幻灯片文件
    const slideFiles = Object.keys(zip.files)
      .filter(name => /^ppt\/slides\/slide[0-9]+\.xml$/.test(name))
      .sort((a, b) => {
        const aMatch = a.match(/slide([0-9]+)\.xml/)
        const bMatch = b.match(/slide([0-9]+)\.xml/)
        const aNum = aMatch ? parseInt(aMatch[1]) : 0
        const bNum = bMatch ? parseInt(bMatch[1]) : 0
        return aNum - bNum
      })

    for (const slideName of slideFiles) {
      const xmlString = await zip.files[slideName].async("string")
      const parser = new DOMParser()
      const xmlDoc = parser.parseFromString(xmlString, "application/xml")
      const tNodes = xmlDoc.getElementsByTagName("a:t")
      for (let i = 0; i < tNodes.length; i++) {
        text += tNodes[i].textContent + " "
      }
      text += "\n"
    }
    popquizText.value = text
    console.log('pptx text', text)
  } catch (e) {
    ElMessage.error("PPTX解析失败，请尝试其他文件或联系开发者")
    console.error('pptx parse error', e)
  }
}
// Popquiz按钮提交
async function submitPopquiz() {
  if (!popquizText.value.trim()) {
    ElMessage.error("内容不能为空")
    return
  }
  if (!popquizForm.value.count || !popquizForm.value.duration) {
    ElMessage.error("请填写题目数量和时长")
    return
  }
  try {
      await sendPopquiz({
    activityId: activity.value.id,
    questionCount: popquizForm.value.count,
    lastTime: popquizForm.value.duration,
    text: popquizText.value
    })
    ElMessage.success("已发送到后端！")
    popquizDialogVisible.value = false
  } catch (e) {
    console.log(e)
    if(e.message === "timeout of 5000ms exceeded"){
    ElMessage.success("已发送到后端！")
    popquizDialogVisible.value = false
  }
  else {
      ElMessage.error("发送失败")
  }
  //  ElMessage.error("发送失败")
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

// 测试列表相关函数
const showTestList = async () => {
  activeTab.value = 'test' // 设置激活状态
  testListDialogVisible.value = true
  await refreshTestList()
}

// 刷新测试列表
const refreshTestList = async () => {
  if (!route.params.id) {
    ElMessage.error('缺少活动ID')
    return
  }
  
  loadingTestList.value = true
  try {
    const result = await ExamList(route.params.id);
    
    if (result.data.success) {
      testListData.value = result.data.data || []
      console.log('测试列表数据:', testListData.value)
    } else {
      ElMessage.error('获取测试列表失败: ' + (result.errorMsg || '未知错误'))
    }
  } catch (error) {
    console.error('获取测试列表失败:', error)
    ElMessage.error('获取测试列表失败: ' + error.message)
  } finally {
    loadingTestList.value = false
  }
}

// 格式化日期时间
const formatDateTime = (dateTimeStr) => {
  if (!dateTimeStr) return '未知'
  try {
    const date = new Date(dateTimeStr)
    return date.toLocaleString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    })
  } catch (error) {
    return dateTimeStr
  }
}

// 获取测试状态文本
const getTestStatusText = (status) => {
  switch (status) {
    case 0: return '进行中'
    case 1: return '已结束'
    default: return '未知'
  }
}

// 获取测试状态样式类
const getTestStatusClass = (status) => {
  switch (status) {
    case 0: return 'status-active'
    case 1: return 'status-completed'
    default: return 'status-unknown'
  }
}
</script>

<style scoped>
.speech-page {
  min-height: 100vh;
  background: #f5f7fa;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
  padding-bottom: 90px; /* 为新的按钮组预留空间 */
}
.top-nav {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 0 16px;
  height: 52px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.back-btn {
  color: white;
  margin-right: 12px;
}
.nav-title {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  gap: 12px;
}
.status-tag {
  font-size: 0.8rem;
  padding: 4px 8px;
  border-radius: 12px;
}
.activity-info-row {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  font-size: 0.92rem;
  color: #333;
  padding: 2px 0;
}
.activity-info-row .item-label {
  font-weight: bold;
  color: #222;
  min-width: 40px;
  margin-right: 6px;
  font-size: 0.92rem;
}
.activity-info-row .item-value {
  color: #409eff;
  font-weight: 500;
  font-size: 0.92rem;
}
.activity-content-brief {
  background-color: #f0f4fa;
  font-size: 0.92rem;
  color: #333;
  padding: 8px 14px;
  margin: 14px 0 0 0;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(64,158,255,0.08);
  white-space: pre-line;
  word-break: break-all;
}
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 18px;
  padding: 0 20px;
}
.ppt-preview {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  min-height: 220px;
  max-height: 380px;
  margin-bottom: 8px;
  overflow: auto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.ppt-iframe {
  width: 100%;
  height: 360px;
  border: none;
}
.ppt-placeholder {
  color: #bbb;
  font-size: 1.1rem;
  text-align: center;
  padding: 40px 0;
}
.detail-content {
  background: #fff;
  border-radius: 16px;
  padding: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  max-width: 350px;
  word-break: break-all;
  margin: 0 auto;
}
.invite-code {
  text-align: center;
  font-size: 1.3rem;
  font-weight: bold;
  color: #409eff;
  margin-bottom: 18px;
}
.activity-detail-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
.activity-detail-list li {
  text-align: left;
  font-size: 0.8rem;
  color: #333;
  margin-bottom: 10px;
  font-weight: 500;
  word-break: break-all;
  white-space: pre-line;
}
.activity-detail-list li .item-label {
  font-weight: bold;
  color: #222;
}
/* 底部功能按钮组样式 */
.bottom-action-bar {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-top: 1px solid #e9ecef;
  padding: 16px 20px;
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.08);
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10;
  backdrop-filter: blur(10px);
}

.action-buttons-container {
  display: flex;
  gap: 16px;
  justify-content: center;
  align-items: center;
  max-width: 480px; /* 减少最大宽度以适应三个按钮 */
  margin: 0 auto;
}

.action-btn {
  flex: 1;
  min-height: 52px; /* 稍微增加高度 */
  border-radius: 14px; /* 增加圆角 */
  font-size: 0.9rem;
  font-weight: 500;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 10px 16px; /* 增加内边距 */
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid transparent;
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.12); /* 增强阴影 */
}

.action-btn:not(.el-button--primary) {
  background: white;
  color: #606266;
  border-color: #dcdfe6;
}

.action-btn:not(.el-button--primary):hover {
  background: #f5f7fa;
  border-color: #409eff;
  color: #409eff;
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(64, 158, 255, 0.2);
}

.action-btn.el-button--primary {
  background: linear-gradient(135deg, #409eff 0%, #3a8ee6 100%);
  border-color: #409eff;
  color: white;
  transform: translateY(-1px);
  box-shadow: 0 4px 16px rgba(64, 158, 255, 0.3);
}

.action-btn.el-button--primary:hover {
  background: linear-gradient(135deg, #3a8ee6 0%, #337ecc 100%);
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
}

.action-btn .el-icon {
  font-size: 1.2rem;
}

.action-btn span {
  font-size: 0.8rem;
  line-height: 1;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .bottom-action-bar {
    padding: 12px 16px;
  }

  .action-buttons-container {
    gap: 12px; /* 保持较好的间距 */
    max-width: 360px; /* 适配移动端宽度 */
  }

  .action-btn {
    min-height: 48px; /* 保持足够的点击区域 */
    padding: 8px 12px;
    font-size: 0.85rem;
  }

  .action-btn .el-icon {
    font-size: 1.1rem;
  }

  .action-btn span {
    font-size: 0.75rem;
  }
}

@media (max-width: 480px) {
  .bottom-action-bar {
    padding: 10px 12px;
  }

  .action-buttons-container {
    gap: 8px; /* 保持合适的间距 */
    max-width: 300px; /* 进一步缩小宽度 */
  }

  .action-btn {
    min-height: 44px; /* 保持足够的点击区域 */
    padding: 6px 10px;
    font-size: 0.8rem;
    border-radius: 12px; /* 稍微减少圆角 */
  }

  .action-btn .el-icon {
    font-size: 1rem;
  }

  .action-btn span {
    font-size: 0.7rem;
  }
}

/* 反馈弹窗样式 */
.feedback-dialog .el-dialog__body {
  padding: 0;
  max-height: 70vh;
  overflow-y: auto;
}

.feedback-content {
  padding: 20px;
}

.feedback-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 1px solid #ebeef5;
}

.feedback-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #303133;
}

.feedback-body {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.feedback-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 16px;
}

.feedback-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.3s;
}

.feedback-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.card-title {
  font-size: 1rem;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.feedback-chart {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.chart-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.chart-label {
  min-width: 40px;
  font-size: 0.9rem;
  color: #606266;
  font-weight: 500;
}

.chart-bar {
  flex: 1;
  height: 20px;
  background: #f5f7fa;
  border-radius: 10px;
  overflow: hidden;
  position: relative;
}

.chart-fill {
  height: 100%;
  border-radius: 10px;
  transition: width 0.6s ease;
}

.chart-fill.fast { background: linear-gradient(90deg, #ff6b6b, #ee5a52); }
.chart-fill.normal { background: linear-gradient(90deg, #51cf66, #40c057); }
.chart-fill.slow { background: linear-gradient(90deg, #ffd43b, #fab005); }
.chart-fill.hard { background: linear-gradient(90deg, #ff6b6b, #ee5a52); }
.chart-fill.easy { background: linear-gradient(90deg, #339af0, #228be6); }
.chart-fill.clear { background: linear-gradient(90deg, #51cf66, #40c057); }
.chart-fill.confused { background: linear-gradient(90deg, #ff6b6b, #ee5a52); }

.chart-value {
  min-width: 40px;
  font-size: 0.9rem;
  color: #303133;
  font-weight: 600;
  text-align: right;
}

.questions-section {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #ebeef5;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.questions-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 12px;
}

.questions-title {
  font-size: 1rem;
  font-weight: 600;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 8px;
}

.question-badge {
  margin-left: 8px;
}

.filter-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.questions-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-height: 300px;
  overflow-y: auto;
}

.question-item {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 12px;
  border-left: 4px solid #409eff;
  transition: all 0.3s;
}

.question-item:hover {
  background: #f1f3f4;
}

.question-item.answered {
  border-left-color: #67c23a;
  background: #f0f9ff;
}

.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.question-time {
  font-size: 0.8rem;
  color: #909399;
  font-weight: 500;
}

.question-tags {
  display: flex;
  gap: 6px;
}

.question-content {
  font-size: 0.9rem;
  color: #303133;
  line-height: 1.5;
  margin-bottom: 8px;
  word-break: break-word;
}

.question-actions {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  justify-content: flex-start; /* 左对齐，适应单个按钮 */
}

.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: #909399;
}

.empty-state .el-icon {
  margin-bottom: 12px;
  color: #c0c4cc;
}

.empty-state p {
  font-size: 0.9rem;
  margin: 0;
}



/* 评论区弹窗样式 */
.comment-dialog :deep(.el-dialog) {
  border-radius: 16px;
  max-width: 90vw;
  margin: 5vh auto;
}

.comment-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 16px 20px;
}

.comment-dialog :deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
}

.comment-dialog :deep(.el-dialog__body) {
  padding: 0;
}

.comment-content {
  padding: 20px;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.comment-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
}

.comment-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .feedback-content {
    padding: 16px;
  }

  .feedback-stats {
    grid-template-columns: 1fr;
  }

  .comment-content {
    padding: 16px;
  }

  .comment-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .filter-buttons {
    width: 100%;
    justify-content: flex-start;
  }

  .question-actions {
    justify-content: flex-start;
  }
}
.small-invite {
  font-size: 0.85rem;
  color: #888;
  margin-bottom: 8px;
  text-align: right;
}
.center-invite {
  text-align: center;
  display: block;
  margin-bottom: 10px;
  font-size: 1.08rem;
  color: #409eff;
  font-weight: bold;
}
.multi-info-row {
  flex-wrap: wrap;
  gap: 0 4px;
}
.multi-info-row .item-label,
.multi-info-row .item-value {
  white-space: nowrap;
}
.popquiz-input {
  width: 90%;
  margin: 20px auto 0 auto;
  display: block;
}
.popquiz-btn-row {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 12px 0 24px 0;
}

/* 测试列表弹窗样式 */
.test-list-dialog :deep(.el-dialog) {
  border-radius: 16px;
  max-width: 90vw;
  margin: 5vh auto;
}

.test-list-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 16px 20px;
}

.test-list-dialog :deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
}

.test-list-dialog :deep(.el-dialog__body) {
  padding: 0;
}

.test-list-content {
  padding: 20px;
}

.test-list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.test-list-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
}

.test-list-body {
  min-height: 200px;
}

.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: #999;
}

.empty-state p {
  margin-top: 12px;
  font-size: 0.95rem;
}

.test-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.test-item {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #e9ecef;
  transition: all 0.3s ease;
}

.test-item:hover {
  border-color: #667eea;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
}

.test-item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.test-title {
  font-size: 1rem;
  font-weight: 600;
  color: #333;
}

.test-status {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 500;
}

.status-pending {
  background: #fff3cd;
  color: #856404;
}

.status-active {
  background: #d1ecf1;
  color: #0c5460;
}

.status-completed {
  background: #d4edda;
  color: #155724;
}

.status-unknown {
  background: #f8d7da;
  color: #721c24;
}

.test-item-content {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.test-info {
  display: flex;
  align-items: center;
  font-size: 0.9rem;
}

.info-label {
  color: #666;
  min-width: 80px;
  font-weight: 500;
}

.info-value {
  color: #333;
  flex: 1;
}

/* 样式 */
.stat-questions-list {
  display: flex;
  flex-direction: column;
  gap: 18px;
  margin-bottom: 24px;
}
.stat-question-card {
  background: #f8f9fa;
  border-radius: 10px;
  padding: 16px 18px;
  border: 1px solid #e9ecef;
}
.stat-q-content {
  font-weight: 600;
  font-size: 1rem;
  margin-bottom: 10px;
}
.stat-q-options {
  margin: 0 0 10px 0;
  padding: 0 0 0 18px;
  list-style: none;
}
.stat-q-options li {
  font-size: 0.96rem;
  margin-bottom: 2px;
}
.stat-q-info {
  font-size: 0.92rem;
  color: #666;
}
.stat-q-info b {
  color: #409eff;
}
</style>

