# Ragged Design Notes

| APP             | Generator                | Purpose              |
|-----------------|--------------------------|----------------------|
| - ragged_api    | new.phx.web ragged_api   | GraphQL API          |
| + ragged_client | mix new ragged_client    | HTML Client          |
| + ragged_data   | new.phx.ecto ragged_data | Ecto Interface       |
| + ragged_job    | mix new ragged_job       | Job Scheduler/Runner |
| - ragged_term   | mix new ragged_term      | Terminal UI          |
| + ragged_web    | new.phx.web ragged_web   | Web UI               |
