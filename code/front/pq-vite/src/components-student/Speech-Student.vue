<template>
  <div class="speech-page">
    <!-- 顶部导航栏 -->
    <div class="top-nav">
      <el-button class="back-btn" @click="$router.back()" link>
        <el-icon size="20"><ArrowLeft /></el-icon>
      </el-button>
      <div class="nav-title">
        <span>{{ activity.title }}</span>
        <el-tag :type="getStatusType(activity.status)" size="small" class="status-tag">{{ getStatusText(activity.status) }}</el-tag>
      </div>
    </div>
    
    <!-- 活动简介小字 -->
    <div class="activity-content-brief" :title="activity.content">{{ activity.content }}</div>
    
    <!-- 内容区 -->
    <el-scrollbar max-height="560px">
      <div class="main-content">
        <!-- 活动详情 -->
        <div class="detail-content">
          <ul class="activity-detail-list">
            <li><span class="item-label">标题：</span>{{ activity.title }}</li>
            <li><span class="item-label">地点：</span>{{ activity.location }}</li>
            <li><span class="item-label">时间：</span></li>
            <li>{{ activity.startTime }} ~ {{ activity.endTime }}</li>
            <li><span class="item-label">人数：</span>{{ activity.curNum }}</li>
          </ul>
        </div>
        
        <!-- PPT预览框 -->
        <div class="ppt-preview">
          <template v-if="activity.pptUrl">
            <iframe
              :src="`${activity.pptUrl}?x-oss-process=document/preview`"
              class="ppt-iframe"
              frameborder="0"
              allowfullscreen
            ></iframe>
          </template>
          <div v-else class="ppt-placeholder">暂无PPT课件</div>
        </div>
      </div>
    </el-scrollbar>
    
    <!-- 底部导航栏 -->
    <div class="bottom-nav-student">
      <div class="nav-item" :class="{ active: activeTab === 'test' }" @click="showTestList">
        <el-icon><Document /></el-icon>
        <span>测试列表</span>
      </div>
      <div class="nav-item" :class="{ active: activeTab === 'feedback' }" @click="activeTab = 'feedback'">
        <el-icon><ChatDotRound /></el-icon>
        <span>反馈</span>
      </div>
      <div class="nav-item" :class="{ active: activeTab === 'comment' }" @click="activeTab = 'comment'">
        <el-icon><Comment /></el-icon>
        <span>评论区</span>
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
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { ArrowLeft, Document, ChatDotRound, Comment, CircleCheck, CircleClose, Loading, Timer } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useUserInfoStore } from '../stores/userInfo.js'
import { useActivityStore } from '../stores/activity.js'
import { useRoute } from 'vue-router'
import { submit, ExamList,ShowTestService } from '../api/activity.js'
const userInfoStore = useUserInfoStore()
const activityStore = useActivityStore()
const route = useRoute()

const userId = userInfoStore.id  // 当前学生id
const activity = computed(() => activityStore.getActivityById(route.params.id) || {})

const activeTab = ref('test')
const isSubmit = ref(false)
// WebSocket 相关状态
const wsStatus = ref('disconnected') // disconnected, connecting, connected
const wsStatusText = ref('未连接')
let stompClient = null
let subscription = null // 添加订阅对象
let isConnecting = false // 添加连接状态标志

// 答题相关状态
const quizDialogVisible = ref(false)
const resultDialogVisible = ref(false)
const testListDialogVisible = ref(false) // 测试列表弹窗
const quizData = ref([])
const currentQuestionIndex = ref(0)
const selectedAnswers = ref({})
const timeLeft = ref(30)
const currentPopQuizId = ref(null) // 当前PopQuiz ID
const currentActivityId = ref(null) // 当前活动ID
const testListData = ref([]) // 测试列表数据
const loadingTestList = ref(false) // 加载状态
const testResultDialogVisible = ref(false) // 测试结果详情弹窗
const testResultData = ref(null) // 测试结果数据
let timer = null
const isSubmitting = ref(false);
let quizSessionId = null;

// 计算属性
const currentQuestion = computed(() => {
  const question = quizData.value[currentQuestionIndex.value] || null
  return question
})

const isAllAnswered = computed(() => {
  return quizData.value.length > 0 &&
    quizData.value.every((q, idx) => selectedAnswers.value[idx] !== undefined && selectedAnswers.value[idx] !== null)
})

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

