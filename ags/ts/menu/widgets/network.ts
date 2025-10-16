const network = await Service.import("network")

// see https://aylur.github.io/ags-docs/services/network/#accesspoint
type AccessPoint = {
    bssid: string | null
    address: string | null
    lastSeen: number
    ssid: string | null
    active: boolean
    strength: number
    frequency: number
    iconName: string | undefined
}

const APButton = (ap: AccessPoint) => Widget.Button({
    className: "menu-button",
    child: Widget.Box({
        children: [
            Widget.Icon(ap.iconName),
            Widget.Label(`${ap.ssid} - ${(ap.frequency / 1000).toFixed(1)} GHz - ${ap.strength}`)
        ]
    }),
    onClicked: () => {
        print(JSON.stringify(ap))
    }
})


const WifiPanel = () => Widget.Scrollable({
    hscroll: "never",
    vscroll: "automatic",
    css: "min-height: 150px;",
    child: Widget.Box({
        vertical: true,
        children: network.wifi.bind("access_points").as(aps => (
            aps
                .sort((a, b) => b.strength - a.strength) // sort by strength from greatest to smallest
                .sort((a, b) => +b.active - +a.active) // put active ap at the top
                .filter(ap => ap.strength > 35)
                .map(ap => APButton(ap))
        ))
    })
})

const WiredPanel = () => Widget.Box({
    children: [
        Widget.Label("wired stuff")
    ]
})

const NetworkPanel = () => Widget.Stack({
    children: {
        wifi: WifiPanel(),
        wired: WiredPanel()
    },
    shown: network.bind("primary").as(p => p || "wifi")
})

export { NetworkPanel }