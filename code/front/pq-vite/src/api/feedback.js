import request from '../utils/request'

/**
 * 反馈相关API接口
 * 包含教师端和学生端的反馈功能
 */

// ==================== 教师端接口 ====================

/**
 * 获取活动反馈统计数据
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回反馈统计数据
 */
export function getFeedbackStats(activityId) {
  return request.get(`/feedback/stats/${activityId}`)
}

/**
 * 获取学生提问列表
 * @param {string|number} activityId - 活动ID
 * @param {Object} params - 查询参数
 * @param {string} params.status - 问题状态 (all|answered|unanswered)
 * @param {number} params.page - 页码
 * @param {number} params.size - 每页数量
 * @returns {Promise} 返回学生提问列表
 */
export function getQuestions(activityId, params = {}) {
  return request.get(`/feedback/questions/${activityId}`, { params })
}

/**
 * 回复学生问题
 * @param {string|number} questionId - 问题ID
 * @param {string} reply - 回复内容
 * @returns {Promise} 返回回复结果
 */
export function replyQuestion(questionId, reply) {
  return request.post(`/feedback/reply/${questionId}`, {
    content: reply,
    replyTime: new Date().toISOString()
  })
}

/**
 * 标记问题已解答
 * @param {string|number} questionId - 问题ID
 * @returns {Promise} 返回操作结果
 */
export function markQuestionAnswered(questionId) {
  return request.patch(`/feedback/question/${questionId}/answered`, {
    answeredTime: new Date().toISOString()
  })
}

/**
 * 批量标记问题已解答
 * @param {Array} questionIds - 问题ID数组
 * @returns {Promise} 返回操作结果
 */
export function batchMarkAnswered(questionIds) {
  return request.patch('/feedback/questions/batch-answered', {
    questionIds,
    answeredTime: new Date().toISOString()
  })
}

/**
 * 删除学生问题（教师权限）
 * @param {string|number} questionId - 问题ID
 * @returns {Promise} 返回删除结果
 */
export function deleteQuestion(questionId) {
  return request.delete(`/feedback/question/${questionId}`)
}

/**
 * 获取实时反馈数据
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回实时反馈数据
 */
export function getRealTimeFeedback(activityId) {
  return request.get(`/feedback/realtime/${activityId}`)
}

/**
 * 获取反馈历史趋势
 * @param {string|number} activityId - 活动ID
 * @param {Object} params - 查询参数
 * @param {string} params.timeRange - 时间范围 (1h|3h|6h|1d)
 * @returns {Promise} 返回反馈趋势数据
 */
export function getFeedbackTrend(activityId, params = {}) {
  return request.get(`/feedback/trend/${activityId}`, { params })
}

/**
 * 导出反馈报告
 * @param {string|number} activityId - 活动ID
 * @param {Object} params - 导出参数
 * @param {string} params.format - 导出格式 (pdf|excel|csv)
 * @returns {Promise} 返回导出文件
 */
export function exportFeedbackReport(activityId, params = {}) {
  return request.get(`/feedback/export/${activityId}`, {
    params,
    responseType: 'blob' // 用于文件下载
  })
}

// ==================== 学生端接口 ====================

/**
 * 学生提交反馈
 * @param {string|number} activityId - 活动ID
 * @param {Object} feedbackData - 反馈数据
 * @param {string} feedbackData.pace - 节奏反馈 (fast|normal|slow)
 * @param {string} feedbackData.difficulty - 难度反馈 (hard|normal|easy)
 * @param {string} feedbackData.understanding - 理解程度 (clear|confused)
 * @param {number} feedbackData.interest - 兴趣度 (1-5)
 * @returns {Promise} 返回提交结果
 */
export function submitFeedback(activityId, feedbackData) {
  return request.post(`/feedback/submit/${activityId}`, {
    ...feedbackData,
    submitTime: new Date().toISOString()
  })
}

/**
 * 学生提交问题
 * @param {string|number} activityId - 活动ID
 * @param {Object} questionData - 问题数据
 * @param {string} questionData.content - 问题内容
 * @param {boolean} questionData.anonymous - 是否匿名
 * @param {string} questionData.category - 问题分类 (content|technical|other)
 * @returns {Promise} 返回提交结果
 */
export function submitQuestion(activityId, questionData) {
  return request.post(`/feedback/question/${activityId}`, {
    ...questionData,
    submitTime: new Date().toISOString()
  })
}

/**
 * 获取学生自己的反馈历史
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回学生反馈历史
 */
export function getMyFeedbackHistory(activityId) {
  return request.get(`/feedback/my-history/${activityId}`)
}

/**
 * 获取学生自己的提问历史
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回学生提问历史
 */
export function getMyQuestions(activityId) {
  return request.get(`/feedback/my-questions/${activityId}`)
}

/**
 * 学生点赞/取消点赞问题
 * @param {string|number} questionId - 问题ID
 * @param {boolean} isLike - 是否点赞
 * @returns {Promise} 返回操作结果
 */
export function likeQuestion(questionId, isLike = true) {
  return request.post(`/feedback/question/${questionId}/like`, { isLike })
}

// ==================== 通用接口 ====================

/**
 * 获取反馈配置
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回反馈配置
 */
export function getFeedbackConfig(activityId) {
  return request.get(`/feedback/config/${activityId}`)
}

/**
 * 更新反馈配置（教师权限）
 * @param {string|number} activityId - 活动ID
 * @param {Object} config - 配置数据
 * @param {boolean} config.enableFeedback - 是否启用反馈
 * @param {boolean} config.enableQuestions - 是否启用提问
 * @param {boolean} config.allowAnonymous - 是否允许匿名
 * @returns {Promise} 返回更新结果
 */
export function updateFeedbackConfig(activityId, config) {
  return request.put(`/feedback/config/${activityId}`, config)
}

/**
 * 获取反馈统计摘要
 * @param {string|number} activityId - 活动ID
 * @returns {Promise} 返回统计摘要
 */
export function getFeedbackSummary(activityId) {
  return request.get(`/feedback/summary/${activityId}`)
}
