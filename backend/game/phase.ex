defmodule Pgboard.Game.Phase do
  @moduledoc """
  Macros for each phase.
  """

  defmacro __using__([name: phase_name]) do
    quote do
      Module.register_attribute __MODULE__, :specific_rule_for, accumulate: true
      import unquote(__MODULE__), only: [subphase: 2]
      import ShortMaps
      @phase_name unquote(phase_name)
    end
  end

  @doc """
  Defines subphases for Module phase.

  Following functions are appended in this macro:
  - `subphase_name({:error, reason})` for error handling
  - `subphase_name({:ok, %{map: map} = board_state, logs_to_append})` when specific rule is applied.
  - `subphase_name({:ok, board_state, logs_to_append})` when no specific rule is applied`.
  """
  defmacro subphase(phase_name, do: block) do
    escaped_block = Macro.escape(block)

    quote bind_quoted: [phase_name: phase_name, escaped_block: escaped_block] do
      # Do nothing but pass the fault reason when fails in previous subphase.
      defp unquote(phase_name)({:error, reason}), do: {:error, reason}

      # Specific rule applied.
      Enum.each @specific_rule_for, fn({map, description}) ->
        specific_rule_block = Pgboard.Game.Phase.get_specific_rule(map, description)

        defp unquote(phase_name)({:ok, %{map: map} = var!(board_state), var!(logs_to_append)})
          when map == unquote(map), do: unquote(specific_rule_block)
      end

      # No specific rule applied.
      defp unquote(phase_name)({:ok, var!(board_state), var!(logs_to_append)}), do: unquote(escaped_block)

      Module.delete_attribute __MODULE__, :specific_rule_for
    end
  end

  defmodule Plug do
    @moduledoc """
    Plug a phase into Game Arbiter.
    """

    defmacro __using__(_opt) do
      quote do
        import unquote(__MODULE__), only: [game_phase: 1]
        import ShortMaps
      end
    end

    defmacro game_phase(phase_module) do
      phase_name = get_phase_name_from_module(phase_module)
      phase_module = Macro.escape(phase_module)

      quote bind_quoted: [phase_name: phase_name, phase_module: phase_module] do
        def handle_move(current_board_state, %{current_phase: current_phase} = current_move)
          when current_phase == unquote(phase_name) do
          cond do
            current_phase != :preparation && current_move.player != current_board_state.expected_move.player ->
              {:error, "Not expected player"}
            true ->
              board_state =
                current_board_state
                |> Map.put(:current_move, current_move)
                |> Map.put(:expected_move, nil)

              unquote(phase_module).handle_move(board_state)
          end
        end
      end
    end

    defp get_phase_name_from_module(phase_module) do
      {:__aliases__, _, name_atom_list} = phase_module

      name_atom_list
      |> List.last
      |> Atom.to_string
      |> String.replace_suffix("Phase", "")
      |> String.downcase
      |> String.to_atom
    end
  end
end
