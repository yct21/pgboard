defmodule Pgboard.Game.Phase do
  @moduledoc """
  Macros for each phase.
  """

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute __MODULE__, :specific_rule_for, accumulate: true
      import unquote(__MODULE__), only: [subphase: 3]
    end
  end

  defmacro subphase(phase_name, params \\ {}, do: block) do
    escaped_params = Macro.escape(params)
    escaped_block = Macro.escape(block)

    quote bind_quoted: [phase_name: phase_name, escaped_params: escaped_params, escaped_block: escaped_block] do
      Enum.each @special_rule_for, fn({map, description}) ->
        {special_rule_params, special_rule_block} = Pgboard.Game.Phase.get_specific_rule(map, description)

        # if unquote(params) != special_rule_params do
        #   raise "parameter in the special rule doesn't match common"
        # end
        # IO.inspect {special_rule_params, special_rule_block}
        defp unquote(phase_name)(map, unquote(escaped_params)) when map == :usa, do: unquote(special_rule_block)
      end

      defp unquote(phase_name)(map, unquote(escaped_params)), do: unquote(escaped_block)
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
        def handle_move(%{current_phase: current_phase} = current_board_state, move)
          when current_phase == unquote(phase_name) do
          map_module = get_map_module(current_board_state.map)
          unquote(phase_module).handle_move(current_board_state, map_module, move)
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
