import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import { addIndex, forEach, map } from "ramda"

const mapIndexed = addIndex(map)
const eachWithIndex = addIndex(forEach)

const MessageItem = props => {
  const { message } = props
  const parts = message.split("\n")
  let items = []
  if (parts.length > 1) {
    items.push(
      <span key="prefix" className="DoroOutput__item-prefix">
        {parts[0]}
      </span>
    )
    eachWithIndex(
      (part, index) =>
        items.push(
          <span key={index} className="DoroOutput__item-content">
            {part}
          </span>
        ),
      parts.slice(1)
    )
  } else {
    items.push(
      <span key="fullmessage" className="DoroOutput__item-content">
        {parts[0]}
      </span>
    )
  }
  return <div className="DoroOutput__item">{items}</div>
}

MessageItem.propTypes = {
  message: PropTypes.string.isRequired
}

class DoroOutput extends Component {
  static propTypes = {
    userSession: PropTypes.object.isRequired,
  }

  static defaultProps = {
    userSession: {
      messages: []
    }
  }

  constructor(props) {
    super(props)
  }

  scrollToBottom() {
    this.messagesEnd.scrollIntoView({ behavior: "smooth" })
  }

  componentDidMount() {
    this.scrollToBottom()
  }

  componentDidUpdate() {
    this.scrollToBottom()
  }

  render() {
    return (
      <div className="DoroOutput">
        {mapIndexed(
           (msg, index) => (
             <MessageItem key={index} message={msg} />
           ),
           this.props.userSession.messages
        )}
        <div
          style={{ float: "left", clear: "both" }}
          className="DoroOutput__push-footer"
          ref={el => {
              this.messagesEnd = el
          }}
        />
      </div>
    )
  }
}

const mapStateToProps = state => ({
  userSession: state.userSession
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(DoroOutput)

export { DoroOutput }
export default connectedComponent;
