defmodule Pgboard.Game.Phase do
  @moduledoc """
  Macros for each phase.
  """

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute __MODULE__, :specific_rule_for, accumulate: true
      import unquote(__MODULE__), only: [subphase: 2]
    end
  end

  defmacro subphase(phase_name, do: block) do
    escaped_block = Macro.escape(Macro.escape block)

    quote bind_quoted: [phase_name: phase_name, escaped_block: escaped_block] do
      # Do nothing but pass the fault reason when fails in previous subphase.
      defp unquote(phase_name)({:error, reason}), do: {:error, reason}

      Enum.each @specific_rule_for, fn({map, description}) ->
        specific_rule_block = Pgboard.Game.Phase.get_specific_rule(map, description)

        defp unquote(phase_name)({:ok, %{map: map}=current_board_state, logs_to_append})
          when map == unquote(map), do: unquote(specific_rule_block)
      end

      defp unquote(phase_name)({:ok, %{map: map}=current_board_state, logs_to_append}), do: unquote(escaped_block)

      Module.delete_attribute __MODULE__, :specific_rule_for
    end
  end

  defmodule Plug do
    defmacro __using__(_opt) do
      quote do
        import unquote(__MODULE__), only: [game_phase: 1]
      end
    end

    defmacro game_phase(phase_module) do
      phase_name = get_phase_name_from_module(phase_module)
      # def escape_self_twice_to_put_in_a_macro_with_bind_quoted_that_defines_a_function(any_term)
      phase_module = Macro.escape(Macro.escape phase_module)

      quote bind_quoted: [phase_name: phase_name, phase_module: phase_module] do
        def handle_move(%{current_phase: current_phase} = current_board_state, current_move)
          when current_phase == unquote(phase_name) do
          Map.put current_board_state, :current_move, current_move
          unquote(phase_module).handle_move(current_board_state)
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
