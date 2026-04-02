import request from '../utils/request'

// 获取我发起的活动
export function fetchCreatedActivities() {
  return request.get('/activity/listByMe')
}

// 获取我参与的活动
export function fetchJoinedActivities() {
  return request.get('/activity/listWithMe')
}

// ����
// export function joinActivity(inviteCode) {
//   return request.post('/activity/add', {inviteCode} )
// }
 export function joinActivity(inviteCode) {
  const params = new URLSearchParams();
  params.append('inviteCode', inviteCode);
  return request.post('/activity/add', params);
}
//创建活动
export function createActivity(data) {
  return request({
    url: '/activity/create',
    method: 'post',
    data
  })
}
// 发题（基于已生成的 popQuiz）
export function sendPopquiz({ popQuizId, questionCount, lastTime }) {
  return request.post('/quiz/popQuiz', {
    popQuizId,
    questionCount,
    lastTime
  })
}

export function submit(submitData) {
  return request.post(`/quiz/admit?popQuizId=${submitData.popQuizId}&userId=${submitData.userId}`, submitData.answers)
}

// 学生端：查询当前活动进行中的测验（用于刷新恢复）
export function getActiveQuiz(activityId, userId) {
  return request.get(`/quiz/active?activityId=${activityId}&userId=${userId}`)
}

// 学生端：保存答题草稿（用于断网/刷新恢复）
export function saveQuizDraft(popQuizId, userId, answers) {
  return request.post(`/quiz/draft?popQuizId=${popQuizId}&userId=${userId}`, answers)
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

// 文件解析任务：上传
export function uploadIngestFile(file, activityId) {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('activityId', activityId)
  return request.post('/file-ingest/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 文件解析任务：状态查询
export function getIngestStatus(taskId) {
  return request.get(`/file-ingest/status/${taskId}`)
}

// 文件解析任务：活动列表
export function getIngestTaskList(activityId) {
  return request.get(`/file-ingest/list/${activityId}`)
}


