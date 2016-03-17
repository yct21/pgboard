defmodule Pgboard.Game.BoardMap do
  @moduledoc """
  Macros for each map
  """

  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__), only: [specific_rule: 2]
      @before_compile unquote(__MODULE__)
    end
  end

  @doc """
  specific rule for current map
  """
  defmacro specific_rule(condition, do: handler) do
    quote do
      def handle_move(var!(current_board), move) when unquote(condition), do: unquote(handler)
    end
  end

  @doc """
  use common rule when none of specific rule in this map should be applied
  """
  defmacro __before_compile__(_env) do
    quote do
      def handle_move(current_board, move) do
        # todo
      end
    end
  end

  defmodule Plug do
    @moduledoc """
    Plug each game map for arbiter.ex
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
