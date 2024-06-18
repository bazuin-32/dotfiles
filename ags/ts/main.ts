import * as widgets from "./widgets"

const BarWidget = () => Widget.CenterBox({
	className: "bar",
	hpack: "fill",
	startWidget: widgets.LeftBox(),
	centerWidget: widgets.CenterBox(),
	endWidget: widgets.RightBox()
})

const BarMargin = () => Widget.Box({
	className: "bar-margin",
	hexpand: false,
	hpack: "start"
})

const Bar = (monitor: number) => Widget.Window({
	monitor: monitor,
    name: `bar${monitor}`,
    anchor: ["top", "left", "right"],
	exclusivity: "exclusive",
	hexpand: true,
	className: "bar-window",
    child: Widget.CenterBox({
		hpack: "fill",
		startWidget: BarMargin(),
		centerWidget: BarWidget(),
		endWidget: BarMargin()
	})
})


const hyprland = await Service.import("hyprland")

App.config({
	// one bar for each monitor
	windows: Array.from(
		{ length: hyprland.monitors.length },
		(_, i) => i
	).map(i => Bar(i)),

	style: "./css/style.css"
})