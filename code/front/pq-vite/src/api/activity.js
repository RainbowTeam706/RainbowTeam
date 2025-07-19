import request from '../utils/request'

// 获取我发起的活动
export function fetchCreatedActivities() {
  return request.get('/activity/listWithMe')
}

// 获取我参与的活动
export function fetchJoinedActivities() {
  return request.get('/activity/listByMe')
}

// 加入活动
export function joinActivity(inviteCode) {
  return request.post('/activity/add', { inviteCode })
}
//演讲中发送题目
export function sendPopquiz({ activityId, questionCount, lastTime, text }) {
  return request.post('/quiz/popQuiz', null, {
    params: {
      activityId,
      questionCount,
      lastTime,
      text
    }
  })
}

export function submit(submitData) {
  return request.post(`/quiz/admit?popQuizId=${submitData.popQuizId}&userId=${submitData.userId}`, submitData.answers)
}

export function ExamList(activityId) {
  return request.get(`/quiz/list/${activityId}`)
}
export function ShowTestService(popQuizId,userId) {
  return request.get(`/quiz/result/${popQuizId}/${userId}`)
}
export function GetExamStat(popQuizId) {
  return request.get(`/quiz/stat/${popQuizId}`)
}