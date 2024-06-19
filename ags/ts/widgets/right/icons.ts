const audio = await Service.import('audio')

const VolumeIndicator = () => Widget.Button({
    className: "status-icon",
    on_clicked: () => audio.speaker.is_muted = !audio.speaker.is_muted,
    child: Widget.Icon().hook(audio.speaker, self => {
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
    }),
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

const StatusIcons = () => Widget.Box({
    children: [
        NetworkIndicator(),
        VolumeIndicator(),
    ]
})

export { StatusIcons }