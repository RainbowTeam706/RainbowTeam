
<!-- 此页面为底部导航栏 -->


<template>
  <div class="main-layout">
    <div class="content-area">
      <router-view />
    </div>
    <div class="bottom-nav">
      <div
        class="nav-item"
        :class="{ active: $route.path.includes('classes') }"
        @click="$router.push('/main')"
      >
        <el-icon size="20"><School /></el-icon>
        <span>课堂</span>
      </div>
      <div
        class="nav-item"
        :class="{ active: $route.path.includes('myself') }"
        @click="$router.push('/myself')"
      >
        <el-icon size="20"><User /></el-icon>
        <span>我的</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { School, User } from '@element-plus/icons-vue'
</script>

<style scoped>
.main-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  width: 100vw;
  background: #f5f7fa;
}
.content-area {
  flex: 1;
  overflow: auto;
  /* 让内容区可滚动，底部导航栏始终在底部 */
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
.nav-item:hover,
.nav-item.active {
  color: #409eff;
}
.nav-item span {
  font-size: 0.8rem;
  font-weight: 500;
}
</style>