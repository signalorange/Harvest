# lib/harvest/miners/miner.ex
defmodule Harvest.Miners.Miner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "miners" do
    field :ip, :string
    field :datetime, :utc_datetime
    field :timestamp, :integer

    # Device Info
    field :make, :string
    field :model, :string
    field :firmware, :string
    field :algo, :string
    field :mac, :string

    # Hashrate
    field :hashrate, :float
    field :hashrate_unit, :integer

    # Temperature and Performance
    field :temperature_avg, :integer
    field :total_chips, :integer

    # Mining Status
    field :is_mining, :boolean
    field :uptime, :integer

    # Pool Information
    field :primary_pool_url, :string
    field :primary_pool_user, :string
    field :accepted_shares, :integer
    field :rejected_shares, :integer

    timestamps()
  end

  def changeset(miner, attrs) do
    miner
    |> cast(attrs, [
      :ip, :datetime, :timestamp,
      :make, :model, :firmware, :algo, :mac,
      :hashrate, :hashrate_unit,
      :temperature_avg, :total_chips,
      :is_mining, :uptime,
      :primary_pool_url, :primary_pool_user,
      :accepted_shares, :rejected_shares
    ])
    |> validate_required([:ip, :make, :model])
  end
end
