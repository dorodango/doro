import axios from "axios"

const JSON_HEADERS = {
  "X-Requested-With": "XMLHttpRequest",
  "Content-Type": "application/json"
}

function request(url, method, data = {}) {
  return axios({
    method,
    url,
    headers: { ...JSON_HEADERS, "X-CSRF-Token": "none" },
    data
  })
}

export const get = url => request(url, "get")
export const post = (url, data) => request(url, "post", data)
export const put = (url, data) => request(url, "put", data)
export const patch = (url, data) => request(url, "patch", data)
export const destroy = (url, data) => request(url, "delete", data)
