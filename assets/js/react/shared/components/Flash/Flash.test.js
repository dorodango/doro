import React from "react"
import ReactDOM from "react-dom"
import { shallow } from "enzyme"
import { Flash } from "./Flash"

describe("Flash", () => {
  let wrapper

  let props = {
    type: "the-type",
    text: "the message",
    removeFlashMessage: jest.fn()
  }

  beforeEach(() => {
    props.removeFlashMessage.mockReset()
    wrapper = shallow(<Flash {...props} />)
  })

  it("renders a flash", () => {
    expect(wrapper.find(".Flash.Flash--the-type")).toHaveLength(1)
    expect(wrapper.find(".Flash__message").text()).toContain("the message")
    expect(wrapper.find(".Flash__close-button")).toHaveLength(1)
  })

})
