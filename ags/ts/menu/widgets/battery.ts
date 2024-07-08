import { BatteryIndicator } from "ts/icons/battery"
import { Table } from "./table"

const battery = await Service.import("battery")

const BatteryLevel = () => Widget.Box({
    children: [
        BatteryIndicator(),
        Widget.Label({
            label: battery.bind("percent").as(p => `${p}%`)
        }),
        Widget.LevelBar({
            hexpand: true,
            value: battery.bind("percent").as(p => p / 100)
        })
    ]
})


//                                                       hours:minutes
const format_seconds = (s: number) => `${Math.floor(s / 3600)}:${(Math.round(s / 60) % 60).toString().padStart(2, "0")}`

const BatteryStats = () => Table([
    [
        "Time remaining",
        battery.bind("time_remaining").as((seconds) => format_seconds(seconds))
    ],
    [
        battery.bind("energy_rate").as(r => r < 0 ? "Current charge rate" : "Current discharge rate"),
        battery.bind("energy_rate").as(r => `${r} W`)
    ]
])


const BatteryPanel = () => Widget.Box({
    vertical: true,
    className: "battery-panel",
    children: [
        BatteryLevel(),
        BatteryStats()
    ]
})

export { BatteryPanel }