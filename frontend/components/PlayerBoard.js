import React from "react"
import Paper from "material-ui/lib/paper"
import Avatar from "material-ui/lib/avatar"
import Divider from "material-ui/lib/divider"
import PlantItem from "components/PlantItem"
import PaperHead from "components/PaperHead"
import CityIcon from "icons/CityIcon"
import CoalIcon from "icons/CoalIcon"
import OilIcon from "icons/OilIcon"
import UraniumIcon from "icons/UraniumIcon"
import GarbageIcon from "icons/GarbageIcon"
import {baseColors} from "styles"
import _ from "lodash"

// styles

const wrapStyle = {
  margin: "0 10%",
  paddingBottom: "1px"
}

const playerListStyle = {
  wrapDivStyle: {
    margin: "20px 2%"
  },

  wrapListStyle: {
    display: "inline-block",
    width: "272px",
    verticalAlign: "top",
    margin: "10px 10px"
  },

  playerInfoStyle: {
    padding: "14px 90px 5px 70px",
    position: "relative",
    height: "55px",
    color: baseColors.darkPrimaryColor
  },

  avatarStyle: {
    position: "absolute",
    top: "16px",
    left: "16px",
    display: "inline-block"
  },

  cityAmountStyle: {
    position: "absolute",
    top: "26px",
    right: "22px",
    width: "25px",
    height: "25px",
    lineHeight: "25px",
    color: "#FFF",
    borderRadius: "50",
    backgroundColor: "#757575",
    textAlign: "center",
    opacity: "0.8",
    fontWeight: "bold"
  },

  cityIconStyle: {
    position: "absolute",
    top: "16px",
    right: "16px",
    zIndex: "0"
  },

  resourceAmountStyle: {
    position: "absolute",
    top: "13px",
    left: "12px",
    width: "25px",
    height: "25px",
    lineHeight: "25px",
    color: "#FFF",
    borderRadius: "50",
    backgroundColor: "#757575",
    textAlign: "center",
    fontWeight: "bold"
  },

  resourceIconStyle: {
    position: "absolute",
    top: "5px",
    left: "5px",
    opacity: "0.5",
    zIndex: "2"
  },

  nameStyle: {
    display: "inline",
    height: "50px"
  },

  playerResourceListStyle: {
    margin: "5px 0 5px 13px"
  },

  resourceDivStyle: {
    display: "inline-block",
    width: "25%",
    height: "50px",
    position: "relative"
  }
}

// renderers

export default function PlayerBoard({players, playerOrder}) {
  const paperHeadProps = {
    title: "Players"
  }

  return (
    <Paper rounded={false} style={wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      <div style={playerListStyle.wrapDivStyle}>
        {playerCards(players, playerOrder)}
      </div>
    </Paper>
  )
}

function playerCards(players, playerOrder) {
  return playerOrder.map((playerId, index) => playerCard(players[playerId], index))
}

function playerCard(player, index) {
  const wrapPaperProps = {
    rounded: false,
    style: playerListStyle.wrapListStyle,
    key: player.id
  }

  return (
    <Paper {...wrapPaperProps}>
      {playerBasicInfo(player)}
      <Divider />
      {playerResourceList(player)}
      <Divider />
      {playerPlantList(player)}
    </Paper>
  )
}

function playerBasicInfo(player) {
  const cityIconProps = {
    height: "40",
    width: "40",
    fillColor: player.color
  }

  const cityAmountText = player.cities >=10 ? player.cities : "0" + player.cities

  return (
    <div style={playerListStyle.playerInfoStyle}>
      {playerAvatar(player.portrait)}
      <div>{player.name}</div>
      <div>
        <span>${`${player.funds}`}</span>
      </div>
      <div style={playerListStyle.cityIconStyle}>
        <CityIcon {...cityIconProps} />
      </div>
      <span style={playerListStyle.cityAmountStyle}>
        {cityAmountText}
      </span>
    </div>
  )
}

function playerAvatar(portrait) {
  const avatarSrc = `http://tb.himg.baidu.com/sys/portraitn/item/${portrait}`

  const avatarProps = {
    src: avatarSrc,
    style: playerListStyle.avatarStyle
  }

  return (
    <Avatar {...avatarProps}/>
  )
}

function playerResourceList(player) {
  return (
    <div style={playerListStyle.playerResourceListStyle}>
      {playerResourceIcon(CoalIcon, player.resources.coal)}
      {playerResourceIcon(OilIcon, player.resources.oil)}
      {playerResourceIcon(GarbageIcon, player.resources.garbage)}
      {playerResourceIcon(UraniumIcon, player.resources.uranium, true)}
    </div>
  )
}

function playerResourceIcon(resourceIcon, amount) {
  const iconProps = {
    width: "40",
    height: "40"
  }

  const amountText = amount >=10 ? amount : "0" + amount

  return (
    <div style={playerListStyle.resourceDivStyle}>
      <div style={playerListStyle.resourceIconStyle}>
        {React.createElement(resourceIcon, iconProps)}
      </div>
      <span style={playerListStyle.resourceAmountStyle}>
        {amountText}
      </span>
    </div>
  )
}

function playerPlantList(player) {
  return (
    <div>
      <PlantItem plantId={player.plants[0]}/>
      <Divider />
      <PlantItem plantId={player.plants[1]}/>
      <Divider />
      <PlantItem plantId={player.plants[2]}/>
    </div>
  )
}
