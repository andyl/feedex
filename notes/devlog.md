# Ragged Devlog

# 2019 Jul 27 Sat

- [x] Add ragged_web
- [x] Create ragged layout
- [x] Add ragged_client
- [x] Get ragged_client#get to return data
- [x] Get probe to work
- [x] Setup VCR for ragged_client
- [x] Setup VCR for ragged_client.url
- [x] Add ragged_data
- [x] Build first ragged_data tests
- [x] Add ragged_jobs

# 2019 Jul 30 Tue

- [x] Update RaggedData migration
- [x] Take "Mastering SQL" course
- [x] Read Ecto Book 
- [x] Add ecto-data contexts

# 2019 Jul 31 Wed

- [x] Build Account schemas
- [x] Add tests for Account schemas
- [x] Build seed-data function
- [x] Build News schemas
- [x] Add tests for News schemas
- [x] Add factories for News schemas
- [x] Design UI
- [x] Design News Context
- [x] Design Account Context
- [x] Build Account Context
- [x] Test Account Context
- [x] Build News Context
- [x] Test News Context
- [x] Add RaggedJobs.scan(url)
- [x] Add RaggedJobs.update(url)
- [x] Add RaggedRunner
- [x] Add RaggedRunner.start()
- [x] Add RaggedRunner.stop()
- [x] Add RaggedRunner.config_show()
- [x] Add RaggedRunner.config_update()
- [x] Add News page
- [x] Update ragged nav

# 2019 Aug 01 Thu

- [x] Make sure we generate a pwd_hash in the factory
- [x] Add a clear script
- [x] Add Accounts.create_user
- [x] Add login / logout (Phoenix Book)
- [x] Add current_user (AuthPlug Phoenix Book)
- [x] Study testing

# 2019 Aug 02 Fri

- [x] LV - DO / Add second clock to demo page
- [x] LV - Basics / Router Rendering
- [x] LV - Basics / Controller Rendering (live_render)
- [x] LV - Basics / Tag Rendering (live_render)
- [x] LV - PSP / Using PubSub
- [x] LV - PSP / Using Channels
- [x] LV - Misc / What is `handle_info`?
- [x] Study LiveView

# 2019 Aug 03 Sat

- [x] Build LV PubSub demo
- [x] Change news to normal render

# 2019 Aug 07 Wed

- [x] Configure Webpack
- [x] Create `Live.News.Btn`
- [x] Create `Live.News.Tree`
- [x] Create `Live.News.Hdr`
- [x] Create `Live.News.Body`
- [x] Demo Nested Components
- [x] Demo Nested Component PubSub

# 2019 Aug 08 Thu

- [x] Add Pets
- [x] Define Pets testing process
- [x] Refactor Pets

# 2019 Aug 09 Fri

- [x] Add UI state
- [x] Build ShowUiState component
- [x] Add ShowUiState component to body

# 2019 Aug 10 Sat

- [x] Fix Pets config (testing)
- [x] Add Auth to news page

# 2019 Aug 11 Sun

- [x] Click Buttons to update UiState

# 2019 Aug 12 Mon

- [x] Create treemap query 
- [x] Add treemap to controller
- [x] Generate test tree data

# 2019 Aug 13 Tue

- [x] Add treemap to TREE/HDR/BODY
- [x] Display test trees in TREE/HDR/BODY
- [x] Click tree updates UIstate

# 2019 Aug 13 Wed

- [x] Ecto Testing

# 2019 Aug 30 Fri

- [x] HDR display: folder
- [x] HDR display: feed

# 2019 Sep 07 Sat

- [x] BASE: add scheme for caching UISTATE (uistate digest)
- [x] BASE: convert news to liveview
- [x] BODY display: folder
- [x] BODY display: feed
- [x] BODY display: all
- [x] Add view layout for editing folders and feedds

# 2019 Sep 08 Sun

Editing Design Notes:
- copy form technique from purlex
- a feed must be in a folder
- there always has to be one folder
- a folder can't be deleted if it contains a feed

- [x] Add Folder
- [x] Add Feed
- [x] Edit Folder
- [x] Edit Feed

