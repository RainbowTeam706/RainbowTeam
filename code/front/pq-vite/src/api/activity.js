import request from '../utils/request'

// ��ȡ�ҷ���Ļ
export function fetchCreatedActivities() {
  return request.get('/activity/listWithMe')
}

// ��ȡ�Ҳ���Ļ
export function fetchJoinedActivities() {
  return request.get('/activity/listByMe')
}