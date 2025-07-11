<template>
  <el-row justify="center" align="middle" style="min-height: 100vh; ">
    <el-col :xs="22" :sm="16" :md="10" :lg="8" style="width:100%;max-width:400px;">
      <el-card shadow="hover" class="login-card">
        <div class="header">
          <el-icon size="32"><UserFilled /></el-icon>
          <h1>POP Quiz</h1>
        </div>
        <el-divider />
        <h2 style="text-align:center;">{{ isLogin ? '登录' : '注册' }}</h2>
        <el-form :model="form" :rules="rules" ref="formRef" label-width="80px" @submit.prevent="handleSubmit">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="form.username" placeholder="请输入用户名" clearable />
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input v-model="form.password" type="password" placeholder="请输入密码" show-password clearable />
          </el-form-item>
          <el-form-item v-if="!isLogin" label="确认密码" prop="confirmPassword">
            <el-input v-model="form.confirmPassword" type="password" placeholder="请再次输入密码" show-password clearable />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSubmit" style="width:100%">{{ isLogin ? '登录' : '注册' }}</el-button>
          </el-form-item>
        </el-form>
        <div style="text-align:center; margin-top: 10px;">
          <el-link type="primary" @click="toggleMode">
            {{ isLogin ? '没有账号？去注册' : '已有账号？去登录' }}
          </el-link>
        </div>
      </el-card>
    </el-col>
  </el-row>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { UserFilled } from '@element-plus/icons-vue'

const isLogin = ref(true)
const form = reactive({
  username: '',
  password: '',
  confirmPassword: ''
})
const formRef = ref(null)

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
  confirmPassword: [
    { required: false, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value) => {
        if (!isLogin.value && value !== form.password) {
          return Promise.reject('两次输入的密码不一致！')
        }
        return Promise.resolve()
      },
      trigger: 'blur'
    }
  ]
}

function toggleMode() {
  isLogin.value = !isLogin.value
  form.username = ''
  form.password = ''
  form.confirmPassword = ''
  formRef.value && formRef.value.clearValidate()
}

function handleSubmit() {
  formRef.value.validate(valid => {
    if (!valid) return
    if (isLogin.value) {
      ElMessage.success(`登录：${form.username}`)
    } else {
      if (form.password !== form.confirmPassword) {
        ElMessage.error('两次输入的密码不一致！')
        return
      }
      ElMessage.success(`注册：${form.username}`)
    }
  })
}
</script>

<style scoped>
.login-card {
  margin-top: 40px;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.08);
  padding: 32px 16px 24px 16px;
  width: 100%;
  box-sizing: border-box;
}
.header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-bottom: 8px;
}
@media (max-width: 600px) {
  .login-card {
    padding: 20px 6px 16px 6px;
    margin-top: 10vw;
  }
  .header h1 {
    font-size: 1.4rem;
  }
  .el-form-item__label {
    font-size: 0.95rem;
  }
}
</style>