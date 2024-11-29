defmodule Harvest.MinersTest do
  use Harvest.DataCase

  alias Harvest.Miners

  describe "miners" do
    alias Harvest.Miners.Miner

    import Harvest.MinersFixtures

    @invalid_attrs %{}

    test "list_miners/0 returns all miners" do
      miner = miner_fixture()
      assert Miners.list_miners() == [miner]
    end

    test "get_miner!/1 returns the miner with given id" do
      miner = miner_fixture()
      assert Miners.get_miner!(miner.id) == miner
    end

    test "create_miner/1 with valid data creates a miner" do
      valid_attrs = %{}

      assert {:ok, %Miner{} = miner} = Miners.create_miner(valid_attrs)
    end

    test "create_miner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Miners.create_miner(@invalid_attrs)
    end

    test "update_miner/2 with valid data updates the miner" do
      miner = miner_fixture()
      update_attrs = %{}

      assert {:ok, %Miner{} = miner} = Miners.update_miner(miner, update_attrs)
    end

    test "update_miner/2 with invalid data returns error changeset" do
      miner = miner_fixture()
      assert {:error, %Ecto.Changeset{}} = Miners.update_miner(miner, @invalid_attrs)
      assert miner == Miners.get_miner!(miner.id)
    end

    test "delete_miner/1 deletes the miner" do
      miner = miner_fixture()
      assert {:ok, %Miner{}} = Miners.delete_miner(miner)
      assert_raise Ecto.NoResultsError, fn -> Miners.get_miner!(miner.id) end
    end

    test "change_miner/1 returns a miner changeset" do
      miner = miner_fixture()
      assert %Ecto.Changeset{} = Miners.change_miner(miner)
    end
  end
end
