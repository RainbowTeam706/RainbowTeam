<!-- 此页面为点击底部"课堂"后跳转，显示主页面：活动列表-->

<template>
  <div  style="padding: 0%">
    <!-- 顶部导航栏 -->
    <div class="top-nav">
      <el-button
        class="nav-btn"
        :class="{ active: activeNav === 'join' }"
        @click="
          joinDialogVisible = true;
          activeNav = 'join';
        "
      >
        加入活动
      </el-button>
      <!-- <el-button
        class="nav-btn"
        :class="{ active: activeNav === 'quick' }"
        @click="
          quickDialogVisible = true;
          activeNav = 'quick';
        "
      >
        快速会议
      </el-button> -->
      <el-button
        class="nav-btn"
        :class="{ active: activeNav === 'book' }"
        @click="
          bookDialogVisible = true;
          activeNav = 'book';
        "
      >
        预定会议
      </el-button>
    </div>

    <!-- 活动筛选按钮 -->
    <div class="filter-section">
      <el-button
        class="filter-btn"
        :class="{ active: activeFilter === 'all' }"
        @click="activeFilter = 'all'"
      >
        全部
      </el-button>
      <el-button
        class="filter-btn"
        :class="{ active: activeFilter === 'created' }"
        @click="activeFilter = 'created'"
      >
        我发起的
      </el-button>
      <el-button
        class="filter-btn"
        :class="{ active: activeFilter === 'joined' }"
        @click="activeFilter = 'joined'"
      >
        我参与的
      </el-button>
    </div>

    <!-- 活动列表 -->
     <el-scrollbar class="activity-list" max-height="520px">
      <div
  v-for="activity in filteredActivities"
  :key="activity.id"
  class="activity-item"
  @click="handleActivityClick(activity)"
  style="margin-top: 5px;"
>
  <div class="activity-content">
    <div class="activity-title">{{ activity.title }}</div>
    <div class="activity-info">
      <span class="info-item content-ellipsis" :title="activity.content">
        发起人：{{ activity.createName }}
      </span>
      <span class="info-item content-ellipsis" :title="activity.content">
        内容：{{ activity.content }}
      </span>
      <span class="info-item">
        时间：{{ formatDate(activity.startTime) }} ~ {{ formatDate(activity.endTime) }}
      </span>
      <span class="info-item">地点：{{ activity.location }}</span>
      <span class="info-item">人数：{{ activity.curNum }}</span>
      <span class="info-item">邀请码：{{ activity.inviteCode }}</span>

    </div>

    <div class="activity-status">
      <el-tag
        :type="getStatusType(activity.status)"
        size="small"
        class="status-tag"
      >
        {{ getStatusText(activity.status) }}
      </el-tag>
    </div>
  </div>
</div>
  </el-scrollbar>


    <!-- 加入活动弹窗 -->
    <el-dialog v-model="joinDialogVisible" title="加入活动" width="300px">
      <el-form :model="joinForm">
        <el-form-item label="邀请码">
          <el-input v-model="joinForm.code" placeholder="请输入邀请码" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="joinDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleJoin">确定</el-button>
      </template>
    </el-dialog>

    <!-- 快速会议弹窗
    <el-dialog v-model="quickDialogVisible" title="快速会议" width="300px">
      <el-form :model="quickForm">
        <el-form-item label="时长(分钟)">
          <el-input
            v-model="quickForm.duration"
            type="number"
            placeholder="请输入时长"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="quickDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleQuick">确定</el-button>
      </template>
    </el-dialog> -->
