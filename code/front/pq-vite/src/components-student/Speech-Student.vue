<template>
  <div class="speech-page">
    <!-- 顶部导航栏 -->
    <div class="top-nav">
      <el-button class="back-btn" @click="$router.back()" link>
        <el-icon size="20"><ArrowLeft /></el-icon>
      </el-button>
      <div class="nav-title">
        <span>{{ activity.title }}({{ activity.createName }})</span>
        <el-tag :type="getStatusType(activity.status)" size="small" class="status-tag">{{ getStatusText(activity.status) }}</el-tag>
      </div>
    </div>
    
    <!-- 内容区 -->
    <el-scrollbar max-height="560px">
      <div class="main-content" style="margin-top: 20px;">
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
    </el-scrollbar>
    
    
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

    <!-- WebSocket 连接状态指示器 -->
    <div class="ws-status" :class="wsStatus">
      <el-icon v-if="wsStatus === 'connected'"><CircleCheck /></el-icon>
      <el-icon v-else-if="wsStatus === 'connecting'"><Loading /></el-icon>
      <el-icon v-else><CircleClose /></el-icon>
      <span>{{ wsStatusText }}</span>
    </div>

    <!-- 答题弹窗 -->
    <el-dialog
      v-model="quizDialogVisible"
      title="🎯 Pop Quiz 测试"
      width="90%"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      :show-close="false"
      class="quiz-dialog"
    >
      <div class="quiz-content">
        
        <div class="quiz-header">
          <div class="quiz-info">
            <span class="quiz-title">实时测试</span>
            <span class="quiz-count">题目 {{ currentQuestionIndex + 1 }}/{{ quizData.length }}</span>
          </div>
          <div class="timer" :class="{ 'warning': timeLeft <= 10 }">
            <el-icon><Timer /></el-icon>
            <span>{{ timeLeft }}s</span>
          </div>
        </div>

        <div class="question-container" v-if="currentQuestion">
          <div class="question-text">{{ currentQuestion.content }}</div>
          <div class="options-list">
            <div
              v-for="(option, index) in currentQuestion.options"
              :key="index"
              class="option-item"
              :class="{ selected: selectedAnswers[currentQuestionIndex] === index }"
              @click="selectOption(index)"
            >
              <span class="option-label">{{ String.fromCharCode(65 + index) }}</span>
              <span class="option-text">{{ option }}</span>
            </div>
          </div>
        </div>
        
        <div class="quiz-actions">
          <el-button
            v-if="currentQuestionIndex > 0"
            @click="previousQuestion"
            :disabled="timeLeft <= 0"
          >
            上一题
          </el-button>
          <el-button
            v-if="currentQuestionIndex < quizData.length - 1"
            type="primary"
            @click="nextQuestion"
            :disabled="selectedAnswers[currentQuestionIndex] === undefined && timeLeft > 0"
          >
            下一题
          </el-button>
          <el-button
            v-if="currentQuestionIndex === quizData.length - 1"
            type="success"
            @click.stop="submitQuiz"
            :disabled="!isAllAnswered || isSubmitting"
          >
            提交答案
          </el-button>
        </div>
      </div>
    </el-dialog>

    <!-- 测试完成弹窗 -->
    <el-dialog
      v-model="resultDialogVisible"
      title="📊 测试结果"
      width="80%"
      :close-on-click-modal="false"
      class="result-dialog"
    >
      <div class="result-content">
        <div class="result-icon">
          <el-icon size="48" color="#67C23A"><CircleCheck /></el-icon>
        </div>
        <div class="result-text">
          <h3>测试完成！</h3>
          <p>您的答案已成功提交，请等待老师查看结果。</p>
        </div>
        <div class="result-actions">
          <el-button type="primary" @click="closeResult">确定</el-button>
        </div>
      </div>
    </el-dialog>

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
              @click="showTestResult(test.id)"
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

    <!-- 测试结果详情弹窗 -->
    <el-dialog
      v-model="testResultDialogVisible"
      title="📊 测试结果详情"
      width="95%"
      :close-on-click-modal="false"
      class="test-result-dialog"
    >
      <div class="test-result-content" v-if="testResultData">
        <!-- 统计信息 -->
        <div class="result-summary">
          <div class="summary-item">
            <div class="summary-value">{{ testResultData.totalQuestions }}</div>
            <div class="summary-label">总题数</div>
          </div>
          <div class="summary-item">
            <div class="summary-value correct">{{ testResultData.correctCount }}</div>
            <div class="summary-label">正确题数</div>
          </div>
          <div class="summary-item">
            <div class="summary-value accuracy">{{ testResultData.accuracy }}%</div>
            <div class="summary-label">正确率</div>
          </div>
        </div>

        <!-- 题目详情列表 -->
        <div class="questions-list">
          <div 
            v-for="(question, index) in testResultData.questions" 
            :key="question.questionId"
            class="question-result-item"
            :class="{ correct: question.isCorrect, incorrect: !question.isCorrect }"
          >
            <div class="question-header">
              <span class="question-number">第{{ index + 1 }}题</span>
              <span class="question-status" :class="question.isCorrect ? 'correct' : 'incorrect'">
                {{ question.isCorrect ? '✓ 正确' : '✗ 错误' }}
              </span>
            </div>
            
            <div class="question-content">
              <div class="question-text">{{ question.content }}</div>
              
              <div class="options-list">
                <div 
                  v-for="(option, optionIndex) in question.options" 
                  :key="optionIndex"
                  class="option-result-item"
                  :class="{
                    'student-selected': getOptionLetter(optionIndex) === question.studentAnswer,
                    'correct-answer': getOptionLetter(optionIndex) === question.correctAnswer
                  }"
                >
                  <span class="option-label">{{ getOptionLetter(optionIndex) }}</span>
                  <span class="option-text">{{ option }}</span>
                  <span class="option-indicator">
                    <!-- 只在正确答案上显示✓ -->
                    <span
                      v-if="getOptionLetter(optionIndex) === question.correctAnswer"
                      class="correct-icon"
                    >✓</span>
                    <!-- 只在学生选错时显示✗ -->
                    <span
                      v-if="getOptionLetter(optionIndex) === question.studentAnswer && question.studentAnswer !== question.correctAnswer"
                      class="incorrect-icon"
                    >✗</span>
                  </span>
                </div>
              </div>
              
              <div class="answer-info">
                <span class="answer-label">你的答案：</span>
                <span class="student-answer" :class="question.isCorrect ? 'correct' : 'incorrect'">
                  {{ question.studentAnswer || '未作答' }}
                </span>
                <span class="answer-label">正确答案：</span>
                <span class="correct-answer">{{ question.correctAnswer }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div v-else class="loading-result">
        <el-icon class="is-loading"><Loading /></el-icon>
        <span>加载中...</span>
      </div>
    </el-dialog>

    <!-- 反馈弹窗 -->
    <el-dialog
      v-model="feedbackDialogVisible"
      title="💬 课堂反馈"
      width="90%"
      :close-on-click-modal="false"
      class="feedback-dialog"
    >
      <div class="feedback-content">
        <div class="feedback-header">
          <span class="feedback-title">课堂反馈</span>
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
          <div class="feedback-stats">
            <!-- 节奏反馈 -->
            <div class="feedback-card">
              <h4 class="card-title">课堂节奏</h4>
              <div class="feedback-chart">
                <div
                  v-for="type in ['fast', 'normal', 'slow']"
                  :key="type"
                  class="chart-item"
                  :class="{
                    'my-selected': hasSubmittedFeedback && myFeedback.pace === type,
                    'clickable': !hasSubmittedFeedback,
                    'selected': !hasSubmittedFeedback && myFeedback.pace === type
                  }"
                  @click="!hasSubmittedFeedback && (myFeedback.pace = type)"
                  style="cursor: pointer;"
                >
                  <span class="chart-label">{{ type === 'fast' ? '太快' : type === 'normal' ? '正好' : '太慢' }}</span>
                  <div class="chart-bar">
                    <div
                      class="chart-fill"
                      :class="hasSubmittedFeedback ? type : 'unsubmitted'"
                      :style="hasSubmittedFeedback ? { width: getFeedbackPercentage('pace', type) + '%' } : { width: myFeedback.pace === type ? '100%' : '0%' }"
                    ></div>
                  </div>
                  <span class="chart-value">
                    <template v-if="hasSubmittedFeedback">
                      {{ (feedbackData.pace[type] || 0) + '人' }}
                      <el-icon v-if="myFeedback.pace === type" class="selected-icon"><Check /></el-icon>
                    </template>
                  </span>
                </div>
              </div>
            </div>
            <!-- 难度反馈 -->
            <div class="feedback-card">
              <h4 class="card-title">内容难度</h4>
              <div class="feedback-chart">
                <div
                  v-for="type in ['hard', 'normal', 'easy']"
                  :key="type"
                  class="chart-item"
                  :class="{
                    'my-selected': hasSubmittedFeedback && myFeedback.difficulty === type,
                    'clickable': !hasSubmittedFeedback,
                    'selected': !hasSubmittedFeedback && myFeedback.difficulty === type
                  }"
                  @click="!hasSubmittedFeedback && (myFeedback.difficulty = type)"
                  style="cursor: pointer;"
                >
                  <span class="chart-label">{{ type === 'hard' ? '太难' : type === 'normal' ? '适中' : '太易' }}</span>
                  <div class="chart-bar">
                    <div
                      class="chart-fill"
                      :class="hasSubmittedFeedback ? type : 'unsubmitted'"
                      :style="hasSubmittedFeedback ? { width: getFeedbackPercentage('difficulty', type) + '%' } : { width: myFeedback.difficulty === type ? '100%' : '0%' }"
                    ></div>
                  </div>
                  <span class="chart-value">
                    <template v-if="hasSubmittedFeedback">
                      {{ (feedbackData.difficulty[type] || 0) + '人' }}
                      <el-icon v-if="myFeedback.difficulty === type" class="selected-icon"><Check /></el-icon>
                    </template>
                  </span>
                </div>
              </div>
            </div>
            <!-- 理解程度 -->
            <div class="feedback-card">
              <h4 class="card-title">理解程度</h4>
              <div class="feedback-chart">
                <div
                  v-for="type in ['clear', 'confused']"
                  :key="type"
                  class="chart-item"
                  :class="{
                    'my-selected': hasSubmittedFeedback && myFeedback.understanding === type,
                    'clickable': !hasSubmittedFeedback,
                    'selected': !hasSubmittedFeedback && myFeedback.understanding === type
                  }"
                  @click="!hasSubmittedFeedback && (myFeedback.understanding = type)"
                  style="cursor: pointer;"
                >
                  <span class="chart-label">{{ type === 'clear' ? '清楚' : '困惑' }}</span>
                  <div class="chart-bar">
                    <div
                      class="chart-fill"
                      :class="hasSubmittedFeedback ? type : 'unsubmitted'"
                      :style="hasSubmittedFeedback ? { width: getFeedbackPercentage('understanding', type) + '%' } : { width: myFeedback.understanding === type ? '100%' : '0%' }"
                    ></div>
                  </div>
                  <span class="chart-value">
                    <template v-if="hasSubmittedFeedback">
                      {{ (feedbackData.understanding[type] || 0) + '人' }}
                      <el-icon v-if="myFeedback.understanding === type" class="selected-icon"><Check /></el-icon>
                    </template>
                  </span>
                </div>
              </div>
            </div>
          </div>
          <!-- 提交按钮 -->
          <div style="text-align:center;margin-top:24px;">
            <el-button type="primary" size="large" :loading="submittingFeedback" :disabled="hasSubmittedFeedback" @click="submitFeedbackClick">提交反馈</el-button>
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
      :my-role="'student'"
      title="💬 讨论区"
    />
  </div>
