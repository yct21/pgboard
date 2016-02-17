defmodule Pgboard.Game.Index do
  @moduledoc """
    This agent is used to store state of index page (all games not ended to let user pick to join or observe)

    state: {current_new_game_id, game_list}
    current_new_game_id: game id to be assigned if a new game is created now
    game_list: [games not started or started but not ended]
    game: %{id, map, status, has_password, current_player_amount, game_player_amount}
  """

  alias Pgboard.Repo
  alias Pgboard.Game
  import Ecto.Query

  # api
  def start_link do
    Agent.start_link(&(init_data/0), name: __MODULE__)
  end

  def game_list do
    Agent.get(__MODULE__, fn({_current_new_game_id, game_list}) -> game_list end)
  end

  def new_game(current_user, player_amount, map, has_password, password) do
    Agent.get_and_update(__MODULE__, fn({current_new_game_id, game_list}) ->
      current_game = %{
        id: current_new_game_id,
        map: map,
        status: :before_started,
        has_password: has_password,
        current_player_amount: 1,
        game_player_amount: player_amount
      }

      new_game_list = [current_game|game_list]

      if has_password do
        password_digest = Comeonin.Bcrypt.hashpwsalt(password)
      end

      new_state = {current_new_game_id+1, new_game_list}

      {{:ok, new_game_list}, new_state}
    end)
  end

  # def join_game(user, game_id) do
  #   Agent.get_and_update(__MODULE__, fn({_, game_list, password_list}) ->
  #
  #   )
  # end

  # private functions
  defp init_data do
    current_new_game_id = (Repo.one(from game in Pgboard.Game, select: max(game.id)) || -1) + 1
    games_not_ended = Repo.all(from g in Game, where: g.ended == false, preload: [:players])
    game_list = Enum.map(games_not_ended, &map_game_structure(&1))

    {current_new_game_id, game_list}
  end

  defp map_game_structure(game) do
    game_data = Poison.Parser.parse! game.current_state, keys: :atoms!

    %{
      id: game.id,
      map: game_data.map,
      status: game_data.status,
      has_password: game.has_password,
      current_player_amount: game_data.player_amount,
      game_player_amount: game_data.player_amount
    }
  end
end
