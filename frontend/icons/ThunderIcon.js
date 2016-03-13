import React from "react"
import {baseColors} from "styles"

export default function ThunderIcon({width, height, fillColor}) {
  return (
    <svg version="1.1" xmlns="http://www.w3.org/svg/2000" x="0px" y="0px"
      width={`${width}px`} height={`${height}px`} viewBox="0 0 12 12" fill={fillColor || baseColors.darkPrimaryColor}>
      <g>
        <polygon points="10,5 6.551,5 9,0 4.714,0 2,7 4.429,7 3,12"/>
      </g>
    </svg>
  )
}
