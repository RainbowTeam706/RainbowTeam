<!-- src/components/Myself.vue -->
<template>
  <div class="profile-page">
    <div class="profile-header">
      <el-avatar :size="90" icon="el-icon-user-solid" class="avatar"/>
      <div class="nickname">{{ user?.nickname || '未设置昵称' }}</div>
      <div class="username">@{{ user?.username || '用户名获取中' }}</div>
    </div>
    <div class="profile-actions">
      <el-button type="primary" round size="small" @click="editProfile">编辑资料</el-button>
      <el-button type="danger" round size="small" @click="logout" plain>退出登录</el-button>
    </div>
    <div class="profile-info-card">
      <div class="info-item">
        <span class="label">用户名</span>
        <span class="value">{{ user?.username || '-' }}</span>
      </div>
      <div class="info-item">
        <span class="label">昵称</span>
        <span class="value">{{ user?.nickname || '-' }}</span>
      </div>
      <!-- 可扩展更多信息项 -->
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getUserInfo } from '../api/user'
import { ElAvatar, ElButton, ElMessage } from 'element-plus'

const user = ref(null)
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  loading.value = true
  error.value = ''
  try {
    const res = await getUserInfo()
    if (res.data && res.data.success) {
      user.value = res.data.data
    } else {
      error.value = '获取用户信息失败'
    }
  } catch (e) {
    error.value = '请求出错'
  } finally {
    loading.value = false
  }
})

function editProfile() {
  ElMessage.info('编辑资料功能待开发')
}
function logout() {
  ElMessage.info('退出登录功能待开发')
}
</script>

<style scoped>
.profile-page {
  min-height: 0;
  height: 100%;
  background: #f7f8fa;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 32px 0 24px 0;
  box-sizing: border-box;
}
.profile-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 18px;
}
.avatar {
  margin-bottom: 12px;
  background: #e0e0e0;
}
.nickname {
  font-size: 1.4rem;
  font-weight: 700;
  color: #222;
  margin-bottom: 4px;
}
.username {
  font-size: 1rem;
  color: #888;
  margin-bottom: 8px;
}
.profile-actions {
  display: flex;
  gap: 12px;
  margin-bottom: 18px;
}
.profile-info-card {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  padding: 22px 24px;
  width: 90vw;
  max-width: 400px;
  display: flex;
  flex-direction: column;
  gap: 18px;
}
.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 1.08rem;
  padding-bottom: 6px;
  border-bottom: 1px solid #f2f2f2;
}
.info-item:last-child {
  border-bottom: none;
}
.label {
  color: #888;
}
.value {
  color: #222;
  font-weight: 500;
}
@media (max-width: 480px) {
  .profile-info-card {
    padding: 16px 8px;
    width: 98vw;
    max-width: 98vw;
  }
}
</style>