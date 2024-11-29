defmodule HarvestWeb.MinerControllerTest do
  use HarvestWeb.ConnCase

  import Harvest.MinersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all miners", %{conn: conn} do
      conn = get(conn, ~p"/miners")
      assert html_response(conn, 200) =~ "Listing Miners"
    end
  end

  describe "new miner" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/miners/new")
      assert html_response(conn, 200) =~ "New Miner"
    end
  end

  describe "create miner" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/miners", miner: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/miners/#{id}"

      conn = get(conn, ~p"/miners/#{id}")
      assert html_response(conn, 200) =~ "Miner #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/miners", miner: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Miner"
    end
  end

  describe "edit miner" do
    setup [:create_miner]

    test "renders form for editing chosen miner", %{conn: conn, miner: miner} do
      conn = get(conn, ~p"/miners/#{miner}/edit")
      assert html_response(conn, 200) =~ "Edit Miner"
    end
  end

  describe "update miner" do
    setup [:create_miner]

    test "redirects when data is valid", %{conn: conn, miner: miner} do
      conn = put(conn, ~p"/miners/#{miner}", miner: @update_attrs)
      assert redirected_to(conn) == ~p"/miners/#{miner}"

      conn = get(conn, ~p"/miners/#{miner}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, miner: miner} do
      conn = put(conn, ~p"/miners/#{miner}", miner: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Miner"
    end
  end

  describe "delete miner" do
    setup [:create_miner]

    test "deletes chosen miner", %{conn: conn, miner: miner} do
      conn = delete(conn, ~p"/miners/#{miner}")
      assert redirected_to(conn) == ~p"/miners"

      assert_error_sent 404, fn ->
        get(conn, ~p"/miners/#{miner}")
      end
    end
  end

  defp create_miner(_) do
    miner = miner_fixture()
    %{miner: miner}
  end
end