// WebSocket 连接
const connectWebSocket = async () => {
  // 防止重复连接
  if (isConnecting || (stompClient && stompClient.connected)) {
    console.log('WebSocket 已连接或正在连接中，跳过重复连接')
    return
  }

  isConnecting = true
  wsStatus.value = 'connecting'
  wsStatusText.value = '连接中...'

  try {
    // 动态加载 SockJS 和 STOMP
    await loadWebSocketLibraries()
    
    // 创建 SockJS 连接
    const socket = new SockJS('http://localhost:8080/ws/quiz')
    stompClient = Stomp.over(socket)
    
    // 配置 STOMP 客户端
    stompClient.reconnect_delay = 5000
    stompClient.debug = null // 关闭调试日志
    
    // 连接 WebSocket
    await new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error('连接超时'))
      }, 10000) // 10秒超时
      
      stompClient.connect({}, 
        (frame) => {
          clearTimeout(timeout)
          wsStatus.value = 'connected'
          wsStatusText.value = '已连接'
          isConnecting = false
          // 去掉连接成功弹窗，避免多次弹出
          // ElMessage.success('WebSocket 连接成功')
          subscribeToPersonalChannel()
          resolve()
        }, 
        (error) => {
          clearTimeout(timeout)
          wsStatus.value = 'disconnected'
          wsStatusText.value = '连接失败'
          isConnecting = false
          ElMessage.error('WebSocket 连接失败: ' + error)
          reject(error)
        }
      )
    })
    
  } catch (error) {
    wsStatus.value = 'disconnected'
    wsStatusText.value = '连接失败'
    isConnecting = false
    console.error('WebSocket 连接错误:', error)
    ElMessage.error('WebSocket 初始化失败: ' + error.message)
    // 5秒后重试连接
    setTimeout(() => {
      if (wsStatus.value === 'disconnected') {
        connectWebSocket()
      }
    }, 5000)
  }
}

// 动态加载 WebSocket 库
const loadWebSocketLibraries = () => {
  return new Promise((resolve, reject) => {
    // 检查是否已加载
    if (window.SockJS && window.Stomp) {
      resolve()
      return
    }

    let loadedCount = 0
    const totalLibraries = 2

    const checkAllLoaded = () => {
      loadedCount++
      if (loadedCount === totalLibraries) {
        resolve()
      }
    }

    const handleError = (error) => {
      reject(new Error('加载 WebSocket 库失败: ' + error))
    }

    // 加载 SockJS
    const sockjsScript = document.createElement('script')
    sockjsScript.src = 'https://cdn.bootcdn.net/ajax/libs/sockjs-client/1.5.1/sockjs.min.js'
    sockjsScript.onload = checkAllLoaded
    sockjsScript.onerror = () => handleError('SockJS 加载失败')
    document.head.appendChild(sockjsScript)

    // 加载 STOMP
    const stompScript = document.createElement('script')
    stompScript.src = 'https://cdn.bootcdn.net/ajax/libs/stomp.js/2.3.3/stomp.min.js'
    stompScript.onload = checkAllLoaded
    stompScript.onerror = () => handleError('STOMP 加载失败')
    document.head.appendChild(stompScript)
  })
}

