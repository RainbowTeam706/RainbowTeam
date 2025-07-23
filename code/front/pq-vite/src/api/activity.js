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
//演讲中发送题目
export function sendPopquiz({ activityId, questionCount, lastTime, text }) {
  return request.post('/quiz/popQuiz', null, 
    {
      activityId,
      questionCount,
      lastTime,
      text
    });//��ѩ���øģ�ȥ��params������ֱ�Ӵ��ݶ���
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

