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
import { map, omit } from "lodash"
import { isEmpty } from "../../shared/utils/utilities"

export const convertBehaviorsToArray = entity => {
  if (!entity.behaviors) {
    return entity
  }
  let behaviors = []
  if (!isEmpty(entity.behaviors)) {
    behaviors = map(entity.behaviors || {}, (behaviorProps, key) => ({
      type: key,
      ...behaviorProps,
    }))
  }
  return { ...entity, behaviors }
}

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
