defmodule CityGameBackend.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias CityGameBackend.Repo

  alias CityGameBackend.Games.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end

  alias CityGameBackend.Games.Waypoint

  @doc """
  Returns the list of waypoints of the selected game.

  ## Examples

      iex> list_waypoints(1)
      [%Waypoint{}, ...]

  """
  def list_waypoints(game_id) do
    from(
      Waypoint,
      where: [game_id: ^game_id]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single waypoint.

  Raises `Ecto.NoResultsError` if the Waypoint does not exist.

  ## Examples

      iex> get_waypoint!(123)
      %Waypoint{}

      iex> get_waypoint!(456)
      ** (Ecto.NoResultsError)

  """
  def get_waypoint!(id), do: Repo.get!(Waypoint, id)

  @doc """
  Creates a waypoint.

  ## Examples

      iex> create_waypoint(%{field: value})
      {:ok, %Waypoint{}}

      iex> create_waypoint(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_waypoint(attrs \\ %{}) do
    %Waypoint{}
    |> Waypoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Waypoint.

  ## Examples

      iex> delete_waypoint(waypoint)
      {:ok, %Waypoint{}}

      iex> delete_waypoint(waypoint)
      {:error, %Ecto.Changeset{}}

  """
  def delete_waypoint(%Waypoint{} = waypoint) do
    Repo.delete(waypoint)
  end
end