# 2019 Sep 09 Mon

- [x] Setup seeds with real URLs
- [x] Create `RaggedJob.sync`
- [x] Import live posts
- [x] Add manual sync button for feed
- [x] VIEWING: View post
- [x] Posts: sort descending
- [x] Posts: toggle show/hide
- [x] Posts: add text link

# 2019 Sep 10 Tue

- [x] VIEWING: Update post-read status
- [x] VIEWING: Index the read_list

# 2019 Sep 11 Wed

- [x] QUERY: posts with read: true/false column by register
- [x] QUERY: posts with read: true/false column by folder
- [x] QUERY: posts with read: true/false column by all
- [x] VIEWING: Highlight unread rows
- [x] Sync now button
- [x] Periodic sync (quantum/cron)
- [x] Display update times (1m, 2h, 3d, 4w)
- [x] Refactor readlog
- [x] QUERY: count of unread by register
- [x] QUERY: count of unread by folder
- [x] QUERY: count of unread by all
- [x] Show unread counts in tree
- [x] Mark all (pst/reg/fld/all)
- [x] Sync all (pst/reg/fld/all)
- [x] Deploy production
- [x] Install systemD

# 2019 Sep 12 Thu

- [x] Admin: Delete folder
- [x] Add cascade deletes
- [x] Fix feed sync
- [x] Admin: Delete feed

# 2019 Sep 15 Sun

- [x] Write LiveEditable
- [x] Admin: Rename folder
- [x] Admin: Rename feed

# 2019 Sep 16 Mon

- [x] Add link to RSS url
- [x] Reverse Feed List before loading
- [x] No Links for active AddFolder
- [x] No Links for active AddFeed
- [x] Optimize Tree Query
- [x] Fix Broken Feeds (ExStatus, ExJobs)
- [x] Mobile: Fix Menu Dropdown
- [x] Mobile: Mobile Btn & Tree Divs

# 2019 Sep 17 Tue

- [ ] Fix uistate sync

| Action                      | Channel   | From      | To             |
|-----------------------------|-----------|-----------|----------------|
| when sync job updates       | poststate | JobRunner | bodyview, tree |
| when post is viewed         | poststate | bodyview  | tree           |
| when folder/feed is added   | treecount | addui     | tree, body     |
| when folder/feed is removed | treecount | remui     | tree, body     |
| when folder/feed is renamed | treebase  | editui    | tree, hdr      |

- [ ] Print: print record of feeds as yaml

# TBD

- [ ] Schema: Add `WebUrl` to `Resource`
- [ ] Schema: Add `LoadOrder` (forward|reverse) to `Feed`

- [ ] Move system to datacenter

- [ ] LiveEditable: Add Select Function
- [ ] Admin: Move feed to a different folder

- [ ] HOTKEYS: Table Nav up/down
- [ ] HOTKEYS: Folder/Feed Selection

- [ ] Backend: Reduce queries for FeedSync
- [ ] Backend: Why is Database Dropping Out?

- [ ] Add PushState
- [ ] Add ToolTips

- [ ] Split scrolling
- [ ] Expand scan-list for ragged_client

- [ ] LiveEditable: Get Validations Working
- [ ] LiveEditable: Add RadioButton Field
- [ ] LiveEditable: Create `Editable` Behavior
- [ ] LiveEditable: Implement `HTML` Editable 
- [ ] LiveEditable: Implement `Bootstrap4` Editable 
- [ ] LiveEditable: Implement `Milligram` Editable 
- [ ] LiveEditable: ExUnit Shared Examples for HTML, Bootstrap4 and Milligram
- [ ] LiveEditable: Create Developer Website (and serve CSS/JS Assets)
- [ ] LiveEditable: Create Demo Application (Swap Between CSS Frameworks)
- [ ] LiveEditable: Change to PhoenixLiveEditable

- [ ] TEST - unit - RaggedData.Account
- [ ] TEST - intc - login/logout 
- [ ] TEST - intw - login/logout 
- [ ] TEST - clean up documentation
