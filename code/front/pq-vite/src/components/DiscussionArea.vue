<template>
  <!-- 讨论区弹窗，支持评论、回复、匿名、两级嵌套 -->
  <el-dialog
    :model-value="visible"
    @update:model-value="emit('update:visible', $event)"
    :title="title"
    width="90%"
    :close-on-click-modal="false"
    class="discussion-dialog"
  >
    <div class="discussion-content">
      <!-- 评论输入区 -->
      <div class="comment-input-section">
        <el-input
          v-model="newComment"
          type="textarea"
          :rows="2"
          placeholder="请输入评论内容..."
          maxlength="500"
          show-word-limit
        />
        <div class="comment-options">
          <el-checkbox v-model="isAnonymous">匿名</el-checkbox>
          <el-button type="primary" @click="submitComment" :disabled="!newComment.trim()">发送</el-button>
        </div>
      </div>
      <!-- 评论列表，两层渲染 -->
      <div class="comments-list">
        <div v-for="comment in comments" :key="comment.id" class="comment-item">
          <div class="comment-header">
            <span class="comment-author" :class="getAuthorClass(comment)">{{ getDisplayName(comment) }}</span>
          </div>
          <div class="comment-content">{{ comment.content }}</div>
          <div class="comment-footer">
            <span class="comment-time">{{ formatTime(comment.time) }}</span>
            <el-button size="small" text @click="startReply(comment)">回复</el-button>
          </div>
          <!-- 一级评论回复输入框 -->
          <div v-if="replyingToId === comment.id" class="reply-input-section">
            <el-input
              v-model="replyContentMap[comment.id]"
              type="textarea"
              :rows="2"
              :placeholder="'回复 @' + getDisplayName(comment)"
              maxlength="500"
              show-word-limit
            />
            <div class="comment-options">
              <el-checkbox v-model="replyAnonymousMap[comment.id]">匿名</el-checkbox>
              <el-button type="primary" @click="submitReply(comment)">回复</el-button>
              <el-button @click="cancelReply">取消</el-button>
            </div>
          </div>
          <!-- 二级评论列表 -->
          <div class="replies-list" v-if="comment.replies && comment.replies.length">
            <div v-for="reply in comment.replies" :key="reply.id" class="reply-item">
              <div class="comment-header reply-header">
                <span>
                  <span class="comment-author" :class="getAuthorClass(reply)">{{ getDisplayName(reply) }}</span>
                  <span class="reply-to"> 回复 </span>
                  <span class="comment-author" :class="getAuthorClass(getReplyToUser(reply))">{{ getDisplayName(getReplyToUser(reply)) }}</span>
                </span>
              </div>
              <div class="comment-content">{{ reply.content }}</div>
              <div class="comment-footer">
                <span class="comment-time">{{ formatTime(reply.time) }}</span>
                <el-button size="small" text @click="startReply(reply)">回复</el-button>
              </div>
              <!-- 二级评论回复输入框 -->
              <div v-if="replyingToId === reply.id" class="reply-input-section">
                <el-input
                  v-model="replyContentMap[reply.id]"
                  type="textarea"
                  :rows="2"
                  :placeholder="'回复 @' + getDisplayName(reply)"
                  maxlength="500"
                  show-word-limit
                />
                <div class="comment-options">
                  <el-checkbox v-model="replyAnonymousMap[reply.id]">匿名</el-checkbox>
                  <el-button type="primary" @click="submitReply(reply)">回复</el-button>
                  <el-button @click="cancelReply">取消</el-button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-if="comments.length === 0" class="empty-state">
          <el-icon size="48"><ChatDotRound /></el-icon>
          <p>暂无讨论</p>
        </div>
      </div>
    </div>
  </el-dialog>
</template>

<script setup>
// 讨论区主组件，支持评论、回复、匿名、两级嵌套，自动从后端获取并组装评论树
import { ref, defineProps, defineEmits, watch, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchDiscussionComments, sendDiscussionComment } from '../api/discussion' // 新API，自动组装两级树
//import { submitQuestion } from '../api/feedback' // 发送评论/回复
import { ChatDotRound } from '@element-plus/icons-vue'
import CommentItem from './DiscussionAreaItem.vue'

// props说明：
// visible: 控制弹窗显示
// activityId: 活动id
// myUserId/myUserName/myRole: 当前用户信息
// title: 弹窗标题
const props = defineProps({
  visible: Boolean,
  activityId: [String, Number],
  myUserId: [String, Number],
  myUserName: String,
  myRole: String, // 'teacher' | 'student'
  title: { type: String, default: '? 讨论区' },
  activityCreateId: [String, Number] // 新增：活动创建者id
})
const emit = defineEmits(['update:visible'])

// 评论输入区状态
const newComment = ref('')
const isAnonymous = ref(false)
// 评论树数据
const comments = ref([])
// 当前正在回复的评论id
const replyingToId = ref(null)
const replyContentMap = ref({}) // 每条评论的回复内容
const replyAnonymousMap = ref({}) // 每条评论的匿名状态
const commentMap = ref({})
function buildCommentMap(comments) {
  const map = {}
  function traverse(list) {
    list.forEach(item => {
      map[item.id] = item
      if (item.replies && item.replies.length) traverse(item.replies)
    })
  }
  traverse(comments)
  return map
}

// 计算当前用户角色
const activityCreateId = computed(() => {
  // 尝试从 props 里获取活动创建者id（需父组件传递或补充）
  return props.activityCreateId || null
})
const role = computed(() => {
  return String(props.myUserId) === String(activityCreateId.value) ? 'teacher' : 'student'
})

