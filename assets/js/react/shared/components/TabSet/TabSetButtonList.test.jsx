import React from "react"
import { shallow } from "enzyme"
import TabSetButtonList from "./TabSetButtonList"

const tabs = [
  { name: "First", component: <div className="first" /> },
  { name: "Second", component: <div className="second" /> },
  { name: "Link", link: "https://example.com/valuation" }
]

const requiredProps = {
  tabs,
  onButtonClick: () => {}
}

describe("TabSet", () => {
  let wrapper
  let props

  describe("with tabs", () => {
    beforeEach(() => {
      props = { ...requiredProps }
      wrapper = shallow(<TabSetButtonList {...props} />)
    })

    it("renders the component", () => {
      expect(wrapper.find(".tab-set__button-list")).toHaveLength(1)
    })

    it("has no active component", () => {
      expect(wrapper.find("[isActive=true]")).toHaveLength(0)
    })

    describe("given an active component", () => {
      beforeEach(() => {
        wrapper = shallow(<TabSetButtonList {...props} active="Second" />)
      })
      it("notes the active component", () => {
        const firstButton = wrapper.findWhere(node => node.key() === "First")
        const secondButton = wrapper.findWhere(node => node.key() === "Second")

        expect(secondButton.props().isActive).toBe(true)
        expect(firstButton.props().isActive).toBe(false)
      })
    })
  })
})
