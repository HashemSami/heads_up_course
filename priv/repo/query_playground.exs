alias HeadsUp.Repo
# alias HeadsUp.Incidents
alias HeadsUp.Incidents.Incident
import Ecto.Query

Incident
|> where(status: :pending)
# |> where([i], i.id != ^incident.id)
|> order_by(:priority)
|> Repo.all()
|> IO.inspect()