</template>

<script setup>
import './Speech-Student.css'
import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { ArrowLeft, Document, ChatDotRound, Comment, CircleCheck, CircleClose, Loading, Timer, Check, QuestionFilled, User, Refresh, ChatDotSquare, UserFilled } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useUserInfoStore } from '../stores/userInfo.js'
import { useActivityStore } from '../stores/activity.js'
import { useQuizWsStore } from '../stores/quizWs.js'
import { useRoute } from 'vue-router'
import { submit, ExamList, ShowTestService, getActiveQuiz, saveQuizDraft } from '../api/activity.js'
import { submitFeedback, getFeedbackStats, getMyFeedbackHistory } from '../api/feedback.js'
import DiscussionArea from '../components/DiscussionArea.vue'

const userInfoStore = useUserInfoStore()
const activityStore = useActivityStore()
const quizWsStore = useQuizWsStore()
const route = useRoute()

const userId = userInfoStore.id  // 当前学生id
//const userId = computed(() => userInfoStore.id)
console.log(userInfoStore.nickname)
const activity = computed(() => activityStore.getActivityById(route.params.id) || {})

const activeTab = ref('test')
const isSubmit = ref(false)
const wsStatus = computed(() => quizWsStore.status)
const wsStatusText = computed(() => quizWsStore.statusText)

