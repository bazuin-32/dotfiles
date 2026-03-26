import GLib from "gi://GLib?version=2.0"

import Hyprland from "gi://AstalHyprland"
import Tray from "gi://AstalTray"
import Wireplumber from "gi://AstalWp"
import Battery from "gi://AstalBattery"
import Network from "gi://AstalNetwork"

import { createState, createMemo, Accessor, Setter } from "ags"
import { createPoll } from "ags/time"

const hyprland = Hyprland.get_default()

const [workspaces, set_workspaces] = createState(
  hyprland.get_workspaces()
    .filter(ws => ws.id > 0)
    .sort((a, b) => a.id - b.id)
)
const [active_workspace_id, set_active_workspace_id] = createState(hyprland.get_focused_workspace()?.id ?? -1)

hyprland.connect("notify::focused-workspace", () => {
  const f = hyprland.get_focused_workspace()
  set_active_workspace_id(f?.id ?? -1)
})

hyprland.connect("notify::workspaces", () => {
  set_workspaces(
    hyprland.get_workspaces()
      .filter(ws => ws.id > 0)
      .sort((a, b) => a.id - b.id)
  )
})

const workspaces_with_active = createMemo(
  () => workspaces().map(w => ({ id: w.id, isActive: w.id === active_workspace_id() }))
)

const [window_title, set_window_title] = createState(hyprland.get_focused_client().title)


// make sure values update when events occur
hyprland.connect("notify::focused-workspace", () => {
  const f = hyprland.get_focused_workspace()
  set_active_workspace_id(f?.id ?? -1)
})

hyprland.connect("notify::workspaces", () => {
  set_workspaces(
    hyprland.get_workspaces()
      .filter(ws => ws.id > 0)
      .sort((a, b) => a.id - b.id)
  )
})

hyprland.connect("notify::focused-client", () => {
  const focused_client = hyprland.get_focused_client()
  if (focused_client) {
    set_window_title(focused_client.title)
  }
})



const tray = Tray.get_default()

const [tray_items, set_tray_items] = createState(tray.get_items())
tray.connect("notify::items", () => {
  set_tray_items(tray.get_items())
})


const time = createPoll(GLib.DateTime.new_now_local(), 1000, () => GLib.DateTime.new_now_local())


const wireplumber = Wireplumber.get_default()

const [audio_icon, set_audio_icon] = createState(wireplumber.default_speaker.volume_icon)
wireplumber.default_speaker.connect("notify::volume-icon", () => {
  set_audio_icon(wireplumber.default_speaker.volume_icon)
})

const [audio_volume, set_audio_volume] = createState(wireplumber.default_speaker.volume)
wireplumber.default_speaker.connect("notify::volume", () => {
  set_audio_volume(wireplumber.default_speaker.volume)
})

wireplumber.connect("ready", () => {
  set_audio_icon(wireplumber.default_speaker.volume_icon)
  set_audio_volume(wireplumber.default_speaker.volume)
})



const battery = Battery.get_default()
const [battery_present, set_battery_present] = createState(battery.is_present)
battery.connect("notify::is-present", () => {
  set_battery_present(battery.is_present)
})

const [battery_percentage, set_battery_percentage] = createState(Math.floor(battery.percentage * 100))
battery.connect("notify::percentage", () => {
  set_battery_percentage(Math.floor(battery.percentage * 100))
})

const [battery_icon, set_battery_icon] = createState(battery.battery_icon_name)
battery.connect("notify::battery-icon-name", () => {
  set_battery_icon(battery.battery_icon_name)
})

const [battery_charging, set_battery_charging] = createState(battery.charging)
battery.connect("notify::charging", () => {
  set_battery_charging(battery.charging)
})

const [battery_time_remaining, set_battery_time_remaining] = createState(battery.time_to_empty)
battery.connect("notify::time-to-empty", () => {
  if (! battery.charging) {
    set_battery_time_remaining(battery.time_to_empty)
  }
})
battery.connect("notify::time-to-full", () => {
  if (battery.charging) {
    set_battery_time_remaining(battery.time_to_full)
  }
})


const network = Network.get_default()
const [network_type, set_network_type] = createState(network.wired.state == Network.DeviceState.ACTIVATED ? "wired" : "wifi")
network.wired.connect("notify::state", () => {
  set_network_type(network.wired.state == Network.DeviceState.ACTIVATED ? "wired" : "wifi")
})

const [network_wired_icon, set_network_wired_icon] = createState(network.wired.icon_name)
network.wired.connect("notify::icon-name", () => {
  set_network_wired_icon(network.wired.icon_name)
})

const [network_wired_internet, set_network_wired_internet] = createState(network.wired.internet)
network.wired.connect("notify::internet", () => {
  set_network_wired_internet(network.wired.internet)
})

let network_wifi_icon: string | Accessor<string>
let network_wifi_ssid: string | Accessor<string>
if (network.wifi) {
  let set_network_wifi_icon: Setter<string>
  [network_wifi_icon, set_network_wifi_icon] = createState(network.wifi.icon_name)
  network.wifi.connect("notify::icon-name", () => {
    set_network_wifi_icon(network.wifi.icon_name)
  })

  let set_network_wifi_ssid: Setter<string>
  [network_wifi_ssid, set_network_wifi_ssid] = createState(network.wifi.ssid)
  network.wifi.connect("notify::ssid", () => {
    set_network_wifi_ssid(network.wifi.ssid)
  })
} else {
  network_wifi_icon = "";
  network_wifi_ssid = "";
}



export {
  workspaces,
  active_workspace_id,
  workspaces_with_active,

  window_title,

  tray_items,
  time,

  audio_icon,
  audio_volume,

  battery_present,
  battery_percentage,
  battery_icon,
  battery_charging,
  battery_time_remaining,

  network_type,
  network_wired_icon,
  network_wired_internet,
  network_wifi_icon,
  network_wifi_ssid
}