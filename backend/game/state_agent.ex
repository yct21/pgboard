defmodule Pgboard.Game.StateAgent do
  @moduledoc """
  Agent that stores game state.

  game state: %{
    board: board state that everybody could see (see Pgboard.Game.Board)
    card_deck: power plant card deck
    logs: game logs
  }
  """
  # api
  def start_link do
    Agent.start_link(&(init_data/0), name: __MODULE__)
  end

  def get_current_board do
    Agent.get(__MODULE__, fn({board_state, _card_deck, logs}) -> {board_state, logs} end)
  end

  def handle_move(move) do
    Agent.cast(__MODULE__, fn({current_board_state, current_card_deck, current_logs}) ->
      case Pgboard.Game.Arbiter.handle_move(current_board_state, current_card_deck, move) do
        {:ok, new_board_state, new_card_deck, logs_to_append} ->
          {new_board_state, new_card_deck, current_logs ++ logs_to_append}
      end
    end)
  end

  # private functions
  defp init_data do
    """
    {
      "playerOrder": [42, 11, 25, 21, 81, 49],
      "resources": {
        "coal": 17,
        "oil": 22,
        "garbage": 14,
        "uranium": 3
      },
      "tableOrder": [42],
      "gameInfo": {
        "gameStep": 1,
        "map": "germany"
      },
      "plantsInMarket": ["03", "04", "05", "06", "07", "08", "09", "10"],
      "players": {
        "42": {
          "id": 42,
          "name": "Era_Darkstar",
          "color": "pink",
          "portrait": "a5cf4572615f4461726b73746172370c",
          "funds": 42,
          "cities": 11,
          "plants": [11, 42, 50],
          "resources": {
            "coal": 1,
            "oil": 2,
            "garbage": 4,
            "uranium": 8
          }
        },
        "11": {
          "id": 11,
          "name": "Era_Darkstar",
          "color": "blue",
          "portrait": "a5cf4572615f4461726b73746172370c",
          "funds": 42,
          "cities": 11,
          "plants": [11, 50, "05"],
          "resources": {
            "coal": 1,
            "oil": 2,
            "garbage": 4,
            "uranium": 8
          }
        },
        "25": {
          "id": 25,
          "name": "Era_Darkstar",
          "color": "red",
          "portrait": "a5cf4572615f4461726b73746172370c",
          "funds": 42,
          "cities": 11,
          "plants": [11, 42],
          "resources": {
            "coal": 1,
            "oil": 2,
            "garbage": 4,
            "uranium": 8
          }
        },
        "21": {
          "id": 21,
          "name": "Era_Darkstar",
          "color": "orange",
          "portrait": "a5cf4572615f4461726b73746172370c",
          "funds": 42,
          "cities": 11,
          "plants": [11, 42],
          "resources": {
            "coal": 1,
            "oil": 2,
            "garbage": 4,
            "uranium": 8
          }
        },
        "81": {
          "id": 81,
          "name": "Era_Darkstar",
          "color": "purple",
          "portrait": "a5cf4572615f4461726b73746172370c",
          "funds": 42,
          "cities": 11,
          "plants": [11, 42],
          "resources": {
            "coal": 1,
            "oil": 2,
            "garbage": 4,
            "uranium": 8
          }
        },
        "49": {
          "id": 49,
          "name": "Era_Darkstar",
          "color": "black",
          "portrait": "a5cf4572615f4461726b73746172370c",
          "funds": 42,
          "cities": 11,
          "plants": [11, 42],
          "resources": {
            "coal": 1,
            "oil": 2,
            "garbage": 4,
            "uranium": 8
          }
        }
      },
      "citiesOwner": {
        "flensburg": "not_selected",
        "kiel": "not_selected",
        "hamburg": "not_selected",
        "cuxhaven": "not_selected",
        "wilhelmshaven": "not_selected",
        "bremen": "not_selected",
        "hannover": "not_selected",
        "lubeck": "not_selected",
        "schwerin": "not_selected",
        "rostock": "not_selected",
        "torgelow": "not_selected",
        "magdeberg": "not_selected",
        "berlin": "not_selected",
        "frankfurtO": "not_selected",
        "osnabruck": "not_selected",
        "munster": "not_selected",
        "duisburg": "not_selected",
        "essen": "not_selected",
        "dortmund": "not_selected",
        "kassel": "not_selected",
        "dusseldorf": "not_selected",
        "halle": "not_selected",
        "leipzig": "not_selected",
        "erfurt": "not_selected",
        "dresden": "not_selected",
        "fulda": "not_selected",
        "wurzburg": "not_selected",
        "nurnburg": "not_selected",
        "aachen": "not_selected",
        "koln": "not_selected",
        "trier": "not_selected",
        "wiesbaden": "not_selected",
        "frankfurtM": "not_selected",
        "saarbrucken": "not_selected",
        "mannheim": "not_selected",
        "freiburg": "not_selected",
        "stuttgart": "not_selected",
        "konstanz": "not_selected",
        "augsburg": "not_selected",
        "regensberg": "not_selected",
        "munchen": "not_selected",
        "passau": "not_selected"
      }
    }
    """
  end


end
