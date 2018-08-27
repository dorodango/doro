/** Identify and Expose API endpoints available for React/Redux/Sagas */
import { get, put } from "./services/api"

const api = {
  behaviors: {
    index: () => get("/api/behaviors")
  },
  entities: {
    index: () => get("/api/entities"),
    create: data => put("/api/entities", data)
  }
}

export default api
