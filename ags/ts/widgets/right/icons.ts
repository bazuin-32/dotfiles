const audio = await Service.import('audio')

const VolumeIndicator = () => Widget.Icon({
    className: "status-icon",
}).hook(audio.speaker, self => {
    const vol = audio.speaker.volume * 100;
    const icon = audio.speaker.is_muted ? "muted" : [
        [101, 'overamplified'],
        [67, 'high'],
        [34, 'medium'],
        [1, 'low'],
        [0, 'muted'],
    ].find(([threshold]) => +threshold <= vol)?.[1]; // use `+threshold` because ts thinks the type is `string | number` and then complains

    self.icon = `audio-volume-${icon}-symbolic`;
    self.tooltip_text = `Volume ${Math.floor(vol)}%` + (
        audio.speaker.is_muted ? " (muted)" : ""
    );
})

const network = await Service.import('network')

const WifiIndicator = () => Widget.Icon({
    icon: network.wifi.bind('icon_name'),
    tooltipText: network.wifi.bind("ssid").as(ssid => ssid || "Unknown")
})

const WiredIndicator = () => Widget.Icon({
    icon: network.wired.bind('icon_name'),
    tooltipText: network.wired.bind("internet")
})

const NetworkIndicator = () => Widget.Stack({
    className: "status-icon",
    children: {
        wifi: WifiIndicator(),
        wired: WiredIndicator(),
    },
    shown: network.bind('primary').as(p => p || 'wifi'),
})

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



const StatusIcons = () => Widget.Box({
    children: [
        BatteryIndicator(),
        NetworkIndicator(),
        VolumeIndicator(),
    ]
})

export { StatusIcons }