// 答题相关状态
const quizDialogVisible = ref(false)
const resultDialogVisible = ref(false)
const testListDialogVisible = ref(false) // 测试列表弹窗
const quizData = ref([])
const currentQuestionIndex = ref(0)
const selectedAnswers = ref({})
const timeLeft = ref(30)
const totalTime = ref(30) // 当前测验总时长（秒）
const currentQuizEndTime = ref(null) // 当前测验截止时间（毫秒时间戳）
const currentPopQuizId = ref(null) // 当前PopQuiz ID
const currentActivityId = ref(null) // 当前活动ID
const testListData = ref([]) // 测试列表数据
const loadingTestList = ref(false) // 加载状态
const testResultDialogVisible = ref(false) // 测试结果详情弹窗
const testResultData = ref(null) // 测试结果数据
let timer = null
const isSubmitting = ref(false);
let quizSessionId = null;
let draftSaveTimer = null;
const draftQueueKey = 'pq_quiz_draft_queue'
const isFlushingDraft = ref(false)

// 反馈相关状态
const feedbackDialogVisible = ref(false)
const feedbackData = ref({
  pace: { fast: 0, normal: 0, slow: 0 },
  difficulty: { hard: 0, normal: 0, easy: 0 },
  understanding: { clear: 0, confused: 0 }
})
const myFeedback = ref({
  pace: 'normal',
  difficulty: 'normal',
  understanding: 'clear'
})
const loadingFeedback = ref(false)
const submittingFeedback = ref(false)
const hasSubmittedFeedback = ref(false)

