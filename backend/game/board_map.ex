defmodule Pgboard.Game.BoardMap do
  @moduledoc """
  Macros for each map.
  """

  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__), only: [specific_rule: 2, city: 2, tunnel: 3]

      Module.register_attribute __MODULE__, :cities, accumulate: true
      Module.register_attribute __MODULE__, :tunnels, accumulate: true

      @before_compile unquote(__MODULE__)
    end
  end

  @doc """
  Cities in the map
  """
  defmacro city(name, attributes) do
    quote do
      @cities {unquote(name), unquote(attributes)}
    end
  end

  @doc """
  Tunnels that connects two cities
  """
  defmacro tunnel(city1, city2, cost) do
    quote do
      @tunnels {unquote(city1), unquote(city2), unquote(cost)}
    end
  end

  @doc """
  Specific rule for current map.
  """
  defmacro specific_rule(condition, do: handler) do
    quote do
      def handle_move(var!(current_board_state), var!(current_card_deck), var!(move))
        when unquote(condition),
        do: unquote(handler)
    end
  end

  @doc """
  Define some functions before a map module is compiled
  """
  defmacro __before_compile__(_env) do
    quote do
      # Fall back to use common rule handler when none of specific rule in this map should be applied.
      def handle_move(current_board_state, current_card_deck, move) do
        Pgboard.Game.Arbiter.basic_rule_handler(current_board_state, current_card_deck, move)
      end

      @registered_cities Enum.into @cities, %{}
      def cities do
        @registered_cities
      end

      @registered_tunnels unquote(__MODULE__).transform_tunnels(@tunnels)
      def tunnels do
        @registered_tunnels
      end
    end
  end

  # Turn the array into connected list for the convenience of dijkstra.
  def transform_tunnels(tunnels) do
    connect_list = %{}

    Enum.each tunnels, fn({city1, city2, cost}) ->
      Map.update connect_list, city1, [], &([{city2, cost} | &1])
      Map.update connect_list, city2, [], &([{city1, cost} | &1])
    end

    connect_list
  end

  defmodule Plug do
    @moduledoc """
    Plug each game map for arbiter.
    """

    defmacro __using__(_opts) do
      quote do
        import unquote(__MODULE__), only: [game_map: 1]
      end
    end

    defmacro game_map(map_module_name) do
      map_name = get_map_name_from_module(map_module_name)

      quote do
        def handle_move(%{map: current_map} = current_board_state, current_card_deck, move)
          when current_map == unquote(map_name) do
            unquote(map_module_name).handle_move(current_board_state, current_card_deck, move)
        end
      end
    end

    defp get_map_name_from_module(map_module) do
      {:__aliases__, _, name_atom_list} = map_module

      name_atom_list
      |> List.last
      |> Atom.to_string
      |> String.downcase
    end
  end
end
