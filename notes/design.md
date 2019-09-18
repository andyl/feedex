# Ragged Design Notes

## Applications

| APP             | Generator                | Purpose                 |
|-----------------|--------------------------|-------------------------|
| x ragged_client | mix new ragged_client    | HTML Client - Reads RSS |
| x ragged_data   | new.phx.ecto ragged_data | Ecto Interface          |
| x ragged_job    | mix new ragged_job       | Scheduled RSS Sync Jobs |
| x ragged_web    | new.phx.web ragged_web   | Web UI                  |
| - ragged_term   | mix new ragged_term      | Terminal UI             |
| - ragged_api    | new.phx.web ragged_api   | GraphQL API             |

## Schema

User > Folder > Register < Feed < Post

ReadLog 

- ReadLog: one record for every read post 
- each ReadLog record contains: `id, user_id, folder_id, register_id, post_id`

Key API Calls:

- build tree with aggregate unread-count (register/folder/all)
- list posts with read-status (register/folder/all)
- mark as read (post/register/folder/all)
- sync feed (register/folder/all)

## 3rd-Party Tooling

| App          | Tool             | Purpose                  |
|--------------|------------------|--------------------------|
| RaggedClient | ElixirFeedParser | RSS Parsing              |
| RaggedJob    | Oban             | Background Job Runner    |
| RaggedJob    | Quantum          | Cron-like Job Scheduling |
| RaggedWeb    | LiveView         | Dynamic UI               |
| RaggedWeb    | Pets             | ETS Caching              |

## Persistence

RaggedData uses Postgres with the standard Ecto tooling.

RaggedWeb caches UiState in ETS tables backed by files on disk. 

## UiState

Purpose:

- core to RaggedWeb LiveView
- backed by PersistentETS
- used by PushState

| Field  | Description | Type       |
|--------|-------------|------------|
| usr_id | User ID     | integer    |
| fld_id | Folder ID   | integer    |
| reg_id | Register ID | integer    |
| pst_id | Post ID     | integer    |
| mode   | UI MODE     | enumerated |

Valid Modes:
- view
- add_feed
- add_folder
- edit_feed
- edit_folder

Notes:
- nav tree always sorted alphabetically
- nav folders always open
- fld_id and reg_id can be blank - both can't be filled at once

## Ui PubSub

| Action                      | Event       | From      | To              |
|-----------------------------|-------------|-----------|-----------------|
| when post is viewed         | read_one    | bodyview  | tree            |
| when "read all" is pressed  | read_all    | hdr       | bodyview, tree  |
| when sync job updated       | read_all    | JobRunner | bodyview, tree  |
| when folder/feed is added   | tree_mod    | addui     | tree, body      |
| when folder/feed is removed | tree_mod    | remui     | tree, body      |
| when folder/feed is renamed | tree_mod    | editui    | tree, hdr       |
| clicking on btn             | set_uistate | btn       | hdr, tree, body |
| clicking on tree            | set_uistate | tree      | btn, hdr, body  |
| clicking on edit            | set_uistate | hdr       | btn, hdr, body  |