// 评论区相关状态
const commentDialogVisible = ref(false)

// 计算属性
const currentQuestion = computed(() => {
  const question = quizData.value[currentQuestionIndex.value] || null
  return question
})

const isAllAnswered = computed(() => {
  return quizData.value.length > 0 &&
    quizData.value.every((q, idx) => selectedAnswers.value[idx] !== undefined && selectedAnswers.value[idx] !== null)
})

// 评论区计算属性
const filteredQuestions = computed(() => {
  // 与旧评论区无关，这里返回空数组或原始数据
  return [];
})

const unansweredCount = computed(() =>
  // 与旧评论区无关，这里返回0
  0
)

const answeredCount = computed(() =>
  // 与旧评论区无关，这里返回0
  0
)

// 状态文本和类型
const getStatusText = (status) => {
  switch (status) {
    case 0: return '未开始'
    case 1: return '进行中'
    case 2: return '已结束'
    default: return '未知'
  }
}

const getStatusType = (status) => {
  switch (status) {
    case 0: return 'primary'
    case 1: return 'success'
    case 2: return 'info'
    default: return 'warning'
  }
}


// 处理接收到的题目数据
const handleQuizData = (data) => {
  if (quizDialogVisible.value || isSubmitting.value || quizSessionId) {
    // 已经有弹窗或正在提交或本次会话已处理，忽略重复推送
    return;
  }
  try {
    // 检查数据格式，支持新的包含时间限制的格式和旧的直接题目数组格式
    if (data && typeof data === 'object' && data.questions) {
      // 新格式：包含题目与时间窗口（优先使用 endTime 计算剩余时间）
      quizData.value = Array.isArray(data.questions) ? data.questions : [data.questions]
      currentPopQuizId.value = data.popQuizId // 保存PopQuiz ID
      currentActivityId.value = data.activityId // 保存活动ID

      const endTimeMs = data.endTime ? new Date(data.endTime).getTime() : null
      const startTimeMs = data.startTime ? new Date(data.startTime).getTime() : null
      if (endTimeMs && !Number.isNaN(endTimeMs)) {
        currentQuizEndTime.value = endTimeMs
        const remain = Math.max(0, Math.floor((endTimeMs - Date.now()) / 1000))
        timeLeft.value = remain

        if (startTimeMs && !Number.isNaN(startTimeMs)) {
          totalTime.value = Math.max(0, Math.floor((endTimeMs - startTimeMs) / 1000))
        } else if (data.lastTime) {
          totalTime.value = Number(data.lastTime)
        } else {
          totalTime.value = remain
        }
      } else {
        // 兼容旧字段 lastTime（秒）
        currentQuizEndTime.value = null
        timeLeft.value = Number(data.lastTime) || 30
        totalTime.value = Number(data.lastTime) || 30
      }
      if (timeLeft.value <= 0) {
        ElMessage.warning('本次测试已截止')
        return
      }
    } else if (Array.isArray(data)) {
      // 旧格式：直接是题目数组
      quizData.value = data
      currentQuizEndTime.value = null
      timeLeft.value = 30 // 默认30秒
      totalTime.value = 30
      currentPopQuizId.value = null // 旧格式没有PopQuiz ID
      currentActivityId.value = null // 旧格式没有活动ID
    } else if (data && typeof data === 'object') {
      // 可能是单个题目对象
      quizData.value = [data]
      currentQuizEndTime.value = null
      timeLeft.value = 30 // 默认30秒
      totalTime.value = 30
      currentPopQuizId.value = null // 单个题目没有PopQuiz ID
      currentActivityId.value = null // 单个题目没有活动ID
    } else {
      ElMessage.error('收到未知格式的题目数据')
      return
    }
    
    // 验证题目数据
    if (quizData.value.length === 0) {
      ElMessage.error('题目数据为空')
      return
    }
    
    // 验证第一个题目的结构
    const firstQuestion = quizData.value[0]
    if (!firstQuestion.content) {
      ElMessage.error('题目数据格式错误：缺少content字段')
      return
    }
    
    if (!firstQuestion.options || !Array.isArray(firstQuestion.options)) {
      ElMessage.error('题目数据格式错误：缺少options字段')
      return
    }
    
    currentQuestionIndex.value = 0
    selectedAnswers.value = {}
    
    // 显示答题弹窗
    quizDialogVisible.value = true
    
    // 开始计时
    startTimer()
    
    console.log('收到题目数据:', {
      popQuizId: currentPopQuizId.value,
      activityId: currentActivityId.value,
      questionCount: quizData.value.length,
      timeLimit: timeLeft.value
    })
    
    ElMessage.closeAll();
    ElMessage.success(`收到 ${quizData.value.length} 道题目，总时长 ${totalTime.value} 秒`)
    
  } catch (error) {
    console.error('处理题目数据失败:', error)
    ElMessage.error('处理题目数据失败: ' + error.message)
  }
}

