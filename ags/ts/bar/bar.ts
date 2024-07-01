import { LeftBox, CenterBox, RightBox } from "./widgets"

const BarWidget = (monitor: number) => Widget.CenterBox({
	className: "bar",
	hpack: "fill",
	startWidget: LeftBox(),
	centerWidget: CenterBox(),
	endWidget: RightBox(monitor)
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
	className: "bar-window",
    child: Widget.CenterBox({
		hpack: "fill",
		startWidget: BarMargin(),
		centerWidget: BarWidget(monitor),
		endWidget: BarMargin()
	})
})


export { Bar }