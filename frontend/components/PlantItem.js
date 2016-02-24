import React from "react"
import plants from "game/plants"
import PlantIcon from "icons/PlantIcon"
import ThunderIcon from "icons/ThunderIcon"
import CoalIcon from "icons/CoalIcon"
import OilIcon from "icons/OilIcon"
import UraniumIcon from "icons/UraniumIcon"
import GarbageIcon from "icons/GarbageIcon"
import HybridIcon from "icons/HybridIcon"
import EcologicalIcon from "icons/EcologicalIcon"
import _ from "lodash"

// styles

const plantItemStyle = {
  wrapStyle: {
    position: "relative",
    height: "55px",
    padding: "14px 50px 5px 70px"
  },

  plantIconStyle: {
    iconStyle: {
      position: "absolute",
      left: "16px",
      opacity: "0.9",
      top: "16px"
    },

    plantIdStyle: {
      position: "absolute",
      top: "26px",
      left: "22px",
      width: "25px",
      height: "25px",
      lineHeight: "25px",
      color: "#FFF",
      borderRadius: "50",
      backgroundColor: "#757575",
      textAlign: "center",
      zIndex: 0,
      fontWeight: "bold"
    }
  },

  thunderIconStyle: {
    iconStyle: {
      position: "absolute",
      right: "16px",
      opacity: "0.5",
      zIndex: 2,
      top: "16px"
    },

    supportCityAmountStyle: {
      position: "absolute",
      top: "21px",
      right: "25px",
      width: "25px",
      height: "25px",
      lineHeight: "25px",
      color: "#FFF",
      borderRadius: "50",
      backgroundColor: "#757575",
      textAlign: "center",
      fontWeight: "bold"
    }
  }
}

// renderers

export default function PlantItem({plantId}) {
  if (!plantId) {
    return (
      <div style={plantItemStyle.wrapStyle}>
        {plantIcon()}
      </div>
    )
  } else {
    const plant = plants[plantId]

    if (plant.plantType === "step3") {
      return (
        <div style={plantItemStyle.wrapStyle}> Step 3 </div>
      )
    } else {
      return (
        <div style={plantItemStyle.wrapStyle}>
          {plantIcon(plantId)}
          {plantResources(plant)}
          {plantSupportCity(plant)}
        </div>
      )
    }
  }
}

function plantIcon(plantId) {
  const plantIconProps = {
    width: 40,
    height: 40
  }

  const plantIdSpan =
    plantId ?
      <span style={plantItemStyle.plantIconStyle.plantIdStyle}> {plantId} </span> :
      null

  return (
    <div>
      <div style={plantItemStyle.plantIconStyle.iconStyle}>
        <PlantIcon {...plantIconProps} />
      </div>
      {plantIdSpan}
    </div>
  )
}

function plantResources(plant) {
  const resourceIconProps = {
    width: 40,
    height: 40
  }

  switch(plant.plantType) {
  case "coal":
    return _.times(plant.resourceAmountNeeded, (index) => <CoalIcon key={index} {...resourceIconProps}/>)
    // return fast and break nothing...
  case "oil":
    return _.times(plant.resourceAmountNeeded, (index) => <OilIcon key={index} {...resourceIconProps}/>)
  case "hybrid":
    return _.times(plant.resourceAmountNeeded, (index) => <HybridIcon key={index} {...resourceIconProps}/>)
  case "garbage":
    return _.times(plant.resourceAmountNeeded, (index) => <GarbageIcon key={index} {...resourceIconProps}/>)
  case "uranium":
    return <UraniumIcon {...resourceIconProps}/>
  case "ecological":
    return <EcologicalIcon {...resourceIconProps}/>
  }

  return null
}

function plantSupportCity(plant) {
  const thunderIconProps = {
    width: 40,
    height: 40
  }

  return (
    <div>
      <div style={plantItemStyle.thunderIconStyle.iconStyle}>
        <ThunderIcon {...thunderIconProps} />
      </div>
      <span style={plantItemStyle.thunderIconStyle.supportCityAmountStyle}>
        {plant.supportCityAmount}
      </span>
    </div>
  )
}