// 获取评论树（点击评论按钮或刷新时调用）
async function fetchComments() {
  try {
    const result = await fetchDiscussionComments(props.activityId)
    if (Array.isArray(result)) {
      comments.value = result
      commentMap.value = buildCommentMap(result)
    } else {
      comments.value = []
      commentMap.value = {}
      ElMessage.error('评论获取失败，请稍后重试')
    }
  } catch (e) {
    comments.value = []
    commentMap.value = {}
    ElMessage.error('评论获取失败，请检查网络或稍后重试')
  }
}

//进入弹窗时自动拉取评论
watch(() => props.visible, (val) => {
  if (val) fetchComments()
})

// 获取评论显示名（匿名处理）
function getDisplayName(objOrId) {
  if (typeof objOrId === 'object') {
    if (objOrId.anonymous && objOrId.userId !== props.myUserId) return '匿名'
    return objOrId.userName || '未知用户'
  } else if (typeof objOrId === 'number' || typeof objOrId === 'string') {
    const c = commentMap.value[objOrId]
    if (!c) return '未知用户'
    if (c.anonymous && c.userId !== props.myUserId) return '匿名'
    return c.userName || '未知用户'
  }
  return '未知用户'
}

// 发送一级评论
async function submitComment() {
  if (!newComment.value.trim()) return
  const data = {
    activityId: props.activityId,
    userId: props.myUserId,
    userName: props.myUserName,
    content: newComment.value,
    anonymous: isAnonymous.value,
    parentId: null,
    replyTo: null,
    time: new Date().toISOString(),
    role: role.value
  }
  console.log(data)
  const res = await sendDiscussionComment(data)
  if (res.data && res.data.success) {
    ElMessage.success('评论已发送')
    newComment.value = ''
    isAnonymous.value = false
    fetchComments()
  } else {
    ElMessage.error('发送失败')
  }
}
// 点击回复按钮，弹出输入框在对应评论下方
function startReply(comment) {
  replyingToId.value = comment.id
  if (replyContentMap.value[comment.id] === undefined) replyContentMap.value[comment.id] = ''
  if (replyAnonymousMap.value[comment.id] === undefined) replyAnonymousMap.value[comment.id] = false
}
// 取消回复
function cancelReply() {
  replyingToId.value = null
  // 不清空内容，便于用户切换
}
// 发送回复
async function submitReply(comment) {
  const content = replyContentMap.value[comment.id] || ''
  if (!content.trim()) return
  let parentId = comment.parentId
  if (!parentId) parentId = comment.id
  const data = {
    activityId: props.activityId,
    userId: props.myUserId,
    userName: props.myUserName,
    content,
    anonymous: replyAnonymousMap.value[comment.id],
    parentId,
    replyTo: comment.id,
    time: new Date().toISOString(),
    role: role.value
  }
  const res = await sendDiscussionComment(data)
  if (res.data && res.data.success) {
    ElMessage.success('回复已发送')
    replyContentMap.value[comment.id] = ''
    replyAnonymousMap.value[comment.id] = false
    replyingToId.value = null
    fetchComments()
  } else {
    ElMessage.error('回复失败')
  }
}

// 新增辅助方法
function getAuthorClass(comment) {
  if (!comment) return ''
  if (comment.userId === props.myUserId) return 'mine'
  if (comment.role === 'teacher' && !comment.anonymous) return 'teacher'
  return ''
}
function getReplyToUser(reply) {
  // reply.replyTo 可能是id，查找一级评论和二级评论
  if (!reply.replyTo) return null
  // 先查一级
  let user = comments.value.find(c => c.id === reply.replyTo)
  if (user) return user
  // 再查二级
  for (const c of comments.value) {
    if (c.replies) {
      const r = c.replies.find(r2 => r2.id === reply.replyTo)
      if (r) return r
    }
  }
  return null
}
function formatTime(time) {
  if (!time) return ''
  try {
    const date = new Date(time)
    const now = new Date()
    const isToday = date.toDateString() === now.toDateString()
    if (isToday) {
      return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    } else {
      return date.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit' }) + ' ' +
             date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    }
  } catch { return time }
}
</script>

<style scoped>
.discussion-content { padding: 20px; }
.comment-input-section, .reply-input-section { margin-bottom: 18px; }
.comment-options { display: flex; gap: 12px; align-items: center; margin-top: 8px; }
.comments-list { margin-bottom: 18px; }
.empty-state { text-align: center; color: #999; padding: 40px 0; }
.comment-item {
  margin-bottom: 12px;
  background: #f7f8fa; /* 一级评论浅灰色背景 */
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.03);
  padding: 6px 10px 4px 10px;
}
.reply-item {
  background: #f0f2f5; /* 二级评论更浅灰色 */
  margin-left: 32px;
  border-left: 3px solid #e0e0e0;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.03);
  padding: 6px 10px 4px 10px;
  margin-bottom: 8px;
}
.comment-header {
  font-weight: bold;
  font-size: 1.05em;
  margin-bottom: 1px;
}
.comment-author { color: #409eff; }
.comment-author.teacher { color: #ff9800 !important; }
.comment-author.mine { color: #67c23a !important; }
.reply-to { color: #888; font-weight: normal; margin: 0 2px; }
.comment-content {
  font-size: 1.08em;
  color: #222;
  margin: 1px 0 1px 0;
  word-break: break-word;
  text-align: left; /* 强制左对齐 */
}
.comment-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9em;
  color: #bbb;
  padding-top: 0;
  margin-top: 0;
}
.comment-footer .el-button {
  padding: 0;
  margin: 0 0 0 4px;
  font-size: 0.9em;
}
.comment-time { color: #bbb; }
.reply-header {
  text-align: right;
  font-weight: bold;
  font-size: 1.05em;
  margin-bottom: 1px;
}
</style> 