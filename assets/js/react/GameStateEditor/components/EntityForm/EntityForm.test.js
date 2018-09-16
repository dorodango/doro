import React from "react"
import ReactDOM from "react-dom"
import { shallow, mount } from "enzyme"
import { EntityForm } from "./EntityForm"

describe("EntityForm", () => {
  let wrapper
  let extraProps
  let requiredProps = {
    fetchAvailableBehaviors: jest.fn(),
    addEntity: jest.fn()
  }

  beforeEach(() => {
    requiredProps.fetchAvailableBehaviors.mockReset()
    requiredProps.addEntity.mockReset()
  })
  describe("with the minimum props", () => {
    beforeEach(() => {
      wrapper = shallow(<EntityForm {...requiredProps} />)
    })

    it("renders without crashing", () => {
      expect(wrapper).toBeTruthy()
      expect(wrapper.find("Spinner")).toHaveLength(1)
    })
    it("triggers the fetch behaviors action", () => {
      expect(requiredProps.fetchAvailableBehaviors).toHaveBeenCalled()
    })
  })

  describe("when behaviors have been fetched", () => {
    beforeEach(() => {
      extraProps = {
        availableBehaviors: ["exit", "god", "visible"],
        behaviorShapes: {
          exit: { destinationId: null },
          god: {},
          visible: { description: "" }
        }
      }
      wrapper = mount(<EntityForm {...requiredProps} {...extraProps} />)
    })

    it("renders an empty form", () => {
      expect(wrapper).toBeTruthy()
      expect(wrapper.find("Spinner")).toHaveLength(0)
      expect(wrapper.find("_EntityForm")).toHaveLength(1)
      expect(wrapper.find(".form-row")).toHaveLength(5)
    })

    it("renders an visible by default form", () => {
      expect(wrapper.find(".EntityForm").text()).toContain("Behavior: visible")
      expect(wrapper.find(".EntityForm").text()).toContain(
        "visible: description"
      )
    })

    it("does not the fetch behaviors action", () => {
      expect(requiredProps.fetchAvailableBehaviors).not.toHaveBeenCalled()
    })
  })

  describe("when we start with behaviors and an entity (edit mode)", () => {
    beforeEach(() => {
      extraProps = {
        availableBehaviors: ["exit", "god", "visible"],
        behaviorShapes: {
          exit: { destinationId: null },
          god: {},
          visible: { description: "" }
        },
        entity: {
          id: "whatever",
          name: "what ever",
          props: { location: "start" },
          behaviors: {
            visible: {
              description: "is a shiny blob"
            },
            portable: {}
          }
        }
      }
      wrapper = mount(<EntityForm {...requiredProps} {...extraProps} />)
    })

    it("does not the fetch behaviors action", () => {
      expect(requiredProps.fetchAvailableBehaviors).not.toHaveBeenCalled()
    })

    it("renders all behaviors and associated form fields", () => {
      const formAsText = wrapper.find(".EntityForm").text()
      expect(wrapper.find("input[name='name']").props().value).toEqual(
        "what ever"
      )
      expect(wrapper.find("input[name='id']").props().value).toEqual("whatever")
      expect(
        wrapper.find("input[name='behaviors.visible.description']").props()
          .value
      ).toEqual("is a shiny blob")
      expect(formAsText).toContain("Behavior: visible")
      expect(formAsText).toContain("visible: description")
      expect(formAsText).toContain("Behavior: portable")
      expect(formAsText).toContain("No editable properties")
    })

    it("clicking on clear clears the entity", () => {
      wrapper.find(".EntityForm__clear-entity").simulate("click")

      const formAsText = wrapper.find(".EntityForm").text()
      expect(wrapper.find("input[name='name']").props().value).toEqual("")
      expect(wrapper.find("input[name='id']").props().value).toEqual("")
      expect(
        wrapper.find("input[name='behaviors.visible.description']").props()
          .value
      ).toEqual("")
      expect(formAsText).toContain("Behavior: visible")
      expect(formAsText).toContain("visible: description")
      expect(formAsText).not.toContain("Behavior: portable")
    })

    it("clicking on add submits the entity", () => {
      wrapper.find(".EntityForm__submit-entity").simulate("click")

      expect(requiredProps.addEntity).toHaveBeenCalledWith({
        id: "whatever",
        name: "what ever",
        props: {
          location: "start"
        },
        behaviors: {
          visible: {
            description: "is a shiny blob"
          },
          portable: {}
        }
      })
    })
  })
})
