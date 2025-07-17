<template>
  <div class="login-page">
    <div class="login-container">
      <div class="header">
        <el-icon size="40" class="logo-icon"><UserFilled /></el-icon>
        <h1 class="title">POP Quiz</h1>
      </div>
      
      <div class="form-section">
        <h2 class="form-title">{{ isLogin ? '登录' : '注册' }}</h2>
        
        <el-form 
          :model="form" 
          :rules="rules" 
          ref="formRef" 
          label-position="top"
          @submit.prevent="handleSubmit"
          class="login-form"
        >
          <el-form-item label="用户名" prop="username">
            <el-input 
              v-model="form.username" 
              placeholder="请输入用户名" 
              clearable 
              size="large"
            />
          </el-form-item>
          
          <el-form-item label="密码" prop="password">
            <el-input 
              v-model="form.password" 
              type="password" 
              placeholder="请输入密码" 
              show-password 
              clearable 
              size="large"
            />
          </el-form-item>
          
          <el-form-item v-if="!isLogin" label="确认密码" prop="confirmPassword">
            <el-input 
              v-model="form.confirmPassword" 
              type="password" 
              placeholder="请再次输入密码" 
              show-password 
              clearable 
              size="large"
            />
          </el-form-item>
          
          <el-form-item>
            <el-button 
              type="primary" 
              @click="handleSubmit" 
              size="large"
              class="submit-btn"
            >
              {{ isLogin ? '登录' : '注册' }}
            </el-button>
          </el-form-item>
        </el-form>
        
        <div class="toggle-section">
          <el-link 
            type="primary" 
            @click="toggleMode"
            class="toggle-link"
          >
            {{ isLogin ? '没有账号？去注册' : '已有账号？去登录' }}
          </el-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { UserFilled } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'


// 新增：导入login和register API
import { login, register } from '../api/user'
// 新增：导入setToken方法
import { setToken } from '../stores/token'


const router = useRouter()

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

async function handleSubmit() {
  formRef.value.validate(async valid => {
    if (!valid) return
    if (isLogin.value) {
      // 登录逻辑
      try {
        const res = await login(form.username, form.password)
        if (res.data.success) {
          ElMessage.success('登录成功')
          // 存储token到stores
          setToken(res.data.data) // 这里假设后端返回的token在res.data
          console.log(res.data.data)
          router.push('/main')
        } else {
          ElMessage.error('用户名或密码错误')
        }
      } catch (e) {
        ElMessage.error('登录失败，请检查网络')
      }
    } else {
      // 注册逻辑
      if (form.password !== form.confirmPassword) {
        ElMessage.error('两次输入的密码不一致！')
        return
      }
      try {
        const res = await register(form.username, form.password)
        if (res.success) {
          ElMessage.success('注册成功，请登录')
          // 注册成功后自动切换到登录模式
          isLogin.value = true
          form.username = ''
          form.password = ''
          form.confirmPassword = ''
          formRef.value && formRef.value.clearValidate()
        } else {
          ElMessage.error(res.data || '注册失败')
        }
      } catch (e) {
        ElMessage.error('注册失败，请检查网络')
      }
    }
  })
}







</script>

<style scoped>
/* 全局样式重置 */
* {
  box-sizing: border-box;
}

.login-page {
  min-height: 100vh;
  width: 100vw;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  background-attachment: fixed;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding-top: 60px;
  overflow-x: hidden;
  position: relative;
}

.login-container {
  width: calc(100% - 40px);
  max-width: 420px;
  padding: 0 20px;
  box-sizing: border-box;
  margin: 0 auto;
}

.header {
  text-align: center;
  margin-bottom: 40px;
}

.logo-icon {
  color: white;
  margin-bottom: 16px;
}

.title {
  color: white;
  font-size: 2.5rem;
  font-weight: 700;
  margin: 0;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

.form-section {
  background: white;
  border-radius: 20px;
  padding: 40px 30px;
  box-shadow: 0 20px 40px rgba(0,0,0,0.1);
  width: 100%;
  box-sizing: border-box;
}

.form-title {
  text-align: center;
  font-size: 1.8rem;
  font-weight: 600;
  color: #333;
  margin: 0 0 30px 0;
}

.login-form {
  width: 100%;
}

.login-form :deep(.el-form-item) {
  width: 100%;
  margin-bottom: 20px;
}

.login-form :deep(.el-form-item__content) {
  width: 100%;
}

.login-form :deep(.el-input) {
  width: 100%;
}

.login-form :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  border: 2px solid transparent;
  transition: all 0.3s ease;
  width: 100%;
  box-sizing: border-box;
  min-width: 0;
}

.login-form :deep(.el-input__wrapper:hover) {
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.2);
}

.login-form :deep(.el-input__wrapper.is-focus) {
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.login-form :deep(.el-input__inner) {
  width: 100%;
  box-sizing: border-box;
}

.login-form :deep(.el-form-item__label) {
  font-weight: 500;
  color: #555;
  padding-bottom: 8px;
}

.submit-btn {
  width: 100%;
  height: 48px;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  background: linear-gradient(135deg, #409eff 0%, #36a3f7 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
  transition: all 0.3s ease;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
}

.toggle-section {
  text-align: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.toggle-link {
  font-size: 1rem;
  font-weight: 500;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .login-page {
    padding-top: 40px;
    width: 100vw;
    overflow-x: hidden;
  }
  
  .login-container {
    width: calc(100% - 32px);
    padding: 0 16px;
    max-width: 100%;
  }
  
  .title {
    font-size: 2rem;
  }
  
  .form-section {
    padding: 30px 20px;
    border-radius: 16px;
    width: 100%;
    box-sizing: border-box;
  }
  
  .form-title {
    font-size: 1.5rem;
    margin-bottom: 25px;
  }
}

@media (max-width: 480px) {
  .login-page {
    padding-top: 20px;
    width: 100vw;
    overflow-x: hidden;
  }
  
  .login-container {
    width: calc(100% - 24px);
    padding: 0 12px;
  }
  
  .title {
    font-size: 1.8rem;
  }
  
  .form-section {
    padding: 25px 16px;
    width: 100%;
    box-sizing: border-box;
  }
  
  .form-title {
    font-size: 1.3rem;
  }
  
  .login-form :deep(.el-input__wrapper) {
    width: 100%;
    min-width: 0;
    max-width: 100%;
  }
}

/* 超小屏幕适配 */
@media (max-width: 360px) {
  .login-container {
    width: calc(100% - 16px);
    padding: 0 8px;
  }
  
  .form-section {
    padding: 20px 12px;
  }
  
  .title {
    font-size: 1.6rem;
  }
  
  .form-title {
    font-size: 1.2rem;
  }
}

/* 确保在设备仿真模式下内容不被截断 */
@media (max-width: 320px) {
  .login-container {
    width: calc(100% - 8px);
    padding: 0 4px;
  }
  
  .form-section {
    padding: 16px 8px;
  }
  
  .title {
    font-size: 1.4rem;
  }
  
  .form-title {
    font-size: 1.1rem;
  }
}
</style>