// 订阅个人频道
const subscribeToPersonalChannel = () => {
  if (stompClient && stompClient.connected) {
    // 如果已有订阅，先取消订阅
    if (subscription) {
      subscription.unsubscribe()
      subscription = null
      console.log('取消之前的订阅')
    }
    subscription = stompClient.subscribe('/topic/quiz/' + userId, (message) => {
      try {
        const data = JSON.parse(message.body)
        console.log('收到WebSocket消息:', data)
        // 只保留一条消息提示
        handleQuizData(data)
      } catch (error) {
        console.error('处理消息失败:', error)
        ElMessage.error('处理题目数据失败')
      }
    })
    console.log('已订阅个人频道: /topic/quiz/' + userId)
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
    if (data && typeof data === 'object' && data.questions && data.lastTime) {
      // 新格式：包含时间限制的数据
      quizData.value = Array.isArray(data.questions) ? data.questions : [data.questions]
      timeLeft.value = data.lastTime // 使用后端推送的时间限制（秒）
      currentPopQuizId.value = data.popQuizId // 保存PopQuiz ID
      currentActivityId.value = data.activityId // 保存活动ID
    } else if (Array.isArray(data)) {
      // 旧格式：直接是题目数组
      quizData.value = data
      timeLeft.value = 30 // 默认30秒
      currentPopQuizId.value = null // 旧格式没有PopQuiz ID
      currentActivityId.value = null // 旧格式没有活动ID
    } else if (data && typeof data === 'object') {
      // 可能是单个题目对象
      quizData.value = [data]
      timeLeft.value = 30 // 默认30秒
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
    ElMessage.success(`收到 ${quizData.value.length} 道题目，时间限制 ${timeLeft.value} 秒`)
    
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
    if (timeLeft.value > 0) {
      timeLeft.value--
    } else {
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

// 断开 WebSocket 连接
const disconnectWebSocket = () => {
  // 取消订阅
  if (subscription) {
    try {
      subscription.unsubscribe()
      subscription = null
      console.log('WebSocket 订阅已取消')
    } catch (error) {
      console.error('取消订阅失败:', error)
    }
  }
  if (stompClient) {
    try {
      stompClient.disconnect(() => {
        console.log('WebSocket 已断开连接')
      })
    } catch (error) {
      console.error('断开 WebSocket 连接失败:', error)
    }
    stompClient = null
  }
  if (timer) {
    clearInterval(timer)
    timer = null
  }
  isConnecting = false
  wsStatus.value = 'disconnected'
  wsStatusText.value = '未连接'
}

// 组件挂载时连接 WebSocket
onMounted(() => {
  console.log('组件挂载，准备连接WebSocket')
  // 延迟连接，确保组件完全加载
  setTimeout(() => {
    if (wsStatus.value === 'disconnected' && !isConnecting) {
      connectWebSocket()
    }
  }, 1000)
})

// 组件卸载时断开连接
onUnmounted(() => {
  disconnectWebSocket()
})

// 页面可见性变化时处理连接
document.addEventListener('visibilitychange', () => {
  if (document.hidden) {
    // 页面隐藏时，可以选择断开连接或保持连接
    console.log('页面隐藏')
  } else {
    // 页面显示时，检查连接状态
    if (wsStatus.value === 'disconnected' && !isConnecting) {
      console.log('页面重新显示，尝试重新连接WebSocket')
      connectWebSocket()
    }
  }
})
</script>

<style scoped>
.speech-page {
  min-height: 100vh;
  background: #f5f7fa;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
  position: relative;
}

.top-nav {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 0 16px;
  height: 52px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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

.activity-content-brief {
  background-color: #bbbbbb;
  font-size: 0.85rem;
  color: #fff;
  padding: 4px 20px 0 20px;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
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
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
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
  padding: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  max-width: 350px;
  word-break: break-all;
  margin: 0 auto;
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

.bottom-nav-student {
  background: white;
  border-top: 1px solid #f0f0f0;
  display: flex;
  padding: 8px 0;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10;
}

.bottom-nav-student .nav-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 8px 0;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #909399;
}

.bottom-nav-student .nav-item.active {
  color: #409eff;
}

.bottom-nav-student .nav-item span {
  font-size: 0.8rem;
  font-weight: 500;
}

/* WebSocket 状态指示器 */
.ws-status {
  position: fixed;
  top: 60px;
  right: 16px;
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 500;
  z-index: 100;
  backdrop-filter: blur(10px);
}

.ws-status.connected {
  background: rgba(103, 194, 58, 0.9);
  color: white;
}

.ws-status.connecting {
  background: rgba(230, 162, 60, 0.9);
  color: white;
}

.ws-status.disconnected {
  background: rgba(245, 108, 108, 0.9);
  color: white;
}

/* 答题弹窗样式 */
.quiz-dialog :deep(.el-dialog) {
  border-radius: 16px;
  max-width: 90vw;
  margin: 5vh auto;
}

.quiz-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 16px 20px;
}

.quiz-dialog :deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
}

.quiz-dialog :deep(.el-dialog__body) {
  padding: 0;
}

.quiz-content {
  padding: 20px;
}

.quiz-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.quiz-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.quiz-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
}

.quiz-count {
  font-size: 0.85rem;
  color: #666;
}

.timer {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 12px;
  background: #f0f9ff;
  border-radius: 20px;
  font-weight: 600;
  color: #409eff;
}

.timer.warning {
  background: #fef2f2;
  color: #f56c6c;
}

.question-container {
  margin-bottom: 24px;
}

.question-text {
  font-size: 1rem;
  font-weight: 500;
  color: #333;
  line-height: 1.6;
  margin-bottom: 20px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 12px;
  border-left: 4px solid #667eea;
}

.options-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.option-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: white;
  border: 2px solid #e9ecef;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.option-item:hover {
  border-color: #667eea;
  background: #f8f9ff;
}

.option-item.selected {
  border-color: #667eea;
  background: #667eea;
  color: white;
}

.option-label {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #e9ecef;
  border-radius: 50%;
  font-weight: 600;
  font-size: 0.9rem;
}

.option-item.selected .option-label {
  background: white;
  color: #667eea;
}

.option-text {
  flex: 1;
  font-size: 0.95rem;
  line-height: 1.4;
}

.quiz-actions {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  margin-top: 20px;
}

.quiz-actions .el-button {
  flex: 1;
  height: 44px;
  border-radius: 8px;
  font-weight: 600;
}

/* 结果弹窗样式 */
.result-dialog :deep(.el-dialog) {
  border-radius: 16px;
  max-width: 80vw;
  margin: 10vh auto;
}

.result-content {
  text-align: center;
  padding: 20px;
}

.result-icon {
  margin-bottom: 16px;
}

.result-text h3 {
  color: #333;
  margin-bottom: 8px;
  font-size: 1.2rem;
}

.result-text p {
  color: #666;
  font-size: 0.95rem;
  line-height: 1.5;
}

.result-actions {
  margin-top: 24px;
}

.result-actions .el-button {
  width: 120px;
  height: 40px;
  border-radius: 8px;
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
  cursor: pointer; /* 添加鼠标指针 */
}

.test-item:hover {
  border-color: #667eea;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
  transform: translateY(-2px); /* 添加悬停效果 */
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

/* 测试结果详情弹窗样式 */
.test-result-dialog :deep(.el-dialog) {
  border-radius: 16px;
  max-width: 95vw;
  margin: 5vh auto;
}

.test-result-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 16px 20px;
}

.test-result-dialog :deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
}

