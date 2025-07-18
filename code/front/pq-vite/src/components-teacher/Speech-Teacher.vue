<!-- 此页面为“老师”点击主页面某一具体活动后跳转，显示活动信息、PPT预览、活动详情、底部导航 -->
<template>
  <div class="speech-page">
    <!-- 顶部导航栏 -->
    <div class="top-nav">
      <el-button class="back-btn" @click="$router.back()" link>
        <el-icon size="20"><ArrowLeft /></el-icon>
      </el-button>
      <div class="nav-title">
        <span>{{ activity.title }}({{ activity.createName }})</span>
        <el-tag
          :type="getStatusType(activity.status)"
          size="small"
          class="status-tag"
          >{{ getStatusText(activity.status) }}</el-tag
        >
      </div>
    </div>
    <!-- 活动简介小字 -->
    <!-- 内容区 -->

    <el-scrollbar max-height="560px" style="margin-top: 20px;">
      <div class="main-content">
        <!-- 活动详情 -->
        <div class="detail-content">
          <div class="invite-code small-invite center-invite">邀请码：{{ activity.inviteCode }}</div>
          <div class="activity-info-row multi-info-row">
            <span class="item-label" style="margin-left: 5px;">地点：</span>
            <span class="item-value">{{ activity.location }}</span>
            <span class="item-label" style="margin-left:18px;">人数：</span>
            <span class="item-value">{{ activity.curNum }}</span>
            <span class="item-label" style="margin-left:18px;"></span>
            <span class="item-value" style="margin-top: 5px;">{{ formatDate(activity.startTime) }} ~ {{ formatDate(activity.endTime) }}</span>
          </div>
          <div class="activity-content-brief" :title="activity.content">
            <span class="item-label">内容：</span>{{ activity.content }}
          </div>
        </div>
      </div>
       <!-- 文本输入框 /////////////////////////////////-->
        <!-- 文本输入区 -->
<el-input
  v-model="popquizText"
  type="textarea"
  :rows="14"
  placeholder="请在此输入或上传文件自动填充文本"
  class="popquiz-input"
></el-input>

<el-dialog v-model="popquizDialogVisible" title="生成题目" width="350px">
  <el-form :model="popquizForm">
    <el-form-item label="题目数量">
      <el-input v-model.number="popquizForm.count" type="number" min="1" placeholder="请输入题目数量" />
    </el-form-item>
    <el-form-item label="答题时长(分钟)">
      <el-input v-model.number="popquizForm.duration" type="number" min="1" placeholder="请输入总时长" />
    </el-form-item>
  </el-form>
  <template #footer>
    <el-button @click="popquizDialogVisible = false">取消</el-button>
    <el-button type="primary" @click="submitPopquiz">确定</el-button>
  </template>
</el-dialog>

<div class="popquiz-btn-row">
  <el-upload
    :show-file-list="false"
    :before-upload="handleFileUpload"
    accept=".pdf,.ppt,.pptx"
  >
    <el-button type="primary">上传PDF/PPT</el-button>
  </el-upload>
  <el-button
    :type="isRecording ? 'danger' : 'primary'"
    @click="toggleRecording"
    style="margin-left: 20px;"
  >
    {{ isRecording ? '停止录音' : '开始录音转文本' }}
  </el-button>
  <el-button type="success" @click="popquizDialogVisible = true" style="margin-left: 16px;">Popquiz</el-button>
</div>
    </el-scrollbar>
    <!-- 底部导航栏 -->
    <div class="bottom-nav-student">
      <div
        class="nav-item"
        :class="[
          { active: activeTab === 'popquiz' },
          { active: $route.path.includes('popquizTeacher') },
        ]"
        @click="
          activeTab = 'popquiz';
        "
      >
        <el-icon><Edit /></el-icon>
        <span>教师出题</span>
      </div>
      <div
        class="nav-item"
        :class="{ active: activeTab === 'test' }"
        @click="activeTab = 'test'"
      >
        <el-icon><Document /></el-icon>
        <span>测试列表</span>
      </div>
      <div
        class="nav-item"
        :class="{ active: activeTab === 'feedback' }"
        @click="activeTab = 'feedback'"
      >
        <el-icon><ChatDotRound /></el-icon>
        <span>反馈</span>
      </div>
      <div
        class="nav-item"
        :class="{ active: activeTab === 'comment' }"
        @click="activeTab = 'comment'"
      >
        <el-icon><Comment /></el-icon>
        <span>评论区</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import {
  ArrowLeft,
  Document,
  ChatDotRound,
  Comment,
  Edit,
} from "@element-plus/icons-vue";
import { useRoute } from 'vue-router'
import { useActivityStore } from '../stores/activity'
import { computed } from 'vue'
//文本提交相关
import * as pdfjsLib from "pdfjs-dist"
pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdf.worker.js"
import JSZip from "jszip" //解析ppt文件
//import PPTX from "pptxjs"
import { ElMessage } from "element-plus"
import { sendPopquiz } from "../api/activity" // 你需要实现这个API

