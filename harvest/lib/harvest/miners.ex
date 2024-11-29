defmodule Harvest.Miners do
  import Ecto.Query, warn: false
  import Logger
  alias Harvest.Repo
  alias Harvest.Miners.Miner

  # Existing list_miners function
  def list_miners do
    Repo.all(Miner)
  end

  def get_miner!(id) do
    Repo.get!(Miner, id)
  end

  # Function to fetch miners from API
  def fetch_miners_from_api(api_url, opts \\ []) do
    # Configure Finch request
    headers = Keyword.get(opts, :headers, [])
    timeout = Keyword.get(opts, :timeout, 10_000)

    case Finch.build(:get, api_url, headers)
         |> Finch.request(Harvest.Finch, receive_timeout: timeout) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, miners_data} ->
            import_from_api_data(miners_data)
          {:error, _} ->
            {:error, "Failed to parse JSON response"}
        end

      {:ok, %Finch.Response{status: status}} ->
        {:error, "API returned non-200 status code: #{status}"}

      {:error, reason} ->
        {:error, "Failed to fetch miners: #{inspect(reason)}"}
    end
  end

  # Import data from API response
  defp import_from_api_data(miners_data) when is_list(miners_data) do
    # Transform API data into importable format
    importable_data = Enum.map(miners_data, fn miner_data ->
      %{
        ip: miner_data["ip"],
        datetime: DateTime.truncate(parse_datetime(miner_data["datetime"]), :second),
        timestamp: miner_data["timestamp"],

        make: miner_data["make"],
        model: miner_data["model"],
        firmware: miner_data["firmware"],
        algo: miner_data["algo"],
        mac: miner_data["mac"],

        hashrate: get_in(miner_data, ["hashrate", "rate"]),
        #hashrate_unit: get_in(miner_data, ["hashrate", "unit"]),

        temperature_avg: miner_data["temperature_avg"],
        total_chips: miner_data["total_chips"],

        is_mining: miner_data["is_mining"],
        uptime: miner_data["uptime"],

        primary_pool_url: get_in(miner_data, ["pools", Access.at(0), "url", "host"]),
        primary_pool_user: get_in(miner_data, ["pools", Access.at(0), "user"]),
        accepted_shares: get_in(miner_data, ["pools", Access.at(0), "accepted"]),
        rejected_shares: get_in(miner_data, ["pools", Access.at(0), "rejected"])

        #inserted_at: NaiveDateTime.utc_now(),
        #updated_at: NaiveDateTime.utc_now()
      }
    end)

  # Try to insert, handling potential conflicts
  results = Enum.map(importable_data, fn miner_data ->
    Repo.insert(struct(Miner, miner_data))
  end)

  # Count successful insertions
  successful_count = Enum.count(results, fn
    {:ok, _} -> true
    _ -> false
  end)

  {:ok, successful_count}
  rescue
    Ecto.ConstraintError -> {:error, "Duplicate IP or MAC address found"}
  end

  # Fallback for non-list data
  defp import_from_api_data(_), do: {:error, "Invalid data format"}

  # Parse datetime with error handling
  defp parse_datetime(datetime_str) do
    case DateTime.from_iso8601(datetime_str) do
      {:ok, datetime, _} -> datetime
      _ -> nil
    end
  end

  # Schedule periodic sync (optional)
  def sync_miners do
    api_url = Application.get_env(:harvest, :miners_api_url)

    case fetch_miners_from_api(api_url) do
      {:ok, count} ->
        Logger.info("Successfully synced #{count} miners")
      {:error, reason} ->
        Logger.error("Miner sync failed: #{reason}")
    end
  end
end
