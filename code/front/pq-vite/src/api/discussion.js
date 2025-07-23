import request from '../utils/request'

// 获取讨论区评论（扁平数组）并组装成两级树结构
export async function fetchDiscussionComments(activityId) {
  const res = await request.get(`/discussion/comments/${activityId}`)
  if (!res.data || !Array.isArray(res.data)) return []
  const flat = res.data
  // 一级评论：parentId为null
  const map = {}
  flat.forEach(item => {
    map[item.id] = { ...item, replies: [] }
  })
  const tree = []
  flat.forEach(item => {
    if (!item.parentId) {
      tree.push(map[item.id])
    } else if (map[item.parentId]) {
      // 二级评论
      map[item.parentId].replies.push(map[item.id])
    }
  })
  return tree
}

// 发送讨论区评论（一级或二级，parentId/replyTo 为空或 null 表示一级评论）
export async function sendDiscussionComment({ activityId, userId, userName, content, anonymous = false, parentId = null, replyTo = null, time, role }) {
  return request.post('/discussion/comments/comment', {
    activityId,
    userId,
    userName,
    content,
    anonymous,
    parentId,
    replyTo,
    time,
    role
  })
} 