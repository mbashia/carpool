defmodule Carpool.Group_members do
  @moduledoc """
  The Group_members context.
  """

  import Ecto.Query, warn: false
  alias Carpool.Repo

  alias Carpool.Group_members.Group_member

  @doc """
  Returns the list of group_members.

  ## Examples

      iex> list_group_members()
      [%Group_member{}, ...]

  """
  def list_group_members do
    Repo.all(Group_member)
  end

  @doc """
  Gets a single group_member.

  Raises `Ecto.NoResultsError` if the Group member does not exist.

  ## Examples

      iex> get_group_member!(123)
      %Group_member{}

      iex> get_group_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_member!(id), do: Repo.get!(Group_member, id)

  @doc """
  Creates a group_member.

  ## Examples

      iex> create_group_member(%{field: value})
      {:ok, %Group_member{}}

      iex> create_group_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_member(attrs \\ %{}) do
    %Group_member{}
    |> Group_member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_member.

  ## Examples

      iex> update_group_member(group_member, %{field: new_value})
      {:ok, %Group_member{}}

      iex> update_group_member(group_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_member(%Group_member{} = group_member, attrs) do
    group_member
    |> Group_member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_member.

  ## Examples

      iex> delete_group_member(group_member)
      {:ok, %Group_member{}}

      iex> delete_group_member(group_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_member(%Group_member{} = group_member) do
    Repo.delete(group_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_member changes.

  ## Examples

      iex> change_group_member(group_member)
      %Ecto.Changeset{data: %Group_member{}}

  """
  def change_group_member(%Group_member{} = group_member, attrs \\ %{}) do
    Group_member.changeset(group_member, attrs)
  end
end
