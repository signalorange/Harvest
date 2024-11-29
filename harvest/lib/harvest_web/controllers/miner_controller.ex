defmodule HarvestWeb.MinerController do
  use HarvestWeb, :controller

  alias Harvest.Miners
  alias Harvest.Miners.Miner

  def index(conn, _params) do
    miners = Miners.list_miners()
    render(conn, :index, miners: miners)
  end

end
