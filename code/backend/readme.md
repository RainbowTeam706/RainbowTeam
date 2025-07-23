# 🚀 后端部署指南

本文档详细介绍了PQ项目后端服务的部署步骤，包括环境准备、配置和启动流程。

## 📋 目录

- [环境要求](#环境要求)
- [部署步骤](#部署步骤)
- [配置说明](#配置说明)
- [验证部署](#验证部署)
- [常见问题](#常见问题)
- [性能优化](#性能优化)

## 🔧 环境要求

### 必需软件

| 软件 | 版本要求 | 说明 |
|------|----------|------|
| **JDK** | 8+ | Java开发环境 |
| **IntelliJ IDEA** | 2020.3+ | 推荐使用Ultimate版本 |
| **MySQL** | 5.7+ / 8.0+ | 数据库服务 |
| **Redis** | 5.0+ | 缓存服务 |
| **Maven** | 3.6+ | 项目构建工具（IDEA内置） |

### 系统要求

- **操作系统**: Windows 10+, macOS 10.14+, Linux
- **内存**: 最低4GB，推荐8GB+
- **磁盘空间**: 至少2GB可用空间

## 🚀 部署步骤

### 步骤1: 项目导入与配置

#### 1.1 导入项目

1. 启动 **IntelliJ IDEA**
2. 选择 `File` → `Open` 或 `Open or Import`
3. 导航到项目根目录 `code/backend/pq`
4. 点击 `OK` 导入项目

#### 1.2 配置JDK

1. 打开 `File` → `Project Structure` (快捷键: `Ctrl+Alt+Shift+S`)
2. 在 `Project` 选项卡中：
   - **Project SDK**: 选择本地安装的JDK 8+
   - **Project language level**: 选择对应的语言级别
3. 点击 `Apply` 和 `OK`

#### 1.3 Maven配置

1. 在右侧找到 **Maven** 面板（如未显示，通过 `View` → `Tool Windows` → `Maven` 打开）
2. 点击 🔄 **重新加载所有Maven项目** 按钮
3. 等待依赖下载完成（首次可能需要几分钟）

> **💡 提示**: 如果Maven下载缓慢，可以配置国内镜像源

### 步骤2: 数据库准备

#### 2.1 启动MySQL服务

确保MySQL服务正在运行：

```bash
# Windows (以管理员身份运行命令提示符)
net start mysql

# macOS/Linux
sudo systemctl start mysql
# 或
sudo service mysql start
```

#### 2.2 创建数据库

1. 连接到MySQL：
```bash
mysql -u root -p
```

2. 创建数据库：
```sql
CREATE DATABASE pq CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 2.3 导入SQL脚本

```bash
# 方式1: 命令行导入
mysql -u root -p pq < path/to/your/sql/script.sql

# 方式2: 在MySQL客户端中
USE pq;
SOURCE path/to/your/sql/script.sql;
```

> **⚠️ 注意**: 请将 `path/to/your/sql/script.sql` 替换为实际的SQL脚本文件路径

### 步骤3: Redis服务配置

#### 3.1 Windows环境

如果系统中没有Redis，使用提供的Windows版本：

1. 解压Redis压缩包到指定目录（如 `C:\Redis`）
2. 打开命令提示符，导航到Redis目录：
```cmd
cd C:\Redis
redis-server.exe redis.windows.conf
```

3. 保持命令窗口运行状态

#### 3.2 macOS环境

```bash
# 使用Homebrew安装
brew install redis

# 启动Redis服务
brew services start redis

# 或临时启动
redis-server
```

#### 3.3 Linux环境

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server

# CentOS/RHEL
sudo yum install redis
sudo systemctl start redis
```

#### 3.4 验证Redis运行

```bash
# 测试Redis连接
redis-cli ping
# 应该返回: PONG
```

### 步骤4: 应用配置

#### 4.1 配置文件位置

编辑 `src/main/resources/application.yaml` 文件：

#### 4.2 数据库配置

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/pq?useSSL=false&serverTimezone=UTC
    username: root
    password: 你的MySQL密码  # 修改为实际密码
```

#### 4.3 Redis配置

```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password: 12345678  # 如使用提供的Redis配置，保持不变；否则修改为实际密码
    lettuce:
      pool:
        max-active: 10
        max-idle: 10
        min-idle: 1
        time-between-eviction-runs: 10s
```

#### 4.4 豆包AI配置（可选）

```yaml
doubao:
  api:
    key: 你的豆包API密钥  # 如需使用AI功能，请配置有效的API密钥
    url: https://ark.cn-beijing.volces.com/api/v3/chat/completions
  model: doubao-seed-1-6-250615
```

### 步骤5: 启动应用

#### 5.1 运行启动类

1. 在项目结构中找到 `src/main/java/com/pq/SpringbootApplication.java`
2. 右键点击文件，选择 `Run 'SpringbootApplication'`
3. 或者点击类文件中的绿色 ▶️ 运行按钮

#### 5.2 观察启动日志

正常启动时应看到类似日志：

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.3.12.RELEASE)

2024-01-XX XX:XX:XX.XXX  INFO 12345 --- [           main] com.pq.SpringbootApplication             : Starting SpringbootApplication
...
2024-01-XX XX:XX:XX.XXX  INFO 12345 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http)
2024-01-XX XX:XX:XX.XXX  INFO 12345 --- [           main] com.pq.SpringbootApplication             : Started SpringbootApplication in X.XXX seconds
```

## ✅ 验证部署

### 1. 健康检查

访问以下URL验证服务状态：

```bash
# 基础连通性测试
curl http://localhost:8080

# 如果有健康检查端点
curl http://localhost:8080/actuator/health
```

### 2. 数据库连接验证

检查应用日志中是否有数据库连接成功的信息，无异常错误。

### 3. Redis连接验证

检查应用日志中Redis连接状态，确保无连接错误。

### 4. 功能测试

```bash
# 测试用户登录接口
curl -X POST http://localhost:8080/user/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'
```

## 🔧 配置说明

### 完整配置文件示例

```yaml
server:
  port: 8080

spring:
  application:
    name: pq
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/pq?useSSL=false&serverTimezone=UTC
    username: root
    password: 你的密码
  redis:
    host: localhost
    port: 6379
    password: 12345678
    lettuce:
      pool:
        max-active: 10
        max-idle: 10
        min-idle: 1
        time-between-eviction-runs: 10s
  jackson:
    default-property-inclusion: non_null

mybatis-plus:
  type-aliases-package: com.pq.entity
  configuration:
    map-underscore-to-camel-case: false

logging:
  level:
    com.pq: debug

doubao:
  api:
    key: 你的API密钥
    url: https://ark.cn-beijing.volces.com/api/v3/chat/completions
  model: doubao-seed-1-6-250615
```

### 环境变量配置（推荐）

为了安全性，建议使用环境变量：

```yaml
spring:
  datasource:
    password: ${DB_PASSWORD:defaultPassword}
  redis:
    password: ${REDIS_PASSWORD:12345678}

doubao:
  api:
    key: ${DOUBAO_API_KEY:}
```

## ❗ 常见问题

### 问题1: Maven依赖下载失败

**症状**: 项目导入后依赖无法下载或下载缓慢

**解决方案**:
```xml
<!-- 在pom.xml中添加国内镜像 -->
<repositories>
    <repository>
        <id>aliyun</id>
        <url>https://maven.aliyun.com/repository/public</url>
    </repository>
</repositories>
```

### 问题2: 数据库连接失败

**症状**: 
```
java.sql.SQLException: Access denied for user 'root'@'localhost'
```

**解决方案**:
1. 检查MySQL服务是否启动
2. 验证用户名密码是否正确
3. 确认数据库 `pq` 是否存在
4. 检查MySQL用户权限

### 问题3: Redis连接失败

**症状**:
```
io.lettuce.core.RedisConnectionException: Unable to connect to localhost:6379
```

**解决方案**:
1. 确认Redis服务是否启动
2. 检查端口6379是否被占用
3. 验证Redis密码配置
4. 检查防火墙设置

### 问题4: 端口占用

**症状**:
```
Port 8080 was already in use
```

**解决方案**:
```yaml
# 修改application.yaml中的端口
server:
  port: 8081  # 或其他可用端口
```

### 问题5: JDK版本不兼容

**症状**: 编译错误或启动失败

**解决方案**:
1. 确认JDK版本为8或更高
2. 检查IDEA项目设置中的JDK配置
3. 验证环境变量 `JAVA_HOME` 设置

## 🚀 性能优化

### JVM参数优化

在IDEA运行配置中添加VM选项：

```
-Xms512m -Xmx1024m -XX:+UseG1GC -XX:MaxGCPauseMillis=200
```

### 数据库连接池优化

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

### Redis连接池优化

```yaml
spring:
  redis:
    lettuce:
      pool:
        max-active: 20
        max-idle: 10
        min-idle: 5
        max-wait: 3000ms
```

## 📞 技术支持

如果在部署过程中遇到问题，请：

1. 检查日志文件中的错误信息
2. 参考本文档的常见问题部分
3. 确认所有依赖服务正常运行
4. 验证配置文件格式和内容正确性

---

**部署完成后，后端服务将在 `http://localhost:8080` 上运行** 🎉