import axios from 'axios'
import { getToken } from '../stores/token' // 导入获取token的方法

const service = axios.create({
  baseURL: '/api',  // 使用代理路径
  timeout: 5000
})
//定制请求的实例

// 添加请求拦截器，在每次请求前自动携带token
service.interceptors.request.use(
  config => {
    // 从本地存储获取token
    const token = getToken()
    // 如果存在token，则添加到请求头
    if (token) {
      config.headers['Authorization'] = `${token}`
    }
    return config
  },
  error => {
    // 请求错误时直接返回错误
    return Promise.reject(error)
  }
)


export default service