const popquizText = ref("")
const popquizDialogVisible = ref(false)
const popquizForm = ref({ count: 1, duration: 10 })

//查询活动信息
const route = useRoute()
const activityStore = useActivityStore()

const activity = computed(() => activityStore.getActivityById(route.params.id) || {})



const isRecording = ref(false)
let recognition = null
//录音按钮
function toggleRecording() {
  if (!isRecording.value) {
    startRecording()
  } else {
    stopRecording()
  }
}
//录音内容
function startRecording() {
  // 兼容性判断
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
  if (!SpeechRecognition) {
    ElMessage.error("当前浏览器不支持语音识别")
    return
  }
  recognition = new SpeechRecognition()
  recognition.lang = "zh-CN" // 可根据需要设置语言
  recognition.continuous = false
  recognition.interimResults = false

  recognition.onstart = () => {
    isRecording.value = true
    ElMessage.info("开始录音，请说话...")
  }
  recognition.onerror = (event) => {
    isRecording.value = false
    ElMessage.error("录音出错: " + event.error)
  }
  recognition.onend = () => {
    isRecording.value = false
    ElMessage.info("录音结束")
  }
  recognition.onresult = (event) => {
    const transcript = event.results[0][0].transcript
    popquizText.value = transcript // 覆盖文本框
    ElMessage.success("识别成功，已填入文本框")
  }

  recognition.start()
}

function stopRecording() {
  if (recognition) {
    recognition.stop()
  }
}
// 处理文件上传
async function handleFileUpload(file) {
  console.log('upload',file)
  const ext = file.name.split('.').pop().toLowerCase()
  if (ext === 'pdf') {
    await readPdf(file)
  } else if (ext === 'pptx') {
    await readPptx(file)
  } else {
    ElMessage.error("只支持PDF或PPTX文件")
    return false
  }
  return false // 阻止自动上传
}
// 读取PDF文本
async function readPdf(file) {
  try {
    const arrayBuffer = await file.arrayBuffer()
   // console.log('arrayBuffer', arrayBuffer)
    const pdf = await pdfjsLib.getDocument({ data: arrayBuffer }).promise
  //  console.log('pdf loaded', pdf)
    let text = ""
    for (let i = 1; i <= pdf.numPages; i++) {
   //   console.log('reading page', i)
      const page = await pdf.getPage(i)
      const content = await page.getTextContent()
   //   console.log('page content', content)
      text += content.items.map(item => item.str).join(" ") + "\n"
    }
  //  console.log('text', text)
    popquizText.value = text
  } catch (e) {
    console.error('readPdf error', e)
  }
}
// 读取PPTX文本
async function readPptx(file) {
  try {
    const arrayBuffer = await file.arrayBuffer()
    const zip = await JSZip.loadAsync(arrayBuffer)
    let text = ""

    // 找到所有幻灯片文件
    const slideFiles = Object.keys(zip.files)
      .filter(name => /^ppt\/slides\/slide[0-9]+\.xml$/.test(name))
      .sort((a, b) => {
        const aMatch = a.match(/slide([0-9]+)\.xml/)
        const bMatch = b.match(/slide([0-9]+)\.xml/)
        const aNum = aMatch ? parseInt(aMatch[1]) : 0
        const bNum = bMatch ? parseInt(bMatch[1]) : 0
        return aNum - bNum
      })

    for (const slideName of slideFiles) {
      const xmlString = await zip.files[slideName].async("string")
      const parser = new DOMParser()
      const xmlDoc = parser.parseFromString(xmlString, "application/xml")
      const tNodes = xmlDoc.getElementsByTagName("a:t")
      for (let i = 0; i < tNodes.length; i++) {
        text += tNodes[i].textContent + " "
      }
      text += "\n"
    }
    popquizText.value = text
    console.log('pptx text', text)
  } catch (e) {
    ElMessage.error("PPTX解析失败，请尝试其他文件或联系开发者")
    console.error('pptx parse error', e)
  }
}
// Popquiz按钮提交
async function submitPopquiz() {
  if (!popquizText.value.trim()) {
    ElMessage.error("内容不能为空")
    return
  }
  if (!popquizForm.value.count || !popquizForm.value.duration) {
    ElMessage.error("请填写题目数量和时长")
    return
  }
  try {
      await sendPopquiz({
    activityId: activity.value.id,
    questionCount: popquizForm.value.count,
    lastTime: popquizForm.value.duration,
    text: popquizText.value
    })
    ElMessage.success("已发送到后端！")
    popquizDialogVisible.value = false
  } catch (e) {
    ElMessage.error("发送失败")
  }
}

