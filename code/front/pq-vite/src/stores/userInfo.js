import {defineStore} from 'pinia'
import {ref} from 'vue'
 export const useUserInfoStore = defineStore('userInfo',()=>{
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

//export default useUserInfoStore;