import PropTypes from "prop-types"
import { curry, find, prop, propOr, equals, pipe } from "ramda"

export const tabType = PropTypes.shape({
  name: PropTypes.string.isRequired,
  component: PropTypes.component,
  link: PropTypes.string,
  tabSetContentClass: PropTypes.string, // for extra classes on tab-set__content wrapper
})

export const tabSetType = PropTypes.arrayOf(tabType)

export const activeTab = (activeName, tabs) =>
  pipe(
    find(isTabActive(activeName)),
    propOr(null, "component")
  )(tabs)

export const isTabActive = curry((active, tab) =>
  pipe(
    prop("name"),
    equals(active)
  )(tab)
)

export const activeTabInfo = (activeName, tabs) =>
  find(isTabActive(activeName))(tabs)
