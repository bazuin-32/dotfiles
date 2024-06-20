import { Window } from "resource:///com/github/Aylur/ags/widgets/window.js"
import { Bar } from "./bar/bar"
import { Menu } from "./menu/menu"

const hyprland = await Service.import("hyprland")

function forAllMonitors(fn: (i: number) => Window<any, any>) {
	return Array.from(
		{ length: hyprland.monitors.length },
		(_, i) => i
	).map(i => fn(i))
}

App.config({
	// one bar for each monitor
	windows: [
		...forAllMonitors(i => Bar(i)),
		...forAllMonitors(i => Menu(i))	
	],

	style: "./css/style.css"
})