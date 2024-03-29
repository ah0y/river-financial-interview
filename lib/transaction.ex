defmodule River.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :id)
    field(:date, :date)
    field(:tx_type, :string)
    # I did this because I discovered a bug in ecto during this assignment. Tracked here https://github.com/elixir-ecto/ecto/issues/3748. Vindicated by Jose himself
    field(:price, BetterDecimal, scale: 2)
    field(:quantity, BetterDecimal, scale: 8)
  end

  @required_fields ~w(id date tx_type price quantity)a
  @fields @required_fields ++ ~w()a

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:tx_type, ["buy", "sell"])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:quantity, greater_than: 0)
  end

  def new(params) do
    params
    |> changeset()
    |> apply_action!(:insert)
  end
end