.test-result-dialog :deep(.el-dialog__body) {
  padding: 0;
}

.test-result-content {
  padding: 20px;
}

.result-summary {
  display: flex;
  justify-content: space-around;
  background: #f8f9fa;
  border-radius: 12px;
  padding: 15px 0;
  margin-bottom: 20px;
  border: 1px solid #e9ecef;
}

.summary-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.summary-value {
  font-size: 1.2rem;
  font-weight: 700;
  color: #333;
}

.summary-label {
  font-size: 0.8rem;
  color: #666;
}

.questions-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.question-result-item {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  border: 1px solid #e9ecef;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.question-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px dashed #eee;
}

.question-number {
  font-size: 0.9rem;
  font-weight: 600;
  color: #409eff;
}

.question-status {
  font-size: 0.8rem;
  padding: 4px 8px;
  border-radius: 12px;
}

.question-status.correct {
  background: #e1f3d8;
  color: #67c23a;
}

.question-status.incorrect {
  background: #fde2e2;
  color: #f56c6c;
}

.question-content {
  margin-bottom: 15px;
}

.question-text {
  font-size: 1rem;
  font-weight: 500;
  color: #333;
  line-height: 1.6;
  margin-bottom: 15px;
  padding: 12px;
  background: #f8f9fa;
  border-radius: 8px;
  border-left: 4px solid #667eea;
}

.options-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.option-result-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  position: relative;
}

.option-result-item.student-selected {
  border-color: #409eff;
  background: #e1f3d8;
  color: #67c23a;
}

.option-result-item.correct-answer {
  border-color: #67c23a;
  background: #e1f3d8;
  color: #67c23a;
}

.option-label {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #e9ecef;
  border-radius: 50%;
  font-weight: 600;
  font-size: 0.85rem;
}

.option-text {
  flex: 1;
  font-size: 0.9rem;
  line-height: 1.4;
}

.option-indicator {
  position: absolute;
  right: 12px;
  display: flex;
  gap: 4px;
}

.correct-icon {
  color: #67c23a;
  font-size: 0.9rem;
}

.incorrect-icon {
  color: #f56c6c;
  font-size: 0.9rem;
}

.answer-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 15px;
  padding-top: 12px;
  border-top: 1px dashed #eee;
}

.answer-label {
  font-size: 0.9rem;
  color: #666;
  font-weight: 500;
}

.student-answer {
  font-size: 0.9rem;
  font-weight: 600;
  color: #333;
}

.student-answer.correct {
  color: #67c23a;
}

.student-answer.incorrect {
  color: #f56c6c;
}

.correct-answer {
  font-size: 0.9rem;
  font-weight: 600;
  color: #67c23a;
}

.loading-result {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
}

.loading-result .is-loading {
  font-size: 2rem;
  color: #409eff;
  margin-bottom: 10px;
}

.loading-result span {
  font-size: 0.9rem;
  color: #909399;
}
</style>