<!-- 预定会议弹窗 -->
<el-dialog v-model="bookDialogVisible" title="预定会议" width="400px"  draggable top="5vh" class="custom-book-dialog">
  <el-form :model="bookForm" label-width="80px">
    <el-form-item label="标题">
      <el-input v-model="bookForm.title" placeholder="请输入标题" />
    </el-form-item>
    <el-form-item label="内容">
      <el-input v-model="bookForm.content" placeholder="请输入内容" />
    </el-form-item>
    <el-form-item label="位置">
      <el-input v-model="bookForm.location" placeholder="请输入位置" />
    </el-form-item>
    <el-form-item label="开始时间">
      <el-date-picker
        v-model="bookForm.startTime"
        type="datetime"
        placeholder="选择开始时间"
        style="width: 100%;"
        value-format="YYYY-MM-DDTHH:mm:ss"
        editable="false"
        :input-attr="{ readonly: true }"
        teleported="false"
      />
    </el-form-item>
    <el-form-item label="结束时间">
      <el-date-picker
        v-model="bookForm.endTime"
        type="datetime"
        placeholder="选择结束时间"
        style="width: 100%;"
        value-format="YYYY-MM-DDTHH:mm:ss"
        editable="false"
        :input-attr="{ readonly: true }"
        teleported="false"
      />
    </el-form-item>
  </el-form>
  <template #footer>
    <el-button @click="bookDialogVisible = false">取消</el-button>
    <el-button type="primary" @click="handleBook">确定</el-button>
  </template>
</el-dialog>


<!-- main-page结束 -->
  </div>
</template>

<script setup>
import { ref, computed , reactive} from "vue";
import { ElMessage } from "element-plus";
import { School, User } from "@element-plus/icons-vue";
// 新增：导入获取活动列表API
import { fetchCreatedActivities, fetchJoinedActivities, joinActivity, createActivity } from '../api/activity'
import { onMounted, watch } from 'vue'
import { useRouter } from 'vue-router';

const router = useRouter()
const activeNav = ref("join");
const activeTab = ref("classroom");
//当前用户信息，全局可用

import { useUserInfoStore } from '../stores/userInfo'
const userInfoStore = useUserInfoStore()
//console.log(userInfoStore.id, userInfoStore.username, userInfoStore.nickname)
//将活动列表存下来，后续可用
import { useActivityStore } from '../stores/activity'
const activityStore = useActivityStore()
// 活动对象结构说明
const activities = ref([
  {
    id: null,                  // 活动ID
    createId: '',            // 创建者ID
    title: '',              // 活动标题
    content: '',            // 活动内容
    createName:'',
    location: '',           // 地点
    startTime: '',          // 开始时间（ISO格式字符串）
    endTime: '',            // 结束时间（ISO格式字符串）
    inviteCode: '',         // 邀请码
    createTime: '',         // 创建时间（ISO格式字符串）
    curNum: null,              // 当前参与人数
    status: null               // 活动状态（0=未开始, 1=进行中, 2=已结束...）
  }
])
const activeFilter = ref('all') // 当前筛选条件

// 加载活动数据，根据筛选条件请求不同接口
async function loadActivities() {
  try {
    console.log(activeFilter.value)
    if (activeFilter.value === 'all') {
      // 并发请求“我发起的”和“我参与的”活动
      const [createdRes, joinedRes] = await Promise.all([
        fetchCreatedActivities(),
        fetchJoinedActivities()
      ])
      // 合并两个接口返回的数据
      activities.value = [
        ...(createdRes.data.data || []),
        ...(joinedRes.data.data || [])
      ]
    } else if (activeFilter.value === 'created') {
      const res = await fetchCreatedActivities()
      activities.value = res.data.data || []
    } else if (activeFilter.value === 'joined') {
      const res = await fetchJoinedActivities()
      activities.value = res.data.data || []
    }
    ElMessage.success('刷新成功')
  } catch (e) {
    ElMessage.error('获取活动失败')
  }
  activityStore.setActivities(activities.value) // 新增：同步到全局 store
}
// 页面加载时和筛选条件变化时都要加载
onMounted(loadActivities)
watch(activeFilter, loadActivities)
// activities直接渲染
const filteredActivities = computed(() => activities.value)
// //根据status返回不同的颜色
// function getStatusType(status) {
//   switch (status) {
//     case "已结束":
//       return "info";
//     case "进行中":
//       return "success";
//     case "未开始":
//       return "primary";
//     default:
//       return "info";
//   }
// }
// 格式化时间
function formatDate(dateStr) {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  return d.toLocaleString('zh-CN', { hour12: false });
}

// 状态文本
function getStatusText(status) {
  switch (status) {
    case 0: return '未开始';
    case 1: return '进行中';
    case 2: return '已结束';
    default: return '未知';
  }
}

