defmodule Harvest.Repo.Migrations.CreateMiners do
  use Ecto.Migration

  def change do
    create table(:miners, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :ip, :string
      add :datetime, :utc_datetime
      add :timestamp, :integer

      add :make, :string
      add :model, :string
      add :firmware, :string
      add :algo, :string
      add :mac, :string

      add :hashrate, :float
      add :hashrate_unit, :integer

      add :temperature_avg, :integer
      add :total_chips, :integer

      add :is_mining, :boolean
      add :uptime, :integer

      add :primary_pool_url, :string
      add :primary_pool_user, :string
      add :accepted_shares, :integer
      add :rejected_shares, :integer

      timestamps()
    end

    create index(:miners, [:ip])
    create index(:miners, [:make, :model])

    # Create a unique constraint on mac address
    create unique_index(:miners, [:mac], name: :miners_mac_unique_index)
    create unique_index(:miners, [:ip], name: :miners_ip_unique_index)
  end
end