// 开始计时器
const startTimer = () => {
  if (timer) {
    clearInterval(timer)
  }

  timer = setInterval(() => {
    // 优先使用绝对截止时间计算剩余秒数，避免晚进入页面时倒计时重置
    if (currentQuizEndTime.value) {
      timeLeft.value = Math.max(0, Math.floor((currentQuizEndTime.value - Date.now()) / 1000))
    } else if (timeLeft.value > 0) {
      // 兼容旧逻辑
      timeLeft.value--
    }

    if (timeLeft.value <= 0) {
      // 时间到，自动提交
      clearInterval(timer)
      timer = null
      if (quizDialogVisible.value && isSubmit.value === false) {
        submitQuiz()
      }
    }
  }, 1000)
}

// 选择选项
const selectOption = (optionIndex) => {
  if (timeLeft.value <= 0) return
  
  // 确保选项索引是有效的
  if (optionIndex < 0 || optionIndex >= (currentQuestion.value?.options?.length || 0)) {
    console.error('无效的选项索引:', optionIndex)
    return
  }
  
  // 设置选中的答案
  selectedAnswers.value[currentQuestionIndex.value] = optionIndex
  
  console.log(`选择了第${currentQuestionIndex.value + 1}题的第${optionIndex + 1}个选项`)
  console.log('当前答案状态:', selectedAnswers.value)
}

// 下一题
const nextQuestion = () => {
  if (currentQuestionIndex.value < quizData.value.length - 1) {
    currentQuestionIndex.value++
  }
}

// 上一题
const previousQuestion = () => {
  if (currentQuestionIndex.value > 0) {
    currentQuestionIndex.value--
  }
}

