// 用于存储和管理token的简单模块

// 定义token的key，便于统一管理
const TOKEN_KEY = 'token'

// 设置token到localStorage
export function setToken(token) {
  localStorage.setItem(TOKEN_KEY, token)
}

// 从localStorage获取token
export function getToken() {
  return localStorage.getItem(TOKEN_KEY)
}

// 清除token
export function removeToken() {
  localStorage.removeItem(TOKEN_KEY)
}
