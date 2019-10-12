
import "bootstrap"
import css from "../css/app.scss"

import "phoenix_html"

// assets/js/app.js

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live", Socket, {})
liveSocket.connect()

