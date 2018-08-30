import PropTypes from "prop-types"
import { find } from "lodash"

export const tabType = PropTypes.shape({
  name: PropTypes.string.isRequired,
  component: PropTypes.component,
  link: PropTypes.string,
  tabSetContentClass: PropTypes.string // for extra classes on tab-set__content wrapper
})

export const tabSetType = PropTypes.arrayOf(tabType)

export const isTabActive = (activeName, tab) => tab.name == activeName
export const activeTabInfo = (activeName, tabs) =>
  find(tabs, tab => isTabActive(activeName, tab))
export const activeTab = (activeName, tabs) =>
  activeTabInfo(activeName, tabs).component || null
