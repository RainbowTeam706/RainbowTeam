<!-- 此页面为“学生”点击主页面某一具体活动后跳转，显示测试列表、活动详情、反馈 -->

<template>
  <div class="speech-page">
    <!-- 顶部导航栏 -->
    <div class="top-nav">
      <el-button class="back-btn" @click="$router.back()" link>
        <el-icon size="20"><ArrowLeft /></el-icon>
      </el-button>
      <div class="nav-title">
        <span>{{ activity.title }}</span>
        <el-tag :type="getStatusType(activity.status)" size="small" class="status-tag">{{ activity.status }}</el-tag>
      </div>
    </div>

    <!-- 顶部下方互斥按钮 -->
    <div class="switch-section">
      <el-button class="switch-btn" :class="{ active: activeTab === 'test' }" @click="activeTab = 'test'">测试列表</el-button>
      <el-button class="switch-btn" :class="{ active: activeTab === 'detail' }" @click="activeTab = 'detail'">活动详情</el-button>
      <el-button class="switch-btn" :class="{ active: activeTab === 'feedback' }" @click="activeTab = 'feedback'">反馈</el-button>
    </div>

    <!-- 内容区 -->
    <div class="tab-content">
      <template v-if="activeTab === 'test'">
        <el-scrollbar class="activity-list" max-height="590px">
          <div
            v-for="item in testList"
            :key="item.id"
            class="activity-item"
          >
            <div class="activity-content">
              <div class="activity-title">{{ item.title }}</div>
              <div class="activity-info">
                <span class="info-item">{{ item.duration }}</span>
                <span class="info-item">{{ item.location }}</span>
                <span class="info-item">{{ item.participants }}人</span>
              </div>
              <div class="activity-status">
                <el-tag :type="getStatusType(item.status)" size="small" class="status-tag">{{ item.status }}</el-tag>
              </div>
            </div>
          </div>
        </el-scrollbar>
      </template>
      <template v-else-if="activeTab === 'detail'">
        <div class="detail-content">
          <h3>活动详情</h3>
          <p>{{ activityDetail }}</p>
        </div>
      </template>
      <template v-else>
        <div class="feedback-content">
          <h3>反馈</h3>
          <el-form :model="feedbackForm" class="feedback-form">
            <el-form-item label="反馈内容">
              <el-input v-model="feedbackForm.content" type="textarea" placeholder="请输入反馈内容" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="submitFeedback">提交</el-button>
            </el-form-item>
          </el-form>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'


const router = useRouter()

// 模拟活动数据
const activity = reactive({
  title: '前端工程化实践',
  status: '进行中',
})

const getStatusType = (status) => {
  switch (status) {
    case '已结束': return 'info'
    case '进行中': return 'success'
    case '未开始': return 'primary'
    default: return 'info'
  }
}

const activeTab = ref('test')

// 测试列表数据
const testList = ref([
  { id: 1, title: '测试一', duration: '30分钟', location: '线上', participants: 10, status: '进行中' },
  { id: 2, title: '测试二', duration: '45分钟', location: '线下', participants: 8, status: '未开始' },
  { id: 3, title: '测试三', duration: '60分钟', location: '线上', participants: 12, status: '已结束' },
  { id: 3, title: '测试三', duration: '60分钟', location: '线上', participants: 12, status: '已结束' },
  { id: 3, title: '测试三', duration: '60分钟', location: '线上', participants: 12, status: '已结束' },
  { id: 3, title: '测试三', duration: '60分钟', location: '线上', participants: 12, status: '已结束' },
])

// 活动详情文本
const activityDetail = '本活动旨在提升前端工程化能力，内容涵盖自动化构建、模块化开发、持续集成等。'

// 反馈表单
const feedbackForm = reactive({ content: '' })
function submitFeedback() {
  if (!feedbackForm.content) return ElMessage.error('请输入反馈内容')
  ElMessage.success('反馈已提交！')
  feedbackForm.content = ''
}
</script>

<style scoped>
.speech-page {
  min-height: 100vh;
  background: #f5f7fa;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}
.top-nav {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 0 16px;
  height: 52px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.back-btn {
  color: white;
  margin-right: 12px;
}
.nav-title {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
  gap: 12px;
}
.status-tag {
  font-size: 0.8rem;
  padding: 4px 8px;
  border-radius: 12px;
}
.switch-section {
   padding: 16px 20px;
  background: white;
  display: flex;
  gap: 12px;
  border-bottom: 1px solid #f0f0f0;
}
.switch-btn {
  flex: 1;
  height: 28px;
  border-radius: 18px;
  font-size: 0.85rem;
  border: 1px solid #e4e7ed;
  background: white;
  color: #606266;
  transition: all 0.3s ease;
}
.switch-btn.active {
  background: #409eff;
  color: white;
  border-color: #409eff;
}
.tab-content {
  flex: 1;
  padding: 16px 20px;
  overflow-y: auto;
}
.activity-list {
  flex: 1;
  padding: 0;
  overflow-y: auto;
}
.activity-item {
  background: white;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}
.activity-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
  border-color: #409eff;
}
.activity-content {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.activity-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #303133;
  line-height: 1.4;
}
.activity-info {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
}
.info-item {
  font-size: 0.85rem;
  color: #606266;
  background: #f5f7fa;
  padding: 4px 8px;
  border-radius: 8px;
}
.activity-status {
  display: flex;
  justify-content: flex-end;
}
.detail-content, .feedback-content {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  margin-top: 24px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}
.feedback-form {
  margin-top: 16px;
}
.filter-section {
  padding: 16px 20px;
  background: white;
  display: flex;
  gap: 12px;
  border-bottom: 1px solid #f0f0f0;
}
</style>
