import React, { Component } from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import classnames from "classnames"

import TabSetButtonList from "./TabSetButtonList"
import { tabSetType, activeTab, activeTabInfo } from "../tab"
import { activateTab } from "../../actions/tabs.js"

class TabSet extends Component {

  static propTypes = {
    className: PropTypes.string,
    tabs: tabSetType.isRequired,
    activeTab: PropTypes.string,
    buttonListClassName: PropTypes.string,
    activateTab: PropTypes.func.isRequired
  }

  static defaultProps = {
    activeTab: ""
  }

  constructor(props) {
    super(props)

    const { tabs } = this.props
  }

  handleButtonClick = tabName => this.props.activateTab(tabName)

  render() {
    const { className, tabs, buttonListClassName } = this.props
    if (!tabs.length) {
      return "";
    }

    let active = this.props.activeTab;
    if (!active) {
      active = tabs[0].name;
    }
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

const mapStateToProps = state => ({
  activeTab: state.tabs.activeTab,
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      activateTab,
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(TabSet)

export { TabSet }
export default connectedComponent