// 状态颜色
function getStatusType(status) {
  switch (status) {
    case 0: return 'primary';
    case 1: return 'success';
    case 2: return 'info';
    default: return 'warning';
  }
}


function handleActivityClick(activity) {
  // 跳转到活动详情页面，对应的活动详情内容 传入info store 
  // InfoStore.setInfo(activity);
 //根据是否为发起人决定页面跳转
  const userId = userInfoStore.id
  if(activity.createId === userId){ // 跳转到演讲者页面
    console.log('okkk')
    router.push({ name: 'speechTeacher', params: { id: activity.id } })
  }
  else { //跳转到听众界面
    router.push({ name: 'speechStudent', params: { id: activity.id } })
  }
 //  router.push('/speechStudent');
}

// 弹窗控制
const joinDialogVisible = ref(false);
const quickDialogVisible = ref(false);
const bookDialogVisible = ref(false);

// 表单数据
const joinForm = reactive({ code: "" });
const quickForm = reactive({ duration: "" });
const bookForm = reactive({
  title: "",
  content: "",
  location: "",
  startTime: "",
  endTime: "",
});

// 加入活动提交方法
async function handleJoin() {
  if (!joinForm.code) {
    return ElMessage.error("请输入邀请码");
  }
  try {
    // 调用后端接口
    console.log(userInfoStore.id)
    console.log(joinForm.code)
    const res = await joinActivity(joinForm.code);
    // 假设后端返回 { success: true, data: ... }
    if (res.data && res.data.success) {
      ElMessage.success("加入活动成功！");
      // 可选：刷新活动列表
      await loadActivities();
      joinDialogVisible.value = false;
    } else {
      ElMessage.error(res.data.errorMsg);
    }
  } catch (e) {
    ElMessage.error("加入活动请求失败！");
  }
}

function handleQuick() {
  if (!quickForm.duration) return ElMessage.error("请输入活动时长");
  ElMessage.success("已提交时长: " + quickForm.duration + "分钟");
  quickDialogVisible.value = false;
}
//创建活动提交方法
async function handleBook() {
  if (
    !bookForm.title ||
    !bookForm.content ||
    !bookForm.location ||
    !bookForm.startTime ||
    !bookForm.endTime
  ) {
    return ElMessage.error("请填写完整信息");
  }
  // 方案二：将本地时间字符串转为UTC的ISO字符串（去掉Z）
  function toUTCString(localStr) {
    const [date, time] = localStr.split('T')
    const [year, month, day] = date.split('-')
    const [hour, minute, second] = time.split(':')
    const localDate = new Date(
      Number(year), Number(month) - 1, Number(day),
      Number(hour), Number(minute), Number(second)
    )
    return localDate.toISOString().slice(0, 19)
  }
  try {
    const res = await createActivity({
      title: bookForm.title,
      content: bookForm.content,
      location: bookForm.location,
      startTime: toUTCString(bookForm.startTime),
      endTime: toUTCString(bookForm.endTime)
    })
    if (res.data && res.data.success) {
      ElMessage.success("活动创建成功！");
      bookDialogVisible.value = false;
      await loadActivities();
    } else {
      ElMessage.error(res.data?.message || "创建失败！");
    }
  } catch (e) {
    ElMessage.error("创建活动请求失败！");
  }
}
</script>


<style> 

/* 让 el-dialog-body 在移动端最大高度为视口高度，内容可滚动 */
.el-dialog__body {
  max-height: 60vh;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}

/* 修复 el-picker-panel 在移动端弹窗内显示不全问题 */
.el-picker-panel {
  max-height: 60vh !important;
  overflow-y: auto !important;
  -webkit-overflow-scrolling: touch;
}

/* 防止弹窗打开时背景页面跟随滚动 */
.el-overlay {
  touch-action: none;
  overscroll-behavior: contain;
}

</style>
<style scoped>

