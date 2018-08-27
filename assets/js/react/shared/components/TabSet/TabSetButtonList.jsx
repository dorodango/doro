import React from "react"
import PropTypes from "prop-types"
import cx from "classnames"

import TabSetButton from "./TabSetButton"
import { tabSetType, isTabActive } from "../tab"

const TabSetButtonList = ({ active, tabs, onButtonClick, className }) => (
  <div className={cx("tab-set__button-list", className)}>
    {tabs.map(tab => (
      <TabSetButton
        key={tab.name}
        tab={tab}
        isActive={isTabActive(active, tab)}
        onClick={onButtonClick}
      />
    ))}
  </div>
)

TabSetButtonList.propTypes = {
  active: PropTypes.string,
  onButtonClick: PropTypes.func.isRequired,
  tabs: tabSetType.isRequired,
  className: PropTypes.string
}

export default TabSetButtonList
