defmodule HarvestWeb.MinerControllerImport do
  use HarvestWeb, :controller

  alias Harvest.Miners
  alias Harvest.Miners.Miner

  def import(conn, _params) do
    api_url = Application.get_env(:harvest, :miners_api_url)

    case Miners.fetch_miners_from_api(api_url) do
      {:ok, count} ->
        conn
        |> put_flash(:info, "Imported #{count} miners successfully")
        |> redirect(to: ~p"/miners")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Import failed: #{reason}")
        |> redirect(to: ~p"/miners")
    end
  end
end
