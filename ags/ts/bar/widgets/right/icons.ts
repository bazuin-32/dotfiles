import { VolumeIndicator } from "ts/icons/audio"
import { NetworkIndicator } from "ts/icons/network"
import { BatteryIndicator } from "ts/icons/battery"

const StatusIcons = () => Widget.Box({
    children: [
        BatteryIndicator(),
        NetworkIndicator(),
        VolumeIndicator(),
    ]
})

export { StatusIcons }