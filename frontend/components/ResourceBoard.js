import React from "react"
import Paper from "material-ui/lib/paper"
import Divider from "material-ui/lib/divider"
import PaperHead from "components/PaperHead"
import CoalIcon from "icons/CoalIcon"
import OilIcon from "icons/OilIcon"
import UraniumIcon from "icons/UraniumIcon"
import GarbageIcon from "icons/GarbageIcon"
import {baseColors} from "styles"
import _ from "lodash"

// styles
const resourceBoardStyle = {
  wrapStyle: {
    margin: "0 10%",
    paddingBottom: "1px"
  },

  resourceMarket: {
    wrapStyle: {
      margin: "20px 2%",
      textAlign: "right"
    },

    resourceGrids: {
      priceStyle: {
        position: "absolute",
        color: baseColors.darkPrimaryColor,
        top: "3px",
        left: "3px"
      },

      gridStyle: {
        display: "inline-block",
        width: "12.5%",
        marginRight: "-1px",
        position: "relative",
        padding: "11px 0px 11px 0",
        borderRight: "1px solid #e0e0e0"
      },

      uraniumStyle: {
        display: "inline-block",
        width: "8.333%",
        marginRight: "-1px",
        position: "relative",
        padding: "5px 0px 5px 0",
        borderRight: "1px solid #e0e0e0"
      }
    }
  }
}

// renderers

export default function ResourceBoard({resources}) {
  const paperHeadProps = {
    title: "Resource Market"
  }

  return (
    <Paper rounded={false} style={resourceBoardStyle.wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      {resourceMarket(resources)}
    </Paper>
  )
}

function resourceMarket(resources) {
  const wrapPaperProps = {
    rounded: false,
    style: resourceBoardStyle.resourceMarket.wrapStyle
  }

  return (
    <Paper {...wrapPaperProps}>
      {commonResources(CoalIcon, resources["coal"])}
      <Divider />
      {commonResources(OilIcon, resources["oil"])}
      <Divider />
      {commonResources(GarbageIcon, resources["garbage"])}
      <Divider />
      {uraniumResource(resources["uranium"])}
    </Paper>
  )
}

function commonResources(resourceIcon, resourceNum) {
  const resourceGrids = _.range(1, 9).map((price) => {
    const resourceGrid = _.range(3).map((resourceIndexInGrid) => {
      const resourceIndex = (price - 1) * 3 + resourceIndexInGrid
      const iconColor =
        (23 - resourceIndex) < resourceNum ?
        baseColors.darkPrimaryColor :
        baseColors.unavalableIconColor

      const resourceIconProps = {
        width: 30,
        height: 30,
        key: resourceIndex,
        fillColor: iconColor
      }

      return React.createElement(resourceIcon, resourceIconProps)
    })

    const wrapDivProps = {
      key: price,
      style: resourceBoardStyle.resourceMarket.resourceGrids.gridStyle
    }

    return (
      <div {...wrapDivProps}>
        <span style={resourceBoardStyle.resourceMarket.resourceGrids.priceStyle}>
          ${price}
        </span>
        {resourceGrid}
      </div>
    )
  })

  return (
    <div>
      {resourceGrids}
    </div>
  )
}

function uraniumResource(resourceNum) {
  const prices = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16]

  const resourceGrids = prices.map((price, index) => {
    const iconColor =
      (11 - index) < resourceNum ?
      baseColors.darkPrimaryColor :
      baseColors.unavalableIconColor

    console.log(`${index} ${(11 - index)} ${resourceNum}`)

    const resourceIconProps = {
      width: 30,
      height: 30,
      key: index,
      fillColor: iconColor
    }

    const wrapDivProps = {
      key: price,
      style: resourceBoardStyle.resourceMarket.resourceGrids.uraniumStyle
    }

    return (
      <div {...wrapDivProps}>
        <span style={resourceBoardStyle.resourceMarket.resourceGrids.priceStyle}>
          ${price}
        </span>
        <UraniumIcon {...resourceIconProps} />
      </div>
    )
  })


  return (
    <div>
      {resourceGrids}
    </div>
  )
}
