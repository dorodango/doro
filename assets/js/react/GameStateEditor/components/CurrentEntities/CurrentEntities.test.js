import React from "react"
import ReactDOM from "react-dom"
import { shallow, mount } from "enzyme"
import { CurrentEntities } from "./CurrentEntities"

describe("CurrentEntities", () => {
  let wrapper
  let extraProps
  let requiredProps = {
    fetchEntities: jest.fn()
  }

  beforeEach(() => {
    requiredProps.fetchEntities.mockReset()
  })

  describe("with no entities", () => {
    it("fetches entities", () => {
      wrapper = shallow(<CurrentEntities {...requiredProps} />)
      expect(requiredProps.fetchEntities).toHaveBeenCalled()
    })
  })

  describe("with entities", () => {
    let extraProps = {
      entities: [
        { id: "ma", name: "man", name_tokens: ["m","a","n","spells", "man"] },
        { id: "ya", name: "yan", name_tokens: ["y","a","n","spells", "yan"] }
      ]
    }
    beforeEach(() => {
      wrapper = mount(<CurrentEntities {...requiredProps} {...extraProps} />)
    })
    it("fetches entities", () => {
      expect(requiredProps.fetchEntities).not.toHaveBeenCalled()
    })
    it("renders each entity", () => {
      expect(wrapper.find('Entity')).toHaveLength(2)
    })
    it("allows search by name, id and highlights (with *) the matching term", () => {
      const searchInput = wrapper.find('.CurrentEntities__search-input')
      expect(wrapper.find('Entity')).toHaveLength(2)
      searchInput.simulate('change', { target: { value: "ma" } } )
      expect(wrapper.find('Entity')).toHaveLength(1)
      expect(wrapper.text()).toContain("Matches: 1")
      expect(wrapper.text()).toContain("\"*ma*n\"")
      expect(wrapper.text()).toContain("\"*ma*\"")
    });
  })
})
