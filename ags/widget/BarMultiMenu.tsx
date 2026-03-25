import { Gtk } from "ags/gtk4"

import Wireplumber from "gi://AstalWp"
import Network from "gi://AstalNetwork"

import {
	audio_icon,
	audio_volume,
	time,
	battery_percentage,
	battery_charging,
	battery_time_remaining,
	battery_icon,
	network_type,
	network_wired_icon,
	network_wired_internet,
	network_wifi_icon,
	network_wifi_ssid
} from "../utils/state"
import { createComputed } from "gnim"
import GLib from "gi://GLib?version=2.0"

const wireplumber = Wireplumber.get_default()

function BatteryIcon() {
	const tooltip = createComputed(() => {
		return battery_percentage() + "%, " + (
			Math.floor(battery_time_remaining() / 3600) + "h "
			+ Math.floor((battery_time_remaining() % 3600) / 60) + "m until "
			+ (battery_charging() ? "full" : "empty")
		)
	})

	return (
		<image
			cssClasses={["bar-icon"]}
			iconName={battery_icon}
			tooltipText={tooltip}
		/>
	)
}

const internetLookup: { [state: number ]: string } = {
}
internetLookup[Network.Internet.CONNECTED] = "Connected"
internetLookup[Network.Internet.CONNECTING] = "Connecting..."
internetLookup[Network.Internet.DISCONNECTED] = "Disconnected"

function NetworkIcon() {
	return (
		<box>
			<image
				cssClasses={["bar-icon"]}
				visible={network_type((type) => type == "wired")}
				iconName={network_wired_icon}
				tooltipText={network_wired_internet((int) => internetLookup[int])}
			/>
			<image 
				cssClasses={["bar-icon"]}
				visible={network_type((type) => type == "wifi")}
				iconName={network_wifi_icon}
				tooltipText={network_wifi_ssid}
			/>
		</box>
	)
}

function AudioIcon() {
	return (
		<image
			cssClasses={["bar-icon"]}
			iconName={audio_icon}
			tooltipText={audio_volume((n) => `${Math.floor(n * 100)}%`)}
		/>
	)
}

function StatusIcons() {
	return (
		<box>
			<BatteryIcon />
			<NetworkIcon />
			<AudioIcon />
		</box>
	)
}

function Clock() {
	return (
		<box tooltipText={time((dt) => dt.format("%A, %B %e") || "")}>
			<label label={time((dt) => dt.format("%l:%M %p") || "??:?? AM")} />
		</box>
	)
}

function BarMultiMenu() {
	return (
		<box>
			<button onClicked={() => console.log("menubutton")} cssClasses={["menubutton"]}>
				<box>
					<StatusIcons />
					<Clock />
				</box>
			</button>
		</box>
	)
}

export { BarMultiMenu }