.content-ellipsis {
  display: inline-block;
  max-width: 300px;      /* 根据实际布局调整宽度 */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  vertical-align: bottom;
}
.main-page {
  min-height: 100vh;
  background: #f5f7fa;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

.top-nav {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 0%;
  display: flex;
  gap: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.nav-btn {
  flex: 1;
  height: 40px;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 500;
  border: 2px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  color: white;
  transition: all 0.3s ease;
}

.nav-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

.nav-btn.active {
  background: white;
  color: #667eea;
  border-color: white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.filter-section {
  padding: 16px 20px;
  background: white;
  display: flex;
  gap: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.filter-btn {
  flex: 1;
  height: 28px;
  border-radius: 18px;
  font-size: 0.85rem;
  border: 1px solid #e4e7ed;
  background: white;
  color: #606266;
  transition: all 0.3s ease;
}

.filter-btn:hover {
  border-color: #409eff;
  color: #409eff;
}

.filter-btn.active {
  background: #409eff;
  color: white;
  border-color: #409eff;
}

.activity-list {
  flex: 1;
  padding: 16px 20px;
  overflow-y: auto;
}

.activity-item {
  background: white;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.activity-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
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

.status-tag {
  font-size: 0.8rem;
  padding: 4px 8px;
  border-radius: 12px;
}

.bottom-nav {
  background: white;
  border-top: 1px solid #f0f0f0;
  display: flex;
  padding: 8px 0;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
}

.nav-item {
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

.nav-item:hover {
  color: #409eff;
}

.nav-item.active {
  color: #409eff;
}

.nav-item span {
  font-size: 0.8rem;
  font-weight: 500;
}

@media (max-width: 768px) {
  .top-nav {
    padding: 12px 16px;
    gap: 8px;
  }

  .nav-btn {
    height: 36px;
    font-size: 0.85rem;
  }

  .filter-section {
    padding: 12px 16px;
    gap: 8px;
  }

  .filter-btn {
    height: 32px;
    font-size: 0.8rem;
  }

  .activity-list {
    padding: 12px 16px;
  }

  .activity-item {
    padding: 16px;
    margin-bottom: 12px;
  }

  .activity-title {
    font-size: 1rem;
  }

  .info-item {
    font-size: 0.8rem;
  }
}

@media (max-width: 480px) {
  .top-nav {
    padding: 10px 12px;
    gap: 6px;
  }

  .nav-btn {
    height: 32px;
    font-size: 0.8rem;
  }

  .filter-section {
    padding: 10px 12px;
    gap: 6px;
  }

  .filter-btn {
    height: 28px;
    font-size: 0.75rem;
  }

  .activity-list {
    padding: 10px 12px;
  }

  .activity-item {
    padding: 14px;
    margin-bottom: 10px;
  }

  .activity-title {
    font-size: 0.95rem;
  }

  .info-item {
    font-size: 0.75rem;
    padding: 3px 6px;
  }

  .status-tag {
    font-size: 0.75rem;
  }
}

/* 优化 el-dialog 和 el-picker-panel 在移动端的显示 */
:deep(.el-dialog__body) {
  max-height: 60vh;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}
:deep(.el-picker-panel) {
  max-width: 98vw !important;
  min-width: 0 !important;
  box-sizing: border-box !important;
  left: 0 !important;
  right: auto !important;
  overflow-y: auto !important;
  max-height: 60vh !important;
}
:deep(.el-picker-panel__footer) {
  position: sticky;
  bottom: 0;
  background: #fff;
  z-index: 2;
}
:deep(.custom-book-dialog .el-dialog) {
  left: 5vw !important;
  right: auto !important;
  margin: 0 !important;
  top: 5vh !important;
  transform: none !important;
}
@media (max-width: 600px) {
  :deep(.el-dialog) {
    width: 95vw !important;
    min-width: unset !important;
    max-width: 98vw !important;
  }
  :deep(.custom-book-dialog .el-dialog) {
    width: 98vw !important;
    left: 1vw !important;
    top: 2vh !important;
  }
}
/* 让表单项更紧凑 */
:deep(.el-form-item) {
  margin-bottom: 12px !important;
}
:deep(.custom-book-dialog .el-picker-panel) {
  left: 20px !important;
  right: auto !important;
  transform: none !important;
}
</style>






