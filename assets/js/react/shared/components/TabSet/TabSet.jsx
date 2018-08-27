import React, { Component } from "react"
import PropTypes from "prop-types"
import classnames from "classnames"

import TabSetButtonList from "./TabSetButtonList"
import { tabSetType, activeTab, activeTabInfo } from "../tab"

class TabSet extends Component {
  constructor(props) {
    super(props)

    const { tabs } = this.props

    this.state = {
      active: tabs[0].name
    }
  }

  handleButtonClick = tabName => this.setState({ active: tabName })

  render() {
    const { className, tabs, buttonListClassName } = this.props
    const { active } = this.state
    const theActiveTab = activeTab(active, tabs)
    const theActiveTabInfo = activeTabInfo(active, tabs)
    return (
      <div className={classnames("tab-set", className)}>
        <TabSetButtonList
          tabs={tabs}
          active={active}
          onButtonClick={this.handleButtonClick}
          className={buttonListClassName}
        />
        <div
          className={`tab-set__content ${theActiveTabInfo.tabSetContentClass ||
            ""}`}
        >
          {theActiveTab}
        </div>
      </div>
    )
  }
}

TabSet.propTypes = {
  className: PropTypes.string,
  tabs: tabSetType.isRequired,
  buttonListClassName: PropTypes.string
}

export default TabSet
