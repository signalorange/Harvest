defmodule Harvest.MinersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Harvest.Miners` context.
  """

  @doc """
  Generate a miner.
  """
  def miner_fixture(attrs \\ %{}) do
    {:ok, miner} =
      attrs
      |> Enum.into(%{

      })
      |> Harvest.Miners.create_miner()

    miner
  end
end
