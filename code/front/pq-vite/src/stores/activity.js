import { defineStore } from 'pinia'
import { ref } from 'vue'
export const useActivityStore = defineStore('activity', () => {
  const activities = ref([])

  function setActivities(list) {
    activities.value = list
  }

  function getActivityById(id) {
    return activities.value.find(act => String(act.id) === String(id))
  }

  return { activities, setActivities, getActivityById }
}, {
  persist: true
})