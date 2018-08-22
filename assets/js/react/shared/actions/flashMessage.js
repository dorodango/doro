export const ADD_FLASH_MESSAGE = "flashMessage/ADD"
export const REMOVE_FLASH_MESSAGE = "flashMessage/REMOVE"

export const addFlashMessage = data => ({ type: ADD_FLASH_MESSAGE, data })
export const removeFlashMessage = data => ({ type: REMOVE_FLASH_MESSAGE, data })