// 提交答案
const submitQuiz = async () => {
  console.log('点击提交，isAllAnswered:', isAllAnswered.value, 'quizDialogVisible:', quizDialogVisible.value, 'isSubmitting:', isSubmitting.value, 'quizSessionId:', quizSessionId);
  if (isSubmitting.value) return;
  isSubmitting.value = true;
  clearInterval(timer);
  timer = null;
  quizDialogVisible.value = false;
  if (!isAllAnswered.value && timeLeft.value > 0) {
    ElMessage.warning('请完成所有题目后再提交')
    isSubmitting.value = false;
    return
  }
  try {
    const submitData = {
      popQuizId: currentPopQuizId.value,
      userId: userId,
      answers: selectedAnswers.value
    }
    console.log('准备提交答案:', submitData)
    console.log('当前状态:', {
      popQuizId: currentPopQuizId.value,
      userId: userId,
      answerCount: Object.keys(selectedAnswers.value).length,
      totalQuestions: quizData.value.length
    })
    if (!submitData.popQuizId) {
      ElMessage.error('缺少PopQuiz ID，无法提交答案')
      console.error('PopQuiz ID为空，当前状态:', {
        currentPopQuizId: currentPopQuizId.value,
        receivedData: quizData.value
      })
      isSubmitting.value = false;
      return
    }
    const result = await submit(submitData)
    if (result.data.success) {
      ElMessage.success('答案提交成功！')
      isSubmit.value = true
      console.log('答案提交成功:', result.data)
    } else {
      ElMessage.error('答案提交失败: ' + (result.errorMsg || '未知错误'))
      console.error('答案提交失败:', result.errorMsg)
    }
  } catch (error) {
    console.error('提交答案时发生错误:', error)
    ElMessage.error('提交答案失败: ' + error.message)
  } finally {
    isSubmitting.value = false;
    resultDialogVisible.value = true;
  }
};

// 关闭结果弹窗
const closeResult = () => {
  resultDialogVisible.value = false
  // 重置状态
  quizData.value = []
  currentQuestionIndex.value = 0
  selectedAnswers.value = {}
  timeLeft.value = 30
  totalTime.value = 30
  currentQuizEndTime.value = null
  currentPopQuizId.value = null
  currentActivityId.value = null
  quizSessionId = null;
}

