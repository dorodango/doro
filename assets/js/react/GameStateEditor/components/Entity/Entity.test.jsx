import React from "react"
import ReactDOM from "react-dom"
import { shallow, mount } from "enzyme"
import Entity from "./Entity"

describe("Entity", () => {
  let wrapper
  let extraProps
  const handleEditSpy = jest.fn()
  const handleDeleteSpy = jest.fn()
  let requiredProps = {
    handleEdit: handleEditSpy,
    handleDelete: handleDeleteSpy,
    entity: {
      id: "thing",
      name: "name"
    }
  }

  beforeEach(() => {
    handleEditSpy.mockReset()
    handleDeleteSpy.mockReset()
    wrapper = shallow(<Entity {...requiredProps} />)
  })

  it("calls handleDelete when you click the delete button", () => {
    wrapper.find(".Entity__delete").simulate("click")
    expect(requiredProps.handleDelete).toHaveBeenCalled()
  })

  it("calls handleEdit when you click the edit button", () => {
    wrapper.find(".Entity__edit.button").simulate("click")
    expect(requiredProps.handleEdit).toHaveBeenCalled()
  })

  describe("if the entity.src is populated", () => {
    beforeEach(() => {
      requiredProps = {
        handleEdit: handleEditSpy,
        handleDelete: handleDeleteSpy,
        entity: {
          id: "thing",
          name: "name",
          src: "priv_file://world.json"
        }
      }
      wrapper = shallow(<Entity {...requiredProps} />)
    })

    it("does not show a delete button", () => {
      expect(wrapper.find(".Entity__delete.button")).toHaveLength(0)
    })
  })
})
