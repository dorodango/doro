import React from "react"
import { shallow } from "enzyme"
import TabSet from "./TabSet"

const tabs = [
  { name: "First", component: <div className="first" /> },
  { name: "Second", component: <div className="second" /> },
  { name: "Link", link: "https://example.com/somewhere" }
]

const requiredProps = { tabs }

describe("TabSet", () => {
  let wrapper
  let buttons
  let props

  describe("with tabs", () => {
    beforeEach(() => {
      props = { ...requiredProps }
      wrapper = shallow(<TabSet {...props} />)
      buttons = wrapper.find("TabSetButtonList")
    })

    it("renders the component", () => {
      expect(wrapper.find(".tab-set")).toHaveLength(1)
    })

    it("renders the first tab", () => {
      expect(wrapper.find(".first")).toHaveLength(1)
      expect(wrapper.find(".second")).toHaveLength(0)
    })

    describe("given a click on the second tab button", () => {
      beforeEach(() => {
        buttons.simulate("buttonClick", "Second")
      })

      it("renders the second tab", () => {
        expect(wrapper.find(".first")).toHaveLength(0)
        expect(wrapper.find(".second")).toHaveLength(1)
      })
    })

    describe("given a className", () => {
      beforeEach(() => {
        wrapper = shallow(<TabSet {...props} className="foo" />)
      })

      it("adds the className", () => {
        expect(wrapper.find(".tab-set.foo")).toHaveLength(1)
      })
    })
  })
})
