import { BatteryIndicator } from "ts/icons/battery"

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

const BatteryStatsLeft = () => Widget.Box({
    vertical: true,
    hpack: "start",
    children: [
        Widget.Label({
            label: "Time remaining",
            hpack: "start"
        }),
        Widget.Label({
            label: battery.bind("energy_rate").as(r => r < 0 ? "Current charge rate" : "Current discharge rate"),
            hpack: "start"
        })
    ]
})


//                                                       hours:minutes
const format_seconds = (s: number) => `${Math.floor(s / 3600)}:${(Math.round(s / 60) % 60).toString().padStart(2, "0")}`
const BatteryStatsRight = () => Widget.Box({
    vertical: true,
    hpack: "end",
    children: [
        Widget.Label({
            label: battery.bind("time_remaining").as((seconds) => format_seconds(seconds)),
            hpack: "end"
        }),
        Widget.Label({
            label: battery.bind("energy_rate").as(r => `${r} W`),
            hpack: "end"
        })
    ]
})

const BatteryStats = () => Widget.CenterBox({
    startWidget: BatteryStatsLeft(),
    endWidget: BatteryStatsRight()
})


const BatteryPanel = () => Widget.Box({
    vertical: true,
    className: "battery-panel",
    children: [
        BatteryLevel(),
        BatteryStats()
    ]
})

export { BatteryPanel }