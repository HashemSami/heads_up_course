defmodule HeadsUp.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :status, Ecto.Enum, values: [:enroute, :arrived, :departed]
    field :note, :string

    belongs_to :incident, HeadsUp.Incidents.Incident
    belongs_to :user, HeadsUp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs, user_scope) do
    response
    |> cast(attrs, [:status, :note])
    |> validate_required([:status])
    |> put_change(:user_id, user_scope.user.id)
    |> validate_length(:note, max: 100)
    |> assoc_constraint(:user)
    |> assoc_constraint(:incident)
  end
end
