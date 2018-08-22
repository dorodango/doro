import React from "react"
import { shallow } from "enzyme"
import TabSetButton from "./TabSetButton"

const componentTab = { name: "First", component: <div className="first" /> }
const linkTab = { name: "Link", link: "https://example.com/valuation" }

const requiredProps = {
  tab: componentTab,
  onClick: () => {},
}

describe("TabSet", () => {
  let wrapper
  let props

  describe("with tabs", () => {
    beforeEach(() => {
      props = { ...requiredProps }
      wrapper = shallow(<TabSetButton {...props} />)
    })

    it("renders the component", () => {
      expect(wrapper.find(".tab-set__button")).toHaveLength(1)
    })

    describe("given a component tab", () => {
      it("renders a button", () => {
        expect(wrapper.find("button")).toHaveLength(1)
        expect(wrapper.find("a")).toHaveLength(0)
      })
    })

    describe("given a link tab", () => {
      beforeEach(() => {
        wrapper = shallow(<TabSetButton {...props} tab={linkTab} />)
      })

      it("renders a link", () => {
        expect(wrapper.find("button")).toHaveLength(0)
        expect(wrapper.find("a")).toHaveLength(1)
      })
    })
  })
})
