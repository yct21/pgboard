defmodule Pgboard.Game.CardDeckTest do
  use ExUnit.Case, async: true
  alias Pgboard.Game.CardDeck

  test "It could get plants info by id" do
    assert CardDeck.plant(3) == {2, :oil, 1}
    assert CardDeck.plant(50) == {0, :ecological, 6}
    assert CardDeck.plant(2) == nil
    assert CardDeck.plant(41) == nil
    assert CardDeck.plant(:step3) == nil
  end

  test "It could initialize a basic deck" do
    card_deck = CardDeck.basic_deck(4)

    assert Enum.count(card_deck) == 43 - 4
    assert Enum.take(card_deck, 9) == [3, 4, 5, 6, 7, 8, 9, 10, 13]
    assert List.last(card_deck) == :step3
    assert Enum.uniq(card_deck) == card_deck

    Enum.each card_deck, fn(card) ->
      cond do
        is_atom(card) -> assert card == :step3
        is_integer(card) -> assert(card >= 3 && card <= 50 && not(card in [41, 43, 45, 47, 48, 49]))
      end
    end
  end

  test "It could refill a plant market" do
    plant_market = %{
      available_market: [4, 5],
      future_market: [17, 23, 34, 45]
    }
    card_deck = [10, 18, :step3, 42, 35]
    board_cities =
      1..10
      |> Enum.map(fn(number) -> {"meow #{number}", [42, 24]} end)
      |> Enum.into(%{})

    {refilled_available_market, refilled_future_market, processed_card_deck} = CardDeck.refill_market(plant_market, card_deck, 5, 3, board_cities)

    assert refilled_available_market == [4, 5, 17, 18, 23]
    assert refilled_future_market == [34, 45, :step3]
    assert Enum.sort(processed_card_deck) == [35, 42]
  end
end
