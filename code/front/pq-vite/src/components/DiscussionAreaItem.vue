<template>
  <div class="comment-item" :class="{ 'reply-item': isReply }">
    <div class="comment-header">
      <span class="comment-author" :class="authorClass">
        <template v-if="!isReply">{{ getDisplayName(comment) }}</template>
        <template v-else>
          {{ getDisplayName(comment) }}<span class="reply-to"> 回复 </span>{{ getDisplayName(comment.replyTo) }}
        </template>
      </span>
    </div>
    <div class="comment-content">{{ comment.content }}</div>
    <div class="comment-footer">
      <span class="comment-time">{{ formatTime(comment.time) }}</span>
      <el-button size="small" text @click="$emit('start-reply', comment)">回复</el-button>
    </div>
    <!-- 回复输入框，仅在当前评论被回复时显示 -->
    <div v-if="replyingToId === comment.id" class="reply-input-section">
      <el-input
        v-model="inputModel"
        type="textarea"
        :rows="2"
        :placeholder="'回复 @' + getDisplayName(comment)"
        maxlength="500"
        show-word-limit
      />
      <div class="comment-options">
        <el-checkbox v-model="checkboxModel">匿名</el-checkbox>
        <el-button type="primary" @click="$emit('submit-reply', comment)" :disabled="!inputModel.trim()">回复</el-button>
        <el-button @click="$emit('cancel-reply')">取消</el-button>
      </div>
    </div>
    <div class="replies-list" v-if="!isReply && comment.replies && comment.replies.length">
      <DiscussionAreaItem
        v-for="reply in comment.replies"
        :key="reply.id"
        :comment="reply"
        :myUserId="myUserId"
        :myRole="myRole"
        :getDisplayName="getDisplayName"
        :isReply="true"
        :replyingToId="replyingToId"
        :replyContent="replyContent"
        :replyAnonymous="replyAnonymous"
        @start-reply="$emit('start-reply', $event)"
        @submit-reply="$emit('submit-reply', $event)"
        @cancel-reply="$emit('cancel-reply')"
      />
    </div>
  </div>
</template>
<script setup>
import { computed, defineProps, watch, defineEmits } from 'vue'
const emit = defineEmits([
  'update:replyContent',
  'update:replyAnonymous',
  'start-reply',
  'submit-reply',
  'cancel-reply'
])
const props = defineProps({
  comment: Object,
  myUserId: [String, Number],
  myRole: String,
  getDisplayName: Function,
  isReply: Boolean,
  replyingToId: [String, Number],
  replyContent: String,
  replyAnonymous: Boolean
})
// 让输入框和匿名checkbox与父组件双向同步
import { ref, watchEffect } from 'vue'
const inputModel = ref('')
const checkboxModel = ref(false)
watchEffect(() => {
  if (props.replyingToId === props.comment.id) {
    inputModel.value = props.replyContent
    checkboxModel.value = props.replyAnonymous
  }
})
watch(inputModel, val => {
  if (props.replyingToId === props.comment.id) {
    emit('update:replyContent', val)
  }
})
watch(checkboxModel, val => {
  if (props.replyingToId === props.comment.id) {
    emit('update:replyAnonymous', val)
  }
})
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
const authorClass = computed(() => {
  if (props.comment.userId === props.myUserId) return 'mine'
  if (props.comment.role === 'teacher' && !props.comment.anonymous) return 'teacher'
  return ''
})
</script>
<style scoped>
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
</style>