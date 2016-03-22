defmodule Pgboard.Game.BoardMap do
  @moduledoc """
  Macros for each map.
  """

  defmacro __using__(_opt) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__), only: [specific_rule: 2, city: 2, tunnel: 3]

      Module.register_attribute __MODULE__, :cities, accumulate: true
      Module.register_attribute __MODULE__, :tunnels, accumulate: true
      Module.register_attribute __MODULE__, :specific_rules, accumulate: true

      @before_compile unquote(__MODULE__)
    end
  end

  @doc """
  Cities in the map.
  """
  defmacro city(name, attributes) do
    quote do
      @cities {unquote(name), Enum.into(unquote(attributes), %{})}
    end
  end

  @doc """
  Tunnels that connects two cities.
  """
  defmacro tunnel(city1, city2, cost) do
    quote do
      @tunnels {unquote(city1), unquote(city2), unquote(cost)}
    end
  end

  @doc """
  Specific rule for current map.
  """
  defmacro specific_rule(description, [do: block]) do
    rule_name = :"specific rule: #{description}"
    block = Macro.escape(block)
    quote bind_quoted: binding do
      @specific_rules {rule_name, block}
    end
  end

  @doc """
  Define several functions before a map module is compiled.

  - `cities`
  - `tunnels`
  - `get_specific_rule(description)`
  """
  defmacro __before_compile__(%{module: map_module}) do
    # Escape twice since both bind_quoted and unquote phrase would evaluate an expression.
    # Though confusing to read but still necessary since unquote phrase is needed when define methods in quote.
    # Macros are confusing anyway. ┑(￣Д ￣)┍
    cities =
      map_module
      |> Module.get_attribute(:cities)
      |> Enum.into(%{})
      |> Macro.escape
      |> Macro.escape

    tunnels =
      map_module
      |> Module.get_attribute(:tunnels)
      |> transform_tunnels
      |> Macro.escape
      |> Macro.escape

    quote bind_quoted: [cities: cities, tunnels: tunnels] do
      def cities, do: unquote(cities)
      def tunnels, do: unquote(tunnels)

      def get_specific_rule(description) do
        rule_name = :"specific rule: #{description}"
        Keyword.fetch!(@specific_rules, rule_name)
      end
    end
  end

  # Turn the array into connected list for the convenience of dijkstra.
  defp transform_tunnels(tunnels) do
    Enum.reduce tunnels, %{}, fn({city1, city2, cost}, connected_list) ->
      connected_list
      |> Map.update(city1, [{city2, cost}], &([{city2, cost} | &1]))
      |> Map.update(city2, [{city1, cost}], &([{city1, cost} | &1]))
    end
  end

  defmodule Plug do
    @moduledoc """
    Plug each game map for arbiter.
    """

    defmacro __using__(_opts) do
      quote do
        import unquote(__MODULE__), only: [game_map: 1]
        Module.register_attribute __MODULE__, :maps, accumulate: true

        @before_compile unquote(__MODULE__)
      end
    end

    @doc """
    Record module name and its map name.

    @game_map {Pgboard.Game.UsaMap, :usa}
    """
    defmacro game_map(map_module_name) do
      map_name = get_map_name_from_module(map_module_name)

      quote bind_quoted: [map_name: map_name, map_module_name: map_module_name] do
        @maps {map_name, map_module_name}
      end
    end

    @doc """
    Add `get_map_module(map_name)` to Arbiter
    """
    defmacro __before_compile__(%{module: arbiter_module}) do
      maps =
        arbiter_module
        |> Module.get_attribute(:maps)
        |> Enum.into(%{})
        |> Macro.escape
        |> Macro.escape

      quote bind_quoted: [maps: maps] do
        def get_map_module(map) do
          Map.fetch! unquote(maps), map
        end
      end
    end

    defp get_map_name_from_module(map_module) do
      {:__aliases__, _, name_atom_list} = map_module

      name_atom_list
      |> List.last
      |> Atom.to_string
      |> String.replace_suffix("Map", "")
      |> String.downcase
      |> String.to_atom
    end
  end
end
