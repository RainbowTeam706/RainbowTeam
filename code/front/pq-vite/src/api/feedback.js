import request from '../utils/request'

// 获取活动反馈统计数据
export function getFeedbackStats(activityId) {
  return request.get('activity/feedbackStats', { params: { activityId } })
}
// 获取学生自己的反馈历史（如有用到）
export function getMyFeedbackHistory(activityId, userId) {
  console.log(activityId, userId)
  return request.get('activity/myFeedbackHistory', { params: { activityId, userId } })
}
// 学生提交反馈
export function submitFeedback(activityId, feedbackData) {
  // 字符串转数字
  const paceMap = { fast: 0, normal: 1, slow: 2 }
  const difficultyMap = { hard: 0, normal: 1, easy: 2 }
  const understandingMap = { clear: 0, confused: 1 }
  return request.get('activity/feedbackSubmit', {
    params: {
      activityId,
      pace: paceMap[feedbackData.pace],
      difficulty: difficultyMap[feedbackData.difficulty],
      understanding: understandingMap[feedbackData.understanding],
      userId: feedbackData.userId
    }
  })
}
// 获取学生提问列表
export function getQuestions(activityId, params = {}) {
  return request.get(`/feedback/questions/${activityId}`, { params })
}

// 标记问题已解答
export function markQuestionAnswered(questionId) {
  return request.patch(`/feedback/question/${questionId}/answered`, {
    answeredTime: new Date().toISOString()
  })
}


// 学生提交问题
export function submitQuestion(activityId, questionData) {
  return request.post(`/feedback/question/${activityId}`, {
    ...questionData,
    submitTime: new Date().toISOString()
  })
}


