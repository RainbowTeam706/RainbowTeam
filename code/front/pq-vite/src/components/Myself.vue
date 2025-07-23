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

  <el-dialog v-model="editDialogVisible" title="编辑昵称" width="350px">
  <el-form :model="editForm" label-width="60px">
    <el-form-item label="昵称">
      <el-input v-model="editForm.nickname" maxlength="20" show-word-limit />
    </el-form-item>
  </el-form>
  <template #footer>
    <el-button @click="editDialogVisible = false">取消</el-button>
    <el-button type="primary" @click="submitEdit">保存</el-button>
  </template>
</el-dialog>

</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getUserInfo } from '../api/user'
import { ElAvatar, ElButton, ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'

import { getToken } from '../stores/token' // 导入获取token的方法
const token = getToken()
import { updateUserInfo } from '../api/user'

const user = ref(null)
const loading = ref(true)
const error = ref('')
const router = useRouter()


// 编辑资料相关
const editDialogVisible = ref(false)
const editForm = ref({ nickname: '' })

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
  editForm.value.nickname = user.value?.nickname || ''
  editDialogVisible.value = true
}
function logout() {
  router.push('/login')
}


async function submitEdit() {
  if (!editForm.value.nickname.trim()) {
    ElMessage.error('昵称不能为空')
    return
  }
  try {
    const res = await updateUserInfo(user.value.username ,editForm.value.nickname,token)
    if (res.data && res.data.success) {
      ElMessage.success('修改成功')
      user.value.nickname = editForm.value.nickname
      editDialogVisible.value = false
    } else {
      ElMessage.error(res.data?.message || '修改失败')
    }
  } catch (e) {
    ElMessage.error('修改失败，请检查网络')
  }
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