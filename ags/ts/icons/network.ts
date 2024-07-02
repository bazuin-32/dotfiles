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
    
export { NetworkIndicator }