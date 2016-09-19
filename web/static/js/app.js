// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import {SystemIds} from "./system_ids"
let system_ids = new SystemIds([])

import {SystemIds as SystemIdsUI} from "./ui/system_ids"
let system_ids_ui = new SystemIdsUI(document.getElementById("system_ids"), system_ids)

let channel = socket.channel("smpp_connections:list", {})
channel.join()
    .receive("ok", resp => {
        system_ids.update(resp.system_ids)
        system_ids_ui.render()
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("system_ids_updated", payload => {
    system_ids.update(payload.system_ids)
    system_ids_ui.render()
})

