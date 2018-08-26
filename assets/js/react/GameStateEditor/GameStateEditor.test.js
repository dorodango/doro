import React from "react"
import ReactDOM from "react-dom"
import moxios from "moxios"
import { shallow } from "enzyme"
import { GameStateEditor } from "./GameStateEditor"

describe("GameStateEditor", () => {
  let fetchEntitiesSpy = jest.fn()
  let wrapper

  beforeEach(() => {
    fetchEntitiesSpy.mockReset();
  })

  describe("with no data", () => {
    beforeEach(() => {
      wrapper = shallow(<GameStateEditor fetchEntities={fetchEntitiesSpy} />)
    })
    it("renders without crashing", () => {
      expect(wrapper).toBeTruthy()
    })
    it("fetches entities", () => {
      expect(fetchEntitiesSpy).toHaveBeenCalled()
    })

  })
})
