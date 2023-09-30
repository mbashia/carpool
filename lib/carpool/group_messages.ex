defmodule Carpool.Group_messages do
  @moduledoc """
  The Group_messages context.
  """

  import Ecto.Query, warn: false
  alias Carpool.Repo

  alias Carpool.Group_messages.Group_message

  @doc """
  Returns the list of group_messages.

  ## Examples

      iex> list_group_messages()
      [%Group_message{}, ...]

  """
  def list_group_messages do
    Repo.all(Group_message)
  end

  @doc """
  Gets a single group_message.

  Raises `Ecto.NoResultsError` if the Group message does not exist.

  ## Examples

      iex> get_group_message!(123)
      %Group_message{}

      iex> get_group_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_message!(id), do: Repo.get!(Group_message, id)

  @doc """
  Creates a group_message.

  ## Examples

      iex> create_group_message(%{field: value})
      {:ok, %Group_message{}}

      iex> create_group_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_message(attrs \\ %{}) do
    %Group_message{}
    |> Group_message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_message.

  ## Examples

      iex> update_group_message(group_message, %{field: new_value})
      {:ok, %Group_message{}}

      iex> update_group_message(group_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_message(%Group_message{} = group_message, attrs) do
    group_message
    |> Group_message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_message.

  ## Examples

      iex> delete_group_message(group_message)
      {:ok, %Group_message{}}

      iex> delete_group_message(group_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_message(%Group_message{} = group_message) do
    Repo.delete(group_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_message changes.

  ## Examples

      iex> change_group_message(group_message)
      %Ecto.Changeset{data: %Group_message{}}

  """
  def change_group_message(%Group_message{} = group_message, attrs \\ %{}) do
    Group_message.changeset(group_message, attrs)
  end
end
