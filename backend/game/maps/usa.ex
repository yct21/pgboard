defmodule Pgboard.Game.UsaMap do
  use Pgboard.Game.BoardMap

  # cities
  city :seattle, color: :purple
  # city :portland, color: :purple
  # city :boise, color: :purple
  # city :billings, color: :purple
  # city :cheyenne, color: :purple
  # city :denver, color: :purple
  # city :omaha, color: :purple
  # city :fargo, color: :red
  # city :duluth, color: :red
  # city :minneapolis, color: :red
  # city :chicago, color: :red
  # city :stLouis, color: :red
  # city :cincinnati, color: :red
  # city :knoxville, color: :red
  # city :detroit, color: :blue
  # city :buffalo, color: :blue
  # city :pittsburgh, color: :blue
  # city :washington, color: :blue
  # city :philadelphia, color: :blue
  # city :newYork, color: :blue
  # city :boston, color: :blue
  # city :sanFrancisco, color: :pink
  # city :saltLakeCity, color: :pink
  # city :lasVegas, color: :pink
  # city :santaFe, color: :pink
  # city :losAngeles, color: :pink
  # city :sanDiego, color: :pink
  # city :phoenix, color: :pink
  # city :kansasCity, color: :orange
  # city :oklahomaCity, color: :orange
  # city :dallas, color: :orange
  # city :houston, color: :orange
  # city :memphis, color: :orange
  # city :newOrleans, color: :orange
  # city :birmingham, color: :orange
  # city :atlanta, color: :black
  # city :raleigh, color: :black
  # city :norfolk, color: :black
  # city :savannah, color: :black
  # city :jacksonville, color: :black
  # city :tampa, color: :black
  # city :miami, color: :black

  # tunnels
  tunnel :seattle, :portland, 3
  tunnel :seattle, :boise, 12
  tunnel :seattle, :billings, 9
  tunnel :portland, :boise, 13
  tunnel :portland, :sanFrancisco, 24
  tunnel :boise, :sanFrancisco, 23
  tunnel :boise, :saltLakeCity, 8
  tunnel :boise, :denver, 24
  tunnel :boise, :billings, 12
  tunnel :billings, :fargo, 17
  tunnel :billings, :minneapolis, 18
  tunnel :billings, :cheyenne, 9
  tunnel :cheyenne, :minneapolis, 18
  tunnel :cheyenne, :omaha, 14
  tunnel :cheyenne, :denver, 0
  tunnel :denver, :saltLakeCity, 21
  tunnel :denver, :santaFe, 13
  tunnel :denver, :kansasCity, 16
  tunnel :omaha, :minneapolis, 8
  tunnel :omaha, :chicago, 13
  tunnel :omaha, :kansasCity, 5
  tunnel :sanFrancisco, :saltLakeCity, 27
  tunnel :sanFrancisco, :lasVegas, 14
  tunnel :sanFrancisco, :losAngeles, 9
  tunnel :losAngeles, :lasVegas, 9
  tunnel :losAngeles, :sanDiego, 3
  tunnel :sanDiego, :lasVegas, 9
  tunnel :sanDiego, :phoenix, 14
  tunnel :lasVegas, :saltLakeCity, 18
  tunnel :lasVegas, :santaFe, 27
  tunnel :lasVegas, :phoenix, 15
  tunnel :phoenix, :santaFe, 18
  tunnel :saltLakeCity, :santaFe, 28
  tunnel :santaFe, :kansasCity, 16
  tunnel :santaFe, :oklahomaCity, 15
  tunnel :santaFe, :dallas, 16
  tunnel :santaFe, :houston, 21
  tunnel :fargo, :duluth, 6
  tunnel :fargo, :minneapolis, 6
  tunnel :duluth, :minneapolis, 5
  tunnel :duluth, :detroit, 15
  tunnel :duluth, :chicago, 12
  tunnel :minneapolis, :chicago, 8
  tunnel :chicago, :kansasCity, 8
  tunnel :chicago, :stLouis, 10
  tunnel :chicago, :cincinnati, 7
  tunnel :chicago, :detroit, 7
  tunnel :stLouis, :kansasCity, 6
  tunnel :stLouis, :memphis, 7
  tunnel :stLouis, :atlanta, 12
  tunnel :stLouis, :cincinnati, 12
  tunnel :cincinnati, :detroit, 4
  tunnel :cincinnati, :pittsburgh, 7
  tunnel :cincinnati, :raleigh, 15
  tunnel :cincinnati, :knoxville, 6
  tunnel :knoxville, :atlanta, 5
  tunnel :kansasCity, :oklahomaCity, 8
  tunnel :kansasCity, :memphis, 12
  tunnel :oklahomaCity, :memphis, 14
  tunnel :oklahomaCity, :dallas, 3
  tunnel :dallas, :memphis, 12
  tunnel :dallas, :houston, 5
  tunnel :dallas, :newOrleans, 12
  tunnel :houston, :newOrleans, 8
  tunnel :memphis, :birmingham, 6
  tunnel :memphis, :newOrleans, 7
  tunnel :newOrleans, :birmingham, 11
  tunnel :newOrleans, :jacksonville, 16
  tunnel :birmingham, :atlanta, 3
  tunnel :birmingham, :jacksonville, 9
  tunnel :detroit, :buffalo, 7
  tunnel :detroit, :pittsburgh, 6
  tunnel :buffalo, :pittsburgh, 7
  tunnel :buffalo, :newYork, 8
  tunnel :pittsburgh, :washington, 6
  tunnel :pittsburgh, :raleigh, 7
  tunnel :washington, :philadelphia, 3
  tunnel :washington, :norfolk, 5
  tunnel :philadelphia, :newYork, 0
  tunnel :newYork, :boston, 3
  tunnel :atlanta, :raleigh, 7
  tunnel :atlanta, :savannah, 7
  tunnel :norfolk, :raleigh, 3
  tunnel :raleigh, :savannah, 7
  tunnel :savannah, :jacksonville, 0
  tunnel :jacksonville, :tampa, 4
  tunnel :tampa, :miami, 4
end