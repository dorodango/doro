import React, { Component } from "react"
import PropTypes from "proptypes"
import { addIndex, forEach, map } from "ramda"

const mapIndexed = addIndex(map)
const eachWithIndex = addIndex(forEach)

const MessageItem = props => {
  const parts = props.message.split("\n")
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
MessageItem.propTypes = { message: PropTypes.string.isRequired }

class DoroOutput extends Component {
  static propTypes = {
    channel: PropTypes.object.isRequired,
    player: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = { messages: [] }
    props.channel.on("output", payload => {
      this.handleMessage(payload.body)
    })
  }

  handleMessage(message) {
    this.setState({ messages: this.state.messages.concat(message) })
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
          (msg, index) => <MessageItem key={index} message={msg} />,
          this.state.messages
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

export default DoroOutput
