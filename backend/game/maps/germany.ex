defmodule Pgboard.Game.GermanyMap do
  use Pgboard.Game.BoardMap

  # cities
  city :flensburg, color: :purple
  city :kiel, color: :purple
  city :hamburg, color: :purple
  city :cuxhaven, color: :purple
  city :wilhelmshaven, color: :purple
  city :bremen, color: :purple
  city :hannover, color: :purple
  city :lubeck, color: :red
  city :schwerin, color: :red
  city :rostock, color: :red
  city :torgelow, color: :red
  city :magdeberg, color: :red
  city :berlin, color: :red
  city :frankfurtO, color: :red
  city :osnabruck, color: :blue
  city :munster, color: :blue
  city :duisburg, color: :blue
  city :essen, color: :blue
  city :dortmund, color: :blue
  city :kassel, color: :blue
  city :dusseldorf, color: :blue
  city :halle, color: :pink
  city :leipzig, color: :pink
  city :erfurt, color: :pink
  city :dresden, color: :pink
  city :fulda, color: :pink
  city :wurzburg, color: :pink
  city :nurnburg, color: :pink
  city :aachen, color: :orange
  city :koln, color: :orange
  city :trier, color: :orange
  city :wiesbaden, color: :orange
  city :frankfurtM, color: :orange
  city :saarbrucken, color: :orange
  city :mannheim, color: :orange
  city :freiburg, color: :black
  city :stuttgart, color: :black
  city :konstanz, color: :black
  city :augsburg, color: :black
  city :regensberg, color: :black
  city :munchen, color: :black
  city :passau, color: :black

  # tunnels
  tunnel :flensburg, :kiel, 4
  tunnel :kiel, :hamburg, 8
  tunnel :kiel, :lubeck, 4
  tunnel :hamburg, :cuxhaven, 11
  tunnel :hamburg, :lubeck, 6
  tunnel :hamburg, :schwerin, 8
  tunnel :hamburg, :bremen, 11
  tunnel :hamburg, :hannover, 17
  tunnel :cuxhaven, :bremen, 8
  tunnel :bremen, :wilhelmshaven, 11
  tunnel :bremen, :hannover, 10
  tunnel :wilhelmshaven, :osnabruck, 14
  tunnel :hannover, :schwerin, 19
  tunnel :hannover, :magdeberg, 15
  tunnel :hannover, :erfurt, 19
  tunnel :hannover, :kassel, 15
  tunnel :hannover, :osnabruck, 16
  tunnel :lubeck, :schwerin, 6
  tunnel :schwerin, :rostock, 6
  tunnel :schwerin, :torgelow, 19
  tunnel :schwerin, :berlin, 18
  tunnel :schwerin, :magdeberg, 16
  tunnel :rostock, :torgelow, 19
  tunnel :torgelow, :berlin, 15
  tunnel :magdeberg, :berlin, 10
  tunnel :magdeberg, :halle, 11
  tunnel :berlin, :halle, 17
  tunnel :berlin, :frankfurtO, 6
  tunnel :frankfurtO, :leipzig, 21
  tunnel :frankfurtO, :dresden, 16
  tunnel :osnabruck, :munster, 7
  tunnel :osnabruck, :kassel, 20
  tunnel :munster, :essen, 6
  tunnel :munster, :dortmund, 2
  tunnel :duisburg, :essen, 0
  tunnel :essen, :dortmund, 4
  tunnel :essen, :dusseldorf, 2
  tunnel :dortmund, :kassel, 18
  tunnel :dortmund, :frankfurtM, 20
  tunnel :dortmund, :koln, 10
  tunnel :dusseldorf, :aachen, 9
  tunnel :dusseldorf, :koln, 4
  tunnel :kassel, :erfurt, 15
  tunnel :kassel, :fulda, 8
  tunnel :kassel, :frankfurtM, 13
  tunnel :halle, :leipzig, 0
  tunnel :halle, :erfurt, 6
  tunnel :leipzig, :dresden, 13
  tunnel :dresden, :erfurt, 19
  tunnel :erfurt, :fulda, 13
  tunnel :erfurt, :nurnburg, 21
  tunnel :fulda, :wurzburg, 11
  tunnel :wurzburg, :nurnburg, 8
  tunnel :wurzburg, :augsburg, 19
  tunnel :wurzburg, :stuttgart, 12
  tunnel :nurnburg, :augsburg, 18
  tunnel :nurnburg, :regensberg, 12
  tunnel :aachen, :koln, 7
  tunnel :aachen, :trier, 19
  tunnel :koln, :trier, 20
  tunnel :koln, :wiesbaden, 21
  tunnel :trier, :saarbrucken, 11
  tunnel :wiesbaden, :frankfurtM, 0
  tunnel :wiesbaden, :mannheim, 11
  tunnel :wiesbaden, :saarbrucken, 10
  tunnel :frankfurtM, :fulda, 8
  tunnel :frankfurtM, :wurzburg, 13
  tunnel :saarbrucken, :stuttgart, 17
  tunnel :mannheim, :stuttgart, 6
  tunnel :mannheim, :wurzburg, 10
  tunnel :freiburg, :stuttgart, 16
  tunnel :freiburg, :konstanz, 14
  tunnel :stuttgart, :augsburg, 15
  tunnel :stuttgart, :konstanz, 16
  tunnel :konstanz, :augsburg, 17
  tunnel :augsburg, :regensberg, 13
  tunnel :augsburg, :munchen, 6
  tunnel :regensberg, :munchen, 10
  tunnel :regensberg, :passau, 12
  tunnel :munchen, :passau, 14
end