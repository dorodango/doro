import React from "react"
import ReactDOM from "react-dom"
import moxios from "moxios"
import { shallow } from "enzyme"
import { GameStateEditor } from "./GameStateEditor"

describe("GameStateEditor", () => {
  let fetchEntitiesSpy = jest.fn()
  let downloadEntitiesSpy = jest.fn()
  let wrapper

  beforeEach(() => {
    fetchEntitiesSpy.mockReset()
    downloadEntitiesSpy.mockReset()
  })

  describe("with no data", () => {
    beforeEach(() => {
      const props = {
        fetchEntities: fetchEntitiesSpy,
        downloadEntities: downloadEntitiesSpy
      }
      wrapper = shallow(<GameStateEditor {...props} />)
    })
    it("renders without crashing", () => {
      expect(wrapper).toBeTruthy()
    })
    it("fetches entities", () => {
      expect(fetchEntitiesSpy).toHaveBeenCalled()
    })
  })

  describe("with some entities", () => {
    const entities = [
      { src: "priv_file://world.json", id: "one" },
      { src: "gist://aa44ff",  id: "two" },
      { id: "three" },
      { src: "", id: "four" }
    ]

    beforeEach(() => {
      const props = {
        entities: entities,
        fetchEntities: fetchEntitiesSpy,
        downloadEntities: downloadEntitiesSpy
      }
      wrapper = shallow(<GameStateEditor {...props} />)
    })
    it("does not fetch entities if they are provided", () => {
      expect(fetchEntitiesSpy).not.toHaveBeenCalled()
    })
    it("download all calls download with all entities", () => {
      wrapper.find('.GameStateEditor__download--all').simulate('click')
      expect(downloadEntitiesSpy).toHaveBeenCalled()
      expect(downloadEntitiesSpy.mock.calls[0]).toEqual([
        expect.objectContaining(
          { entities: entities }
        )
      ])
    })
    it("download new entities calls download with only entities that have not src", () => {
      wrapper.find('.GameStateEditor__download--new').simulate('click')
      expect(downloadEntitiesSpy).toHaveBeenCalled()
      expect(downloadEntitiesSpy.mock.calls[0]).toEqual([
        expect.objectContaining(
          { entities: entities.slice(2,4) }
        )
      ])
    })
  })

})
