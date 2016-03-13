import React from "react"
import {baseColors} from "styles"

export default function FactoryIcon({width, height, fillColor}) {
  return (
    <svg version="1.1" xmlns="http://www.w3.org/svg/2000" x="0px" y="0px"
      width={`${width}px`} height={`${height}px`} viewBox="0 0 512 512" fill={fillColor || baseColors.darkPrimaryColor}>
      <g>
        <rect y="96" width="128" height="32"/>
        <rect width="128" height="64"/>
        <path d="M384,288v-96l-128,96v-96l-128,96V160H0v352h128h384V192L384,288z M224,416h-64v-32h64V416z M224,352h-64v-32h64V352z
          M352,416h-64v-32h64V416z M352,352h-64v-32h64V352z M480,416h-64v-32h64V416z M480,352h-64v-32h64V352z"/>
      </g>
    </svg>
  )
}
