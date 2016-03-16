defmodule Pgboard.Game.BoardMap do
  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__), only: [specific_rule: 2]
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro specific_rule(condition, do: handler) do
    quote do
      def handle_move(var!(current_board), move) when unquote(condition), do: unquote(handler)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      # use common rule when none of specific rule in this map should be applied
      def handle_move(current_board, move) do
        # todo
      end
    end
  end
end
