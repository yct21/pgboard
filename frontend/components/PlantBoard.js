import React from "react"
import Paper from "material-ui/lib/paper"
import Divider from "material-ui/lib/divider"
import PaperHead from "components/PaperHead"
import PlantItem from "components/PlantItem"
import {baseColors} from "styles"
import _ from "lodash"

// styles

const plantBoardStyle = {
  wrapStyle: {
    margin: "0 10%",
    paddingBottom: "1px"
  },

  plantMarket: {
    wrapStyle: {
      margin: "20px 2%",
      textAlign: "center"
    },

    dummyImgStyle: {
      width: "100%",
      height: "360px"
    },

    titleDivStyle: {
      height: "32px",
      padding: "13px 0 0 19px",
      fontWeight: "bold",
      color: baseColors.darkPrimaryColor
    },

    marketStyle: {
      display: "inline-block",
      width: "288px",
      verticalAlign: "top",
      margin: "10px 21px 10px 0px"
    }
  }
}

// renderers

export default function PlantBoard({plantsInMarket, gameStep}) {
  const paperHeadProps = {
    title: "Plant Market"
  }

  return (
    <Paper rounded={false} style={plantBoardStyle.wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      {plantMarket(plantsInMarket, gameStep)}
    </Paper>
  )
}

function plantMarket(plantsInMarket, gameStep) {
  const availablePlantsAmount = 4
  const wrapDivProps = {
    rounded: false,
    style: plantBoardStyle.plantMarket.wrapStyle
  }

  let availablePlants = null
  let futurePlants = null
  if (gameStep === 1 || gameStep === 2) {
    [availablePlants, futurePlants] = _.chunk(plantsInMarket.sort(), availablePlantsAmount)
  } else {
    availablePlants = plantsInMarket.sort()
  }

  return (
    <div {...wrapDivProps}>
      {availableMarket(availablePlants)}
      {futureMarket(futurePlants)}
    </div>
  )
}

function availableMarket(availablePlants) {
  return (
    <Paper style={plantBoardStyle.plantMarket.marketStyle} >
      {marketTitle("Available")}
      {plantList(availablePlants)}
    </Paper>
  )
}

function futureMarket(futurePlants) {
  if (futurePlants) {
    return (
      <Paper style={plantBoardStyle.plantMarket.marketStyle} >
        {marketTitle("Future")}
        {plantList(futurePlants)}
      </Paper>
    )
  } else {
    return (
      <Paper style={plantBoardStyle.plantMarket.marketStyle} >
        {marketTitle("Future")}
        <Divider />
        <img src="/images/cat.png" style={plantBoardStyle.plantMarket.dummyImgStyle}/>
      </Paper>
    )
  }
}

function plantList(plants) {
  return plants.map((plantId) =>
    <div key={plantId}>
      <Divider />
      <PlantItem plantId={plantId} />
    </div>
  )
}

function marketTitle(title) {
  return (
    <div style={plantBoardStyle.plantMarket.titleDivStyle}>
      {title}
    </div>
  )
}
