// 引入封装的axios请求工具
import request from '../utils/request'

// 登录API函数，接收用户名和密码作为参数
export function login(username, password) {
  // 发送POST请求到后端登录接口，传递用户名和密码
  console.log(username,password)
  return request.post('/user/login', {
    username, // 用户名
    password  // 密码
  })
}

// 注册API函数，接收用户名和密码作为参数
export function register(username, password) {
  // 发送POST请求到后端注册接口，传递用户名和密码
  return request.post('/user/register', {
    username, // 用户名
    password  // 密码
  })
}

// 获取当前用户信息
export function getUserInfo() {
  return request.get('/user/me')
}
