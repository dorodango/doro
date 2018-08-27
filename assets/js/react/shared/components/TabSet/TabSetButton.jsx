import React, { Component } from "react"
import PropTypes from "prop-types"
import classnames from "classnames"

import { tabType } from "../tab"

export class TabSetButton extends Component {
  handleClick = () => {
    const { onClick, tab } = this.props

    onClick(tab.name)
  }

  render() {
    const { isActive, tab } = this.props

    const className = classnames("tab-set__button", {
      "tab-set__button--active": isActive
    })

    return tab.component ? (
      <button onClick={this.handleClick} className={className}>
        <TabSetButtonContent tab={tab} isActive={isActive} />
      </button>
    ) : (
      <a href={tab.link} className={className}>
        <TabSetButtonContent tab={tab} />
      </a>
    )
  }
}

TabSetButton.propTypes = {
  isActive: PropTypes.bool,
  onClick: PropTypes.func.isRequired,
  tab: tabType.isRequired
}

const TabSetButtonContent = ({ tab, isActive }) => {
  const className = classnames("tab-set__button-content", {
    "tab-set__button-content--active": isActive
  })
  return <div className={className}>{tab.name}</div>
}

TabSetButtonContent.propTypes = {
  tab: tabType,
  isActive: PropTypes.bool
}

export default TabSetButton
