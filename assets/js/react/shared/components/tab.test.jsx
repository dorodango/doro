import React from "react"
import { activeTab, isTabActive } from "./tab"

const tabs = [
  { name: "Overview", component: <div className="overview" /> },
  { name: "Fundamentals", component: <div className="fundamentals" /> },
  { name: "Valuation", link: "https://example.com/valuation" }
]

describe("tab", () => {
  describe("activeTab", () => {
    it("finds the active tab component", () => {
      expect(activeTab("Fundamentals", tabs)).toEqual(tabs[1].component)
    })

    it("returns null for link tabs", () => {
      expect(activeTab("Valuation", tabs)).toEqual(null)
    })
  })

  describe("isTabActive", () => {
    it("finds the active tab component", () => {
      expect(isTabActive("Overview", tabs[0])).toBe(true)
    })

    it("returns null for link tabs", () => {
      expect(isTabActive("Valuation", tabs[1])).toBe(false)
    })
  })
})
