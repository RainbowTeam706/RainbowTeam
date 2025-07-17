import { defineStore } from 'pinia'
import {ref} from 'vue'
export const useUserInfoStore = defineStore('user', {
  state: () => ({
    id: 0,
    username: '测试名',
    nickname: '孙悟空'
  }),
  actions: {
    setUserInfo({ id, username, nickname}) {
      this.id = id
      this.username = username
      this.nickname = nickname
    },
    clearUserInfo() {
      this.id = null
      this.username = ''
      this.nickname = ''
    }
  }
})


 export const useInfoStore = defineStore('Info',()=>{
    //定义状态相关的内容

    const info = ref({})
    const pro = ref({})

    const setInfo = (newInfo)=>{
        info.value = newInfo
    }
    const setPro = (newPro)=>{
        pro.value = newPro
    }


    const removeInfo = ()=>{
        info.value = {}
    }

    return {info,setInfo,removeInfo,pro,setPro}

},{persist:true})

