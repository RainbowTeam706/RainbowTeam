import request from '../utils/request'

// ��ȡ�ҷ���Ļ
export function fetchCreatedActivities() {
  return request.get('/activity/listWithMe')
}

// ��ȡ�Ҳ���Ļ
export function fetchJoinedActivities() {
  return request.get('/activity/listByMe')
}

// ����
export function joinActivity(inviteCode) {
  return request.post('/activity/add', { inviteCode })
}
//�ݽ��з�����Ŀ
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