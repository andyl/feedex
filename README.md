# Ragged

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
- `MIX_ENV=prod mix do deps.get, ecto.create, ecto.migrate, distillery.release`
- Start the release
- Browse to `locahost:5070`

## Using SystemD

Create the database and run the migrations.  Then:

- edit the SystemD service file in `rel/ragged.service`
- `sudo cp rel/ragged.service /etc/systemd/system`
- `sudo chmod 644 /etc/systemd/system/ragged.service`

Start the service with SystemD

- `sudo systemctl start ragged`
- `sudo systemctl status ragged`
- `sudo systemctl restart ragged`
- `sudo systemctl stop ragged`
- `sudo journalctl -u ragged -f`

Make sure your service starts when the system reboots

- `sudo systemctl enable ragged`

Reboot and test!


