defmodule Pgboard.Game.CardDeck do
  @plants %{
    3 => {2, :oil, 1},
    4 => {2, :coal, 1},
    5 => {2, :hybrid, 1},
    6 => {1, :garbage, 1},
    7 => {3, :oil, 2},
    8 => {3, :coal, 2},
    9 => {1, :oil, 1},
    10 => {2, :coal, 2},
    11 => {1, :uranium, 2},
    12 => {2, :hybrid, 2},
    13 => {0, :ecological, 1},
    14 => {2, :garbage, 2},
    15 => {2, :coal, 3},
    16 => {2, :oil, 3},
    17 => {1, :uranium, 2},
    18 => {0, :ecological, 2},
    19 => {2, :garbage, 3},
    20 => {3, :coal, 5},
    21 => {2, :hybrid, 4},
    22 => {0, :ecological, 2},
    23 => {1, :uranium, 3},
    24 => {2, :garbage, 4},
    25 => {2, :coal, 5},
    26 => {2, :oil, 5},
    27 => {0, :ecological, 3},
    28 => {1, :uranium, 4},
    29 => {1, :hybrid, 4},
    30 => {3, :garbage, 6},
    31 => {3, :coal, 6},
    32 => {3, :oil, 6},
    33 => {0, :ecological, 4},
    34 => {1, :uranium, 5},
    35 => {1, :oil, 5},
    36 => {3, :coal, 7},
    37 => {0, :ecological, 4},
    38 => {3, :garbage, 7},
    39 => {1, :uranium, 6},
    40 => {2, :oil, 6},
    42 => {2, :coal, 6},
    44 => {0, :ecological, 5},
    46 => {3, :hybrid, 7},
    50 => {0, :ecological, 6}
  }

  @doc """
  Get plant info by plant_id.
  """
  def plant(plant_id) do
    Map.get @plants, plant_id
  end

  @doc """
  Basic process to initialize a card deck.

  According to the rule, plant 3-10 would be placed in plant market in order,
  followed by card 13,
  with all other cards shuffled while removing some plants randomly (3 players: 8, 4 players: 4, above: 0).
  Finally put Step 3 card to the bottom of deck.

  Each map may have specific rule of how to initialize a deck.
  """
  def basic_deck(player_amount) do
    plant_market = Enum.to_list(3..10)
    plant_amount_to_remove =
      case player_amount do
        3 -> 8
        4 -> 4
        5 -> 0
        6 -> 0
      end

    remain_plants = (Map.keys(@plants) -- plant_market) -- [13]
    remain_deck = Enum.take_random(remain_plants, Enum.count(remain_plants) - plant_amount_to_remove)

    plant_market ++ [13] ++ remain_deck ++ [:step3]
  end

  @doc """
  Refills the market when any cards is taken.
  According to the rule, any plant in market should have id more than max plant amount of any player.

  Returns processed {available_market, future_market, card_deck}.
  """
  def refill_market(plant_market, card_deck, available_amount, future_amount, max_plant_amount) do
    market_plants = plant_market.available_market ++ plant_market.future_market
    market_plants_amount = available_amount + future_amount
    refill_amount = market_plants_amount - Enum.count(market_plants)

    cond do
      # Unnecessary to refill.
      refill_amount <= 0 -> {plant_market, card_deck}
      # Or...
      true ->
        {_discarded_plants, valid_plants} = Enum.split_while(card_deck, &(&1 != :step3 && &1 <= max_plant_amount))
        plants_to_refill = Enum.take valid_plants, refill_amount

        processed_card_deck =
          case Enum.any?(plants_to_refill, &(&1 == :step3)) do
            false ->
              valid_plants -- plants_to_refill
            true ->
              # When step3 card appears, remaining cards should be shuffled.
              Enum.shuffle(valid_plants -- plants_to_refill)
          end

        refilled_market_plants = sort_plants(market_plants ++ plants_to_refill)
        {refilled_available_market, refilled_future_market} = Enum.split refilled_market_plants, available_amount

        {refilled_available_market, refilled_future_market, processed_card_deck}
    end
  end

  defp sort_plants(plants) do
    Enum.sort plants, fn(plant1, plant2) ->
      cond do
        plant1 == :step3 -> false
        plant2 == :step3 -> true
        true -> plant1 <= plant2
      end
    end
  end
end
