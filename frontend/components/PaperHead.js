import React from "react"
import {baseColors} from "styles"

// styles
const wrapDivStyle = {
  margin: "12px 2% 0",
  paddingTop: "10px",
  borderBottom: "2px solid",
  borderBottomColor: baseColors.darkPrimaryColor
}

const leftIconStyle = {
  height: 30,
  width: 30,
  fill: baseColors.darkPrimaryColor
}

const titleStyle = {
  margin: "0 5px",
  display: "inline",
  color: baseColors.darkPrimaryColor
}

const rightSpanStyle = {
  float: "right",
  position: "relative",
  top: "-2px"
}

// renderers
export default function PaperHead({leftIcon, title, rightElement}) {
  const leftIconComponent = leftIcon ? <leftIcon style={leftIconStyle}/> : null
  const rightElementComponent = rightElement ? <span style={rightSpanStyle}> {rightElement} </span> : null

  return (
    <div style={wrapDivStyle}>
      {leftIconComponent}
      <h1 style={titleStyle}>{title}</h1>
      {rightElementComponent}
    </div>
  )
}