const activeTab = ref("");
const getStatusText = (status) => {
  switch (status) {
    case 0:
      return "未开始";
    case 1:
      return "进行中";
    case 2:
      return "已结束";
    default:
      return "未知";
  }
};
function getStatusType(status) {
  switch (status) {
    case 0:
      return "primary";
    case 1:
      return "success";
    case 2:
      return "info";
    default:
      return "warning";
  }
}
// 格式化时间
function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleString('zh-CN', { hour12: false });
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
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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
.activity-info-row {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  font-size: 0.92rem;
  color: #333;
  padding: 2px 0;
}
.activity-info-row .item-label {
  font-weight: bold;
  color: #222;
  min-width: 40px;
  margin-right: 6px;
  font-size: 0.92rem;
}
.activity-info-row .item-value {
  color: #409eff;
  font-weight: 500;
  font-size: 0.92rem;
}
.activity-content-brief {
  background-color: #f0f4fa;
  font-size: 0.92rem;
  color: #333;
  padding: 8px 14px;
  margin: 14px 0 0 0;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(64,158,255,0.08);
  white-space: pre-line;
  word-break: break-all;
}
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 18px;
  padding: 0 20px;
}
.ppt-preview {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  min-height: 220px;
  max-height: 380px;
  margin-bottom: 8px;
  overflow: auto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.ppt-iframe {
  width: 100%;
  height: 360px;
  border: none;
}
.ppt-placeholder {
  color: #bbb;
  font-size: 1.1rem;
  text-align: center;
  padding: 40px 0;
}
.detail-content {
  background: #fff;
  border-radius: 16px;
  padding: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  max-width: 350px;
  word-break: break-all;
  margin: 0 auto;
}
.invite-code {
  text-align: center;
  font-size: 1.3rem;
  font-weight: bold;
  color: #409eff;
  margin-bottom: 18px;
}
.activity-detail-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
.activity-detail-list li {
  text-align: left;
  font-size: 0.8rem;
  color: #333;
  margin-bottom: 10px;
  font-weight: 500;
  word-break: break-all;
  white-space: pre-line;
}
.activity-detail-list li .item-label {
  font-weight: bold;
  color: #222;
}
.bottom-nav-student {
  background: white;
  border-top: 1px solid #f0f0f0;
  display: flex;
  padding: 8px 0;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10;
}
.bottom-nav-student .nav-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 8px 0;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #909399;
}
.bottom-nav-student .nav-item.active {
  color: #409eff;
}
.bottom-nav-student .nav-item span {
  font-size: 0.8rem;
  font-weight: 500;
}
.small-invite {
  font-size: 0.85rem;
  color: #888;
  margin-bottom: 8px;
  text-align: right;
}
.center-invite {
  text-align: center;
  display: block;
  margin-bottom: 10px;
  font-size: 1.08rem;
  color: #409eff;
  font-weight: bold;
}
.multi-info-row {
  flex-wrap: wrap;
  gap: 0 4px;
}
.multi-info-row .item-label,
.multi-info-row .item-value {
  white-space: nowrap;
}
.popquiz-input {
  width: 90%;
  margin: 20px auto 0 auto;
  display: block;
}
.popquiz-btn-row {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 12px 0 24px 0;
}
</style>
