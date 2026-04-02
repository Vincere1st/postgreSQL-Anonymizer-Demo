import { ref } from 'vue'
import axios from 'axios'

export function useApi() {
  const baseUrl = 'http://localhost:3000'
  const loading = ref(false)
  const error = ref(null)
  const response = ref(null)

  const executeQuery = async (sql, method = 'POST', credentials = {}) => {
    loading.value = true
    error.value = null
    response.value = null

    try {
      const url = `${baseUrl}/query`
      const config = {
        method,
        headers: {
          'Content-Type': 'application/json'
        }
      }

      if (method === 'GET') {
        config.params = { sql, ...credentials }
      } else {
        config.data = { sql, ...credentials }
      }

      const axiosResponse = await axios(url, config)
      response.value = axiosResponse.data
      return axiosResponse.data
    } catch (err) {
      error.value = err.response?.data?.error || err.message || 'Unknown error'
      console.error('API Error:', error.value)
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    error,
    response,
    executeQuery
  }
}