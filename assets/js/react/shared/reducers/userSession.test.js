import reducer, { defaultState } from "./userSession"
import { sendCommandSuccess, sendHelloSuccess } from "../actions/channel"

describe("Flash Message reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("SEND_HELLO_SUCCESS", () => {
    it("adds the message to the store", () => {
      const state = reducer(
        {},
        sendHelloSuccess({ player_id: "the-player-id", player_name: "My Name" })
      )
      expect(state).toEqual({
        playerId: "the-player-id",
        playerName: "My Name"
      })
    })
  })

  describe("SEND_COMMAND_SUCCESS", () => {
    it("appends messages to the existing list", () => {
      let state = reducer(
        defaultState,
        sendCommandSuccess({
          body: {
            text: "> look over here",
            data: {
              type: "default"
            }
          }
        })
      )
      expect(state).toEqual(
        expect.objectContaining({
          messages: ["> look over here"]
        })
      )

      state = reducer(
        state,
        sendCommandSuccess({
          body: {
            text: "you see nothing",
            data: {
              type: "default"
            }
          }
        })
      )
      expect(state).toEqual(
        expect.objectContaining({
          messages: ["> look over here", "you see nothing"]
        })
      )
    })
  })
})
