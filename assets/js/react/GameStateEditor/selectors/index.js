import { map, omit, get, includes } from "lodash"
import { flow, filter, map as mapFp } from "lodash/fp"
import { isEmpty } from "../../shared/utils/utilities"

const hasNoLocation = entity => get(entity, "props.location") == null
const isNotAPlayer = entity => !includes(entity.behaviors, "behaviors")
const isNotPrivate = entity => !/^_/.test(entity.id)

export const extractLocationsFromEntities = entities => {
  return flow(
    filter(hasNoLocation),
    filter(isNotAPlayer),
    filter(isNotPrivate),
    mapFp("id")
  )(entities)
}

/**
 * Converts entity behaviors from hash like
 * { id: "the-thing", name: "the thing",
 *   behaviors: { visible: { description: "is the thing's description" }
 * }
 * to
 * { id: "the-thing", name: "the thing",
 *   behaviors: [ { type: "visible", description: "is the thing's description" } ]
 * }
 * so it's ready to send to the API and be properly marshalled
 *
 * @param {*} entity
 */
export const convertBehaviorsToArray = entity => {
  if (!entity.behaviors) {
    return entity
  }
  let behaviors = []
  if (!isEmpty(entity.behaviors)) {
    behaviors = map(entity.behaviors || {}, (behaviorProps, key) => ({
      type: key,
      ...behaviorProps
    }))
  }
  return { ...entity, behaviors }
}

/**
 * Converts entity behaviors from array like
 * { id: "the-thing", name: "the thing",
 *   behaviors: [ { type: "visible", description: "is the thing's description" } ]
 * }
 * to a hash
 * { id: "the-thing", name: "the thing",
 *   behaviors: { visible: { description: "is the thing's description" }
 * }
 * so which we use to consume what we get from the API
 *
 * @param {*} entity
 */
export const convertBehaviorsToHash = entity => {
  if (!entity.behaviors) {
    return entity
  }
  let behaviors = {}
  if (!isEmpty(entity.behaviors)) {
    behaviors = entity.behaviors.reduce((memo, behaviorProps) => {
      if (!isEmpty(behaviorProps.type)) {
        memo[behaviorProps.type] = omit(behaviorProps, "type")
      }
      return memo
    }, {})
  }
  return { ...entity, behaviors }
}