// 显示测试列表
const showTestList = async () => {
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
    const result = await ExamList(route.params.id)
    
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

// 显示测试结果详情
const showTestResult = async (popQuizId) => {
  testResultDialogVisible.value = true
  testResultData.value = null // 清空之前的数据
  
  try {
    const result = await ShowTestService(popQuizId,userId)
    
    
    if (result.data.success) {
      testResultData.value = result.data.data
      console.log('测试结果数据:', testResultData.value)
    } else {
      ElMessage.error('获取测试结果失败: ' + (result.errorMsg || '未知错误'))
      testResultDialogVisible.value = false
    }
  } catch (error) {
    console.error('获取测试结果失败:', error)
    ElMessage.error('获取测试结果失败: ' + error.message)
    testResultDialogVisible.value = false
  }
}

// 获取选项字母 (0->A, 1->B, 2->C, 3->D)
const getOptionLetter = (index) => {
  return String.fromCharCode(65 + index)
}

const loadDraftQueue = () => {
  try {
    const raw = localStorage.getItem(draftQueueKey)
    if (!raw) return []
    const parsed = JSON.parse(raw)
    return Array.isArray(parsed) ? parsed : []
  } catch {
    return []
  }
}

const saveDraftQueue = (queue) => {
  localStorage.setItem(draftQueueKey, JSON.stringify(queue))
}

const enqueueDraft = () => {
  if (!currentPopQuizId.value || !userId) return
  const payload = {
    popQuizId: Number(currentPopQuizId.value),
    userId: Number(userId),
    activityId: Number(route.params.id),
    answers: { ...selectedAnswers.value },
    updatedAt: Date.now()
  }

  const queue = loadDraftQueue()
  const idx = queue.findIndex(
    item => Number(item.popQuizId) === Number(payload.popQuizId) && Number(item.userId) === Number(payload.userId)
  )
  if (idx >= 0) {
    queue[idx] = payload
  } else {
    queue.push(payload)
  }
  saveDraftQueue(queue)
}

const removeDraftFromQueue = (popQuizId, targetUserId) => {
  const queue = loadDraftQueue()
  const next = queue.filter(
    item => !(Number(item.popQuizId) === Number(popQuizId) && Number(item.userId) === Number(targetUserId))
  )
  saveDraftQueue(next)
}

const flushDraftQueue = async () => {
  if (isFlushingDraft.value || !navigator.onLine) return
  isFlushingDraft.value = true
  try {
    const queue = loadDraftQueue()
    if (!queue.length) return

    const remain = []
    for (const item of queue) {
      try {
        await saveQuizDraft(item.popQuizId, item.userId, item.answers || {})
      } catch (e) {
        remain.push(item)
      }
    }
    saveDraftQueue(remain)
  } finally {
    isFlushingDraft.value = false
  }
}

// 恢复当前活动中的进行中测验（刷新/重连可恢复）
const restoreActiveQuiz = async () => {
  if (!route.params.id || !userId) return
  try {
    const res = await getActiveQuiz(route.params.id, userId)
    const data = res?.data?.data
    if (!res?.data?.success || !data?.active) return

    handleQuizData(data)

    // 回填草稿答案（后端返回 key 为题目索引）
    if (data.answers && typeof data.answers === 'object') {
      const restored = {}
      Object.keys(data.answers).forEach((key) => {
        const idx = Number(key)
        const val = Number(data.answers[key])
        if (!Number.isNaN(idx) && !Number.isNaN(val)) {
          restored[idx] = val
        }
      })
      selectedAnswers.value = restored
    }

    // 优先补发本地离线队列里同一场测验的草稿
    await flushDraftQueue()
  } catch (error) {
    console.error('恢复进行中测验失败:', error)
  }
}

// 节流保存草稿
const scheduleDraftSave = () => {
  if (!currentPopQuizId.value || !userId || !quizDialogVisible.value) return
  if (draftSaveTimer) {
    clearTimeout(draftSaveTimer)
  }
  draftSaveTimer = setTimeout(async () => {
    try {
      await saveQuizDraft(currentPopQuizId.value, userId, selectedAnswers.value)
      removeDraftFromQueue(currentPopQuizId.value, userId)
    } catch (error) {
      // 网络抖动/断网时进入本地队列，联网后自动补发
      enqueueDraft()
      console.error('保存草稿失败，已加入本地补发队列:', error)
    }
  }, 800)
}

// 监听答案变化，自动保存草稿
watch(
  () => selectedAnswers.value,
  () => {
    scheduleDraftSave()
  },
  { deep: true }
)

// 组件挂载时：先恢复进行中测验，再确保全局 WS 已连接并监听全局消息
onMounted(async () => {
  await restoreActiveQuiz()

  // 监听网络恢复，自动补发离线期间积压的草稿
  window.addEventListener('online', flushDraftQueue)
  await flushDraftQueue()

  if (userId) {
    quizWsStore.ensureConnected(userId)
  }

  watch(
    () => quizWsStore.lastMessageSeq,
    () => {
      const data = quizWsStore.lastMessage
      if (!data) return

      // 只处理当前活动的题目，避免串活动弹题
      if (String(data.activityId) !== String(route.params.id)) return

      handleQuizData(data)
    },
    { immediate: true } // 页面打开时立即检查一次，接住“先收到题再进入活动页”的场景
  )
})

// 组件卸载时仅清理页面级计时器，不断开全局 WS
onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
    timer = null
  }
  if (draftSaveTimer) {
    clearTimeout(draftSaveTimer)
    draftSaveTimer = null
  }
  window.removeEventListener('online', flushDraftQueue)
})

// 格式化时间(活动内容时间)
function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleString('zh-CN', { hour12: false });
}

// 获取反馈百分比
const getFeedbackPercentage = (category, option) => {
  let total = 0;
  let count = 0;
  
  if (category === 'pace') {
    total = feedbackData.value.pace.fast + feedbackData.value.pace.normal + feedbackData.value.pace.slow;
    count = feedbackData.value.pace[option] || 0;
  } else if (category === 'difficulty') {
    total = feedbackData.value.difficulty.hard + feedbackData.value.difficulty.normal + feedbackData.value.difficulty.easy;
    count = feedbackData.value.difficulty[option] || 0;
  } else if (category === 'understanding') {
    total = feedbackData.value.understanding.clear + feedbackData.value.understanding.confused;
    count = feedbackData.value.understanding[option] || 0;
  }
  
  if (total === 0) return 0;
  return Math.round((count / total) * 100);
}

