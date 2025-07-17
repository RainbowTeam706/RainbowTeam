import request from '../utils/request'

// 获取我发起的活动
export function fetchCreatedActivities() {
  return request.get('/activity/listWithMe')
}

// 获取我参与的活动
export function fetchJoinedActivities() {
  return request.get('/activity/listByMe')
}