import axios from 'axios'

const service = axios.create({
  baseURL: '/api',  // 使用代理路径
  timeout: 5000
})
//定制请求的实例



export default service