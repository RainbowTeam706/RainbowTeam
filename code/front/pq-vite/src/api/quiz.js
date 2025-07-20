import request from '../utils/request'

/**
 * 测试/题目相关API接口
 * 包含教师端和学生端的测试功能
 */

// ==================== 教师端接口 ====================

/**
 * 发起PopQuiz（已存在于activity.js，这里重新整理）
 * @param {Object} quizData - 题目数据
 * @param {string|number} quizData.activityId - 活动ID
 * @param {number} quizData.questionCount - 题目数量
 * @param {number} quizData.lastTime - 答题时长（分钟）
 * @param {string} quizData.text - 基础文本内容
 * @returns {Promise} 返回生成的题目
 */
export function createPopQuiz(quizData) {
  return request.post('/quiz/popQuiz', null, {
    params: {
      activityId: quizData.activityId,
      questionCount: quizData.questionCount,
      lastTime: quizData.lastTime,
      text: quizData.text
    }
  })
}

/**
 * 获取活动的所有测试列表
 * @param {string|number} activityId - 活动ID
 * @param {Object} params - 查询参数
 * @param {string} params.status - 测试状态 (all|active|completed|draft)
 * @param {number} params.page - 页码
 * @param {number} params.size - 每页数量
 * @returns {Promise} 返回测试列表
 */
export function getQuizList(activityId, params = {}) {
  return request.get(`/quiz/list/${activityId}`, { params })
}

/**
 * 获取测试详情
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回测试详情
 */
export function getQuizDetail(quizId) {
  return request.get(`/quiz/detail/${quizId}`)
}

/**
 * 获取测试结果统计
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回测试统计数据
 */
export function getQuizStats(quizId) {
  return request.get(`/quiz/stats/${quizId}`)
}

/**
 * 获取测试参与者列表和答题情况
 * @param {string|number} quizId - 测试ID
 * @param {Object} params - 查询参数
 * @param {string} params.sortBy - 排序方式 (score|time|name)
 * @param {string} params.order - 排序顺序 (asc|desc)
 * @returns {Promise} 返回参与者列表
 */
export function getQuizParticipants(quizId, params = {}) {
  return request.get(`/quiz/participants/${quizId}`, { params })
}

/**
 * 结束测试
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回操作结果
 */
export function endQuiz(quizId) {
  return request.patch(`/quiz/end/${quizId}`, {
    endTime: new Date().toISOString()
  })
}

/**
 * 删除测试
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回删除结果
 */
export function deleteQuiz(quizId) {
  return request.delete(`/quiz/${quizId}`)
}

/**
 * 导出测试结果
 * @param {string|number} quizId - 测试ID
 * @param {Object} params - 导出参数
 * @param {string} params.format - 导出格式 (pdf|excel|csv)
 * @param {boolean} params.includeAnswers - 是否包含答案
 * @returns {Promise} 返回导出文件
 */
export function exportQuizResults(quizId, params = {}) {
  return request.get(`/quiz/export/${quizId}`, {
    params,
    responseType: 'blob'
  })
}

/**
 * 手动创建测试
 * @param {Object} quizData - 测试数据
 * @param {string|number} quizData.activityId - 活动ID
 * @param {string} quizData.title - 测试标题
 * @param {string} quizData.description - 测试描述
 * @param {number} quizData.duration - 答题时长（分钟）
 * @param {Array} quizData.questions - 题目列表
 * @returns {Promise} 返回创建结果
 */
export function createManualQuiz(quizData) {
  return request.post('/quiz/manual', {
    ...quizData,
    createTime: new Date().toISOString()
  })
}

/**
 * 更新测试信息
 * @param {string|number} quizId - 测试ID
 * @param {Object} updateData - 更新数据
 * @returns {Promise} 返回更新结果
 */
export function updateQuiz(quizId, updateData) {
  return request.put(`/quiz/${quizId}`, {
    ...updateData,
    updateTime: new Date().toISOString()
  })
}

// ==================== 学生端接口 ====================

/**
 * 获取学生可参与的测试列表
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回可参与的测试列表
 */
export function getAvailableQuizzes(activityId) {
  return request.get(`/quiz/available/${activityId}`)
}

/**
 * 开始答题
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回题目内容
 */
export function startQuiz(quizId) {
  return request.post(`/quiz/start/${quizId}`, {
    startTime: new Date().toISOString()
  })
}

/**
 * 提交答案
 * @param {string|number} quizId - 测试ID
 * @param {Object} answerData - 答案数据
 * @param {Array} answerData.answers - 答案列表
 * @param {number} answerData.timeSpent - 用时（秒）
 * @returns {Promise} 返回提交结果
 */
export function submitAnswers(quizId, answerData) {
  return request.post(`/quiz/submit/${quizId}`, {
    ...answerData,
    submitTime: new Date().toISOString()
  })
}

/**
 * 获取学生的答题结果
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回答题结果
 */
export function getMyQuizResult(quizId) {
  return request.get(`/quiz/my-result/${quizId}`)
}

/**
 * 获取学生的答题历史
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回答题历史
 */
export function getMyQuizHistory(activityId) {
  return request.get(`/quiz/my-history/${activityId}`)
}

/**
 * 保存答题进度（自动保存）
 * @param {string|number} quizId - 测试ID
 * @param {Object} progressData - 进度数据
 * @param {Array} progressData.currentAnswers - 当前答案
 * @param {number} progressData.currentQuestion - 当前题目索引
 * @param {number} progressData.timeSpent - 已用时间
 * @returns {Promise} 返回保存结果
 */
export function saveQuizProgress(quizId, progressData) {
  return request.post(`/quiz/save-progress/${quizId}`, {
    ...progressData,
    saveTime: new Date().toISOString()
  })
}

/**
 * 获取答题进度
 * @param {string|number} quizId - 测试ID
 * @returns {Promise} 返回答题进度
 */
export function getQuizProgress(quizId) {
  return request.get(`/quiz/progress/${quizId}`)
}

// ==================== 通用接口 ====================

/**
 * 获取测试配置
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回测试配置
 */
export function getQuizConfig(activityId) {
  return request.get(`/quiz/config/${activityId}`)
}

/**
 * 更新测试配置（教师权限）
 * @param {string|number} activityId - 活动ID
 * @param {Object} config - 配置数据
 * @param {boolean} config.autoGenerate - 是否启用AI自动生成
 * @param {number} config.defaultDuration - 默认答题时长
 * @param {number} config.defaultQuestionCount - 默认题目数量
 * @param {boolean} config.showResults - 是否显示结果
 * @returns {Promise} 返回更新结果
 */
export function updateQuizConfig(activityId, config) {
  return request.put(`/quiz/config/${activityId}`, config)
}

/**
 * 获取题目模板
 * @param {string} subject - 学科分类
 * @returns {Promise} 返回题目模板
 */
export function getQuestionTemplates(subject = '') {
  return request.get('/quiz/templates', { params: { subject } })
}
