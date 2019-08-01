# Ragged Design Notes

## Applications

| APP             | Generator                | Purpose              |
|-----------------|--------------------------|----------------------|
| - ragged_api    | new.phx.web ragged_api   | GraphQL API          |
| x ragged_client | mix new ragged_client    | HTML Client          |
| x ragged_data   | new.phx.ecto ragged_data | Ecto Interface       |
| x ragged_job    | mix new ragged_job       | RSS Update Jobs      |
| x ragged_runner | mix new ragged_runner    | Job Scheduler/Runner |
| - ragged_term   | mix new ragged_term      | Terminal UI          |
| x ragged_web    | new.phx.web ragged_web   | Web UI               |

## RaggedJob Scheduler

- each feed has "last update" field
- job scheduler has "job frequency"

- sort by "last_update"
- filter by "max_update_frequency"
- cap by "max_concurrent_updates"

- feed updates all users who reference the feed

## ERD

```
User -< Folder -< FeedLog >-< Feed -< Post
```

Account: User / Folder / FeedLog
News: Feed / Post

## API

- User.Folders(user)
- Folder.UnreadCounts(folder)
- FeedLog.UnreadCount
