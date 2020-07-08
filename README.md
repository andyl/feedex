# Feedex

Simple RSS Aggregator

- multi-user
- periodic feed sync
- web-ui

## System requirements

- Ubuntu Host running 18.04
- SystemD
- Postgres (user/pass = postgres/postgres)

## Installing

- Clone the repo
- `cd apps/feedex_web/assets && npm install`
- `mix deps.get && phx.digest`
- `MIX_ENV=prod mix do phx.digest, ecto.setup, distillery.release`
- Start the release
- Browse to `locahost:5070`

## Using SystemD

Create the database and run the migrations.  Then:

- edit the SystemD service file in `rel/feedex.service`
- `sudo cp rel/feedex.service /etc/systemd/system`
- `sudo chmod 644 /etc/systemd/system/feedex.service`

Start the service with SystemD

- `sudo systemctl start feedex`
- `sudo systemctl status feedex`
- `sudo systemctl restart feedex`
- `sudo systemctl stop feedex`
- `sudo journalctl -u feedex -f`

Make sure your service starts when the system reboots

- `sudo systemctl enable feedex`

Reboot and test!