// 刷新反馈数据
const refreshFeedback = async () => {
  loadingFeedback.value = true;
  try {
    // 获取反馈统计数据
    const statsResult = await getFeedbackStats(route.params.id);
    if (statsResult.data && statsResult.data.success) {
      const stats = statsResult.data.data;
      feedbackData.value.pace = stats.pace || { fast: 0, normal: 0, slow: 0 };
      feedbackData.value.difficulty = stats.difficulty || { hard: 0, normal: 0, easy: 0 };
      feedbackData.value.understanding = stats.understanding || { clear: 0, confused: 0 };
    }

    ElMessage.success('反馈数据已刷新');
  } catch (error) {
    console.error('获取反馈数据失败:', error);
    ElMessage.error('获取反馈数据失败: ' + error.message);
  } finally {
    loadingFeedback.value = false;
  }
}





// 获取空状态文本
const getEmptyStateText = () => {
  // 与旧评论区无关，这里返回空字符串
  return '';
};

// 提交新问题
const submitNewQuestion = async () => {
  // 与旧评论区无关，这里不执行任何操作
};

const goToFeedback = () => {
  feedbackDialogVisible.value = true;
  checkMyFeedback(); // 点击反馈按钮时才判断
};

// 格式化时间显示
const formatTimeForDisplay = (timeString) => {
  if (!timeString) return '';
  try {
    const date = new Date(timeString);
    return date.toLocaleTimeString('zh-CN', {
      hour: '2-digit',
      minute: '2-digit'
    });
  } catch (error) {
    console.error('时间格式化失败:', error);
    return timeString;
  }
};

const submitFeedbackClick = async () => {
  submittingFeedback.value = true;
  try {
    const feedbackData = {
      pace: myFeedback.value.pace,
      difficulty: myFeedback.value.difficulty,
      understanding: myFeedback.value.understanding,
      userId // 新增，传当前用户id
    };
    const result = await submitFeedback(route.params.id, feedbackData);
    if (result.data && result.data.success) {
      ElMessage.success('反馈提交成功！');
      hasSubmittedFeedback.value = true;
      // 刷新反馈数据以显示最新统计
     await checkMyFeedback();
     // await refreshFeedback();
    } else {
      ElMessage.error('反馈提交失败: ' + (result.data?.message || '未知错误'));
    }
  } catch (error) {
    console.error('提交反馈时发生错误:', error);
    ElMessage.error('提交反馈失败: ' + error.message);
  } finally {
    submittingFeedback.value = false;
  }
};



const refreshComments = async () => {
  // 与旧评论区无关，这里不执行任何操作
};

function showComment() {
  activeTab.value = 'comment'
  commentDialogVisible.value = true
}

// 监听评论区弹窗关闭，重置按钮状态
watch(commentDialogVisible, (newVal) => {
  if (!newVal && activeTab.value === 'comment') {
    // 弹窗关闭时，如果当前是评论区状态，则重置为默认状态
    activeTab.value = ''
  }
});

// 页面加载时判断是否已提交反馈
const checkMyFeedback = async () => {
  const paceMap = ['fast', 'normal', 'slow']
  const difficultyMap = ['hard', 'normal', 'easy']
  const understandingMap = ['clear', 'confused']
  console.log(userId,'hhhh')
  try {
    const res = await getMyFeedbackHistory(route.params.id, userId)
    if (res.data && res.data.success && res.data.data) {
      hasSubmittedFeedback.value = true
      myFeedback.value = {
        pace: paceMap[res.data.data.pace],
        difficulty: difficultyMap[res.data.data.difficulty],
        understanding: understandingMap[res.data.data.understanding]
      }
      await refreshFeedback()
    } else {
      hasSubmittedFeedback.value = false
      myFeedback.value = { pace: '', difficulty: '', understanding: '' }
      await refreshFeedback() // 修复：未提交时也要刷新统计条
    }
  } catch {
    hasSubmittedFeedback.value = false
    myFeedback.value = { pace: '', difficulty: '', understanding: '' }
    await refreshFeedback()
  }
}
</script>
