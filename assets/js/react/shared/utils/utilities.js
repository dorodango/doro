import { isEmpty as _isEmpty, isString as _isString } from "lodash"

export const isEmpty = _isEmpty
export const isBlank = value => {
  let result = _isEmpty(value)

  if (_isString(value)) {
    result = result && _isEmpty(result.trim())
  }

  return Boolean(result)
}
