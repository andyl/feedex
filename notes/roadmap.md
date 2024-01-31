# Feedex Roadmap 

Feedex2 Core 
- [ ] Feature: Feed reader (mobile and web) 
- [ ] Feature: Podcast player 
- [ ] Feature: LiveSAASKit Functions 
- [ ] Private code 
- [ ] Login / Email Confirmation 
- [ ] Mobile UI 
- [ ] Teams 

Feedex2 Stretch: ML 
- [ ] search 
- [ ] audio transcription 
- [ ] document chat 
- [ ] classification 

Feedex2 Stretch: Misc 
- [ ] Blog Authoring 
- [ ] PWA with client-side storage of shows 
- [ ] Documentation 
- [ ] Blog comments

Schemas and Forms 
- [ ] Use `sch` and `ctx` structure for data access components 
- [ ] Update forms 
- [ ] Update `core_components`(?)
- [ ] Add tests 

Long Term Fixes 
- [ ] Learn tailwind very well 
- [ ] Duplicate feed shows double-items in list 
- [ ] Add 'page-not-found' (post, folder, register | view, edit) 
- [ ] Use streams for post lists 
- [ ] JSON import/export stopwords 
- [ ] Clean up Feed import page 
- [ ] Optimize Formatting for mobile 

Features
- [ ] User accounts / auth / email confirmation 
- [ ] Simultaneous login count 
- [ ] Metrics: prometheus, loki, tempo 
- [ ] Full-text search 
- [ ] Mobile interface 
- [ ] Vim-style Keyboard mode 

Checklist 
- [ ] UI: Generate admin pages: users / feeds / posts 
- [ ] UI: Admin-links to Dashboard and Admin pages on settings page 
- [ ] UI: Admin-only access to admin pages 
- [ ] Infra: Restful API: RSS/JSON (Feeds and Folders) 
- [ ] Infra: Restful API: SyncNow (Feeds and Folders) 
- [ ] Infra: Restful API: Mark as Read (Feeds and Folders) 
- [ ] Infra: Webhook for each Feed and Channel 
- [ ] Infra: Metrics, Tracing (Jaeger), Logs (Loki) 
- [ ] Infra: Org & User, Permissions & Tokens, Login 
- [ ] Telemetry: Get grafana displays working 
- [ ] Telemetry: Get PromEx working 
- [ ] Telemetry: Number of logged-in users 
- [ ] Telemetry: Number of active sessions 

- [ ] keep existing auth code
- [ ] add DockerCompose script to rel project

- [ ] Feature: hide read articles
- [ ] Feature: star important articles
- [ ] Feature: search

- [ ] Feature: Add badge as runtime CFG

- [ ] Feature: Metrics / # of connected clients
- [ ] Feature: Metrics / # feeds, users

- [ ] Feature: Record Reads
- [ ] Feature: Record Clickthrus
- [ ] Feature: When visiting post, show the associated feeds
- [ ] Feature: add a highlight or star function

- [ ] Redeploy using feedex_rel
- [ ] Bug: not remembering post-click
- [ ] Auth directly thru LiveView in Mount (redirect to login)

- [ ] HOTKEYS: Table Nav up/down
- [ ] HOTKEYS: Folder/Feed Selection

- [ ] Backend: Reduce queries for FeedSync
- [ ] Backend: Reduce queries for Delete
- [ ] Backend: Why is Database Dropping Out?

- [ ] Add PushState
- [ ] Add ToolTips

- [ ] Split scrolling
- [ ] Expand scan-list for feedex_client

- [ ] TEST - unit - FeedexCore.Account
- [ ] TEST - intc - login/logout 
- [ ] TEST - intw - login/logout 
- [ ] TEST - clean up documentation
