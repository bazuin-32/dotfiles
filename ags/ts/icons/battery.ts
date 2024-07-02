const battery = await Service.import('battery')

//                                                       hours:minutes
const format_seconds = (s: number) => `${Math.floor(s / 3600)}:${(Math.round(s / 60) % 60).toString().padStart(2, "0")}`
const BatteryIndicator = () => Widget.Icon({
    icon: battery.bind("icon_name"),
    visible: battery.bind('available'),
    className: "status-icon",
    tooltipText: Utils.merge(
        [battery.bind("percent"), battery.bind("time_remaining"), battery.bind("charging")],
        (pct, seconds, charging) => `${pct}% (${format_seconds(seconds)} ${charging ? "until full" : "remaining"})`
    )
})

export { BatteryIndicator }