defmodule HarvestWeb.MinerHTML do
  use HarvestWeb, :html

  embed_templates "miner_html/*"

  @doc """
  Renders a miner form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def miner_form(assigns)
end
