import { defineStore } from 'pinia'

export const useUserInfoStore = defineStore('user', {
  state: () => ({
    id: null,
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
  },
  persist: true
})




