defmodule HeadsUp.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :status, :string
      add :note, :string
      add :incident_id, references(:incidents, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:responses, [:user_id])

    create index(:responses, [:incident_id])
  end
end
