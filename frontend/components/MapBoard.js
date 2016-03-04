import React from "react"
import Paper from "material-ui/lib/paper"
import PaperHead from "components/PaperHead"
import CityIcon from "icons/CityIcon"
import {baseColors, boardColors} from "styles"
import _ from "lodash"

// styles
const mapBoardStyle = {
  wrapStyle: {
    margin: "0 10%",
    paddingBottom: "1px"
  },

  mapStyle: {
    wrapStyle: {
      margin: "20px auto",
      width: "1094px",
      position: "relative",
      height: "840px",
      textAlign: "center"
    },

    cityStyle: {
      wrapStyle: (posX, posY) => {
        return {
          position: "absolute",
          left: `${posX}px`,
          top: `${posY}px`
        }
      },

      cityNameStyle: (color) => {
        return {
          color,
          marginTop: "-5px",
          fontSize: "small",
          fontWeight: "bold"
        }
      },

      tunnelStyle: (posX, posY, length, angel) => {
        return {
          border: "3px solid black",
          opacity: "0.1",
          width: `${length}px`,
          height: "0",
          transform: `rotate(${angel}rad)`,
          position: "absolute",
          zIndex: "2",
          left: `${posX}px`,
          top: `${posY}px`
        }
      },

      tunnelPriceStyle: (posX, posY) => {
        return {
          position: "absolute",
          left: `${posX}px`,
          top: `${posY}px`,
          padding: "2px",
          borderRadius: "50",
          backgroundColor: "#757575",
          zIndex: "3",
          color: "#FFF"
        }
      }
    }
  }
}


// renderers

export default function MapBoard({players, citiesOwner, gameMap}) {
  const paperHeadProps = {
    title: "Map"
  }

  return (
    <Paper rounded={false} style={mapBoardStyle.wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      {cityMap(citiesOwner, gameMap, players)}
    </Paper>
  )
}

function cityMap(citiesOwner, gameMap, players) {
  const cityDivs = _.map(gameMap.cities, (cityInfo, cityName) => cityDiv(cityInfo, cityName, citiesOwner[cityName], players))
  const cityTunnelDivs = _.map(gameMap.tunnels, (tunnel, index) => cityTunnel(gameMap.cities[tunnel.city1], gameMap.cities[tunnel.city2], tunnel.price, index))

  return (
    <Paper style={mapBoardStyle.mapStyle.wrapStyle}>
      {cityDivs}
      {cityTunnelDivs}
    </Paper>
  )
}

function cityDiv(cityInfo, cityName, cityOwner, players) {
  let cityIconProps = null
  let cityNameColor = null
  if (cityOwner === "notSelected") {
    cityNameColor = baseColors.darkPrimaryColor
    cityIconProps = {
      fillColor: cityInfo.color,
      width: 50,
      height: 50
    }
  } else if (cityOwner != "banned") {
    cityNameColor = baseColors.darkPrimaryColor
    cityIconProps = {
      fillColor: baseColors.darkPrimaryColor,
      firstColor: players[cityOwner[0]] ? boardColors[players[cityOwner[0]].color] : null,
      secondColor: players[cityOwner[1]] ? boardColors[players[cityOwner[1]].color] : null,
      thirdColor: players[cityOwner[2]] ? boardColors[players[cityOwner[2]].color] : null,
      width: 50,
      height: 50
    }
  } else {
    cityNameColor = baseColors.unavalableIconColor
    cityIconProps = {
      fillColor: baseColors.unavalableIconColor,
      width: 50,
      height: 50
    }
  }

  const cityNameText = _.upperCase(cityName)

  return (
    <div style={mapBoardStyle.mapStyle.cityStyle.wrapStyle(cityInfo.posX, cityInfo.posY)} key={cityName}>
      <CityIcon {...cityIconProps} />
      <div style={mapBoardStyle.mapStyle.cityStyle.cityNameStyle(cityNameColor)}>{cityNameText}</div>
    </div>
  )
}

function cityTunnel(cityInfo1, cityInfo2, price, index) {
  if (!cityInfo1 || !cityInfo2) {
    return null
  }

  let {posX: posX1, posY: posY1} = cityInfo1
  let {posX: posX2, posY: posY2} = cityInfo2

  posX1 = posX1 + 27
  posX2 = posX2 + 27
  posY1 = posY1 + 34
  posY2 = posY2 + 34

  let radius = Math.sqrt((posX1 - posX2) * (posX1 - posX2) + (posY1 - posY2) * (posY1 - posY2)) / 2
  let centerX = (posX1 + posX2) / 2
  let centerY = (posY1 + posY2) / 2

  let lineX = centerX - radius
  let lineY = centerY
  let alpha = Math.PI - Math.atan2(posY2-posY1, posX1-posX2)

  const priceText = price >= 10 ? price : "0" + price
  return (
    <div key={index}>
      <div style={mapBoardStyle.mapStyle.cityStyle.tunnelStyle(lineX, lineY, radius * 2, alpha)} />
      <div style={mapBoardStyle.mapStyle.cityStyle.tunnelPriceStyle(centerX - 9, centerY - 10)}> {priceText} </div>
    </div>
  )
}
