# PopQuiz (PQ) 系统 - 前端

<div align="center">
  <img src="public/vite.svg" alt="PopQuiz Logo" width="120" height="120">

  <h3>基于AI大模型的智能随堂测验工具</h3>

  <p>
    <strong>PopQuiz</strong> 是一款专为知识分享场景设计的智能互动工具，支持课堂讲授、大咖演讲等多种应用场景。
  </p>

  <p>
    <img src="https://img.shields.io/badge/Vue-3.5.17-4FC08D?style=flat-square&logo=vue.js&logoColor=white" alt="Vue">
    <img src="https://img.shields.io/badge/Vite-7.0.5-646CFF?style=flat-square&logo=vite&logoColor=white" alt="Vite">
    <img src="https://img.shields.io/badge/Element_Plus-2.10.4-409EFF?style=flat-square&logo=element&logoColor=white" alt="Element Plus">
    <img src="https://img.shields.io/badge/Node.js-18+-339933?style=flat-square&logo=node.js&logoColor=white" alt="Node.js">
  </p>
</div>

---

## 📋 目录

- [系统概述](#系统概述)
- [环境配置说明](#环境配置说明)
- [安装步骤](#安装步骤)
- [开发环境启动](#开发环境启动)
- [生产环境部署](#生产环境部署)
- [功能使用说明](#功能使用说明)
- [故障排除](#故障排除)
- [技术栈](#技术栈)
- [项目结构](#项目结构)
- [贡献指南](#贡献指南)

---

## 🎯 系统概述

### 核心功能

**PopQuiz系统** 通过AI大模型技术，为知识分享场景提供智能化的互动体验：

- 🎤 **演讲者功能**：创建活动、发送题目、查看答题数据、管理学生反馈
- 👥 **听众功能**：加入活动、实时答题、提交问题反馈、查看个人报告
- 📊 **组织者功能**：创建活动、邀请用户、查看全量统计数据
- 🤖 **AI智能**：基于演讲内容自动生成个性化测验题目
- 📱 **多端支持**：响应式设计，支持桌面端和移动端

### 应用场景

- 📚 **课堂教学**：教师实时了解学生理解程度
- 🎙️ **企业培训**：培训师与学员的互动反馈
- 🏛️ **学术讲座**：演讲者与听众的实时互动
- 💼 **会议演示**：提升会议参与度和效果

---

## 🛠️ 环境配置说明

### 首先保证环境有Node.js，其版本要求如下

| 版本 | 状态 | 说明 |
|------|------|------|
| **Node.js 18.x** | ✅ 推荐 | 长期支持版本，稳定性最佳 |
| **Node.js 20.x** | ✅ 支持 | 最新特性支持 |
| **Node.js 16.x** | ⚠️ 最低要求 | 部分功能可能受限 |
| **Node.js 14.x** | ❌ 不支持 | 版本过低，不兼容 |

### 使用以下命令查看自己是否拥有node环境

```bash
# 推荐使用 npm (内置)
npm --version  # 应该 >= 8.0.0

# 或者使用 yarn
yarn --version  # 应该 >= 1.22.0

# 或者使用 pnpm (性能更好)
pnpm --version  # 应该 >= 7.0.0
```


### 开发工具推荐

- **IDE**: [Visual Studio Code](https://code.visualstudio.com/) + [Volar 插件](https://marketplace.visualstudio.com/items?itemName=Vue.volar)
- **浏览器**: Chrome 90+ / Firefox 88+ / Safari 14+ / Edge 90+
- **Git**: 版本控制必需，建议 2.20+

---

## 📦 安装步骤

### 1. 克隆项目

```bash
# 使用 HTTPS 克隆
git clone https://github.com/RainbowTeam706/RainbowTeam.git

# 或使用 SSH 克隆 (推荐)
git clone git@github.com:RainbowTeam706/RainbowTeam.git

# 进入前端项目目录
cd RainbowTeam/code/front/pq-vite
```

### 2. 安装依赖

```bash
# 使用 npm 安装 (推荐)
npm install

# 或使用 yarn 安装
yarn install

# 或使用 pnpm 安装 (更快)
pnpm install
```

### 3. 验证安装

```bash
# 检查依赖是否正确安装
npm list --depth=0

# 检查关键依赖版本
npm list vue vue-router element-plus
```

### 常见安装问题及解决方案

#### 问题 1: 网络连接超时

```bash
# 解决方案：使用国内镜像源
npm config set registry https://registry.npmmirror.com/

# 或临时使用镜像
npm install --registry https://registry.npmmirror.com/
```



#### 问题 2: Node.js 版本不兼容

```bash
# 解决方案：使用 nvm 管理 Node.js 版本
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装并使用 Node.js 18
nvm install 18
nvm use 18
```

#### 问题 4: 依赖冲突

```bash
# 解决方案：清理缓存并重新安装
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

---

## 🚀 开发环境启动

### 启动开发服务器

```bash
# 启动开发服务器
npm run dev

# 或使用 yarn
yarn dev

# 或使用 pnpm
pnpm dev
```

### 访问应用

启动成功后，您将看到类似输出：

```
  VITE v7.0.5  ready in 1234 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://192.168.1.100:5173/
  ➜  press h to show help
```

- **本地访问**: http://localhost:5173/
- **网络访问**: http://[您的IP地址]:5173/
- **默认端口**: 5173 (如端口被占用会自动递增)

### 开发服务器特性

- ⚡ **热重载 (HMR)**: 代码修改后自动刷新页面
- 🔧 **即时编译**: TypeScript/Vue 文件实时编译
- 🌐 **网络访问**: 支持局域网内其他设备访问

### 开发环境配置

如需修改开发服务器配置，编辑 `vite.config.js`：

```javascript
// vite.config.js
export default {
  server: {
    port: 3000,        // 自定义端口
    host: '0.0.0.0',   // 允许外部访问
    open: true,        // 自动打开浏览器
    cors: true         // 启用跨域
  }
}
```

---

### 常见问题及解决方案

#### 1. 页面无法加载

**症状**: 浏览器显示空白页面或加载错误

**可能原因及解决方案**:

```bash
# 检查开发服务器是否正常启动
npm run dev

# 检查端口是否被占用
netstat -an | grep 5173  # Windows
lsof -i :5173            # macOS/Linux

# 清理缓存并重新启动
rm -rf node_modules/.vite
npm run dev
```


#### 2. 依赖安装失败

**症状**: `npm install` 报错或依赖缺失

**解决方案**:

```bash
# 清理并重新安装
rm -rf node_modules package-lock.json
npm cache clean --force
npm install

# 检查 Node.js 版本
node --version  # 应该 >= 16.0.0

# 使用镜像源
npm install --registry https://registry.npmmirror.com/
```



#### 3. API 接口调用失败

**症状**: 前端无法连接后端API

**解决方案**:

1. **检查后端服务状态**:
```bash
# 检查后端服务是否启动
curl http://localhost:8080/api/health  # 替换为实际后端地址
```

2. **检查跨域配置**:
```javascript
// vite.config.js
export default {
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8080',  // 后端地址
        changeOrigin: true,
        secure: false
      }
    }
  }
}
```

3. **检查网络连接**:
```bash
# 测试网络连通性
ping your-backend-server.com
telnet your-backend-server.com 8080
```



### 获取帮助

如果以上解决方案无法解决您的问题，请：

1. **查看项目 Issues**: [GitHub Issues](https://github.com/RainbowTeam706/RainbowTeam/issues)
2. **提交新 Issue**: 详细描述问题和复现步骤
3. **联系开发团队**: 通过项目仓库联系方式
4. **查看官方文档**:
   - [Vue.js 官方文档](https://vuejs.org/)
   - [Vite 官方文档](https://vitejs.dev/)
   - [Element Plus 文档](https://element-plus.org/)

---


## 📁 项目结构

```
pq-vite/
├── index.html                  # 项目入口 HTML 文件
├── package-lock.json           # 依赖锁定文件，确保依赖版本一致
├── package.json                # 项目依赖及脚本配置
├── public/                     # 公共静态资源目录（不会被打包处理）
│   ├── pdf.worker.js           # PDF 相关的 worker 脚本
│   └── vite.svg                # Vite 标志图片
├── README.md                   # 项目说明文档
├── src/                        # 源码目录
│   ├── api/                    # 前端与后端接口请求相关 JS 文件
│   │   ├── activity.js         # 活动相关接口
│   │   ├── discussion.js       # 讨论区相关接口
│   │   ├── feedback.js         # 反馈相关接口
│   │   ├── quiz.js             # 测验相关接口
│   │   └── user.js             # 用户相关接口
│   ├── App.vue                 # Vue 主组件
│   ├── assets/                 # 静态资源（如图片等）
│   │   └── vue.svg             # Vue 标志图片
│   ├── components/             # 通用组件
│   │   ├── DiscussionArea.vue      # 讨论区主组件
│   │   ├── DiscussionAreaItem.vue  # 讨论区单条评论组件
│   │   ├── Login.vue               # 登录组件
│   │   ├── Main.vue                # 主页面组件
│   │   ├── Myself.vue              # 个人中心组件
│   │   └── NavBottom.vue           # 底部导航栏组件
│   ├── components-student/     # 学生端专用组件
│   │   ├── Speech-Student.css      # 学生端语音相关样式
│   │   └── Speech-Student.vue      # 学生端语音组件
│   ├── components-teacher/     # 教师端专用组件
│   │   ├── Popquiz-Teacher.vue     # 教师端弹出测验组件
│   │   ├── Speech-Teacher.css      # 教师端语音相关样式
│   │   └── Speech-Teacher.vue      # 教师端语音组件
│   ├── main.js                 # 项目入口 JS 文件
│   ├── router/                 # 路由配置目录
│   │   └── index.js                # 路由配置文件
│   ├── stores/                 # 状态管理相关文件
│   │   ├── activity.js             # 活动状态管理
│   │   ├── token.js                # Token 状态管理
│   │   └── userInfo.js             # 用户信息状态管理
│   ├── style.css               # 全局样式文件
│   └── utils/                  # 工具函数目录
│       └── request.js              # 封装的请求方法
├── vite.config.js              # Vite 配置文件
```
