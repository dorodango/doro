/** Identify and Expose API endpoints available for React/Redux/Sagas */
import { get, put, destroy as del } from "./services/api"

const api = {
  behaviors: {
    index: () => get("/api/behaviors")
  },
  entities: {
    index: () => get("/api/entities"),
    create: data => put("/api/entities", data),
    destroy: id => () => del(`/api/entities/${id}`)
  }
}

export default api
