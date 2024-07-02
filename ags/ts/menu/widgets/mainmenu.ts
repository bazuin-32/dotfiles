import { Binding } from "resource:///com/github/Aylur/ags/service.js"
import { Widget as GtkWidget } from "types/@girs/gtk-3.0/gtk-3.0.cjs"

import { MItem, activeMenu } from "ts/vars/menustate"
import { datetime } from "ts/vars/datetime"
import { VolumeIndicator } from "ts/icons/audio"
import { NetworkIndicator } from "ts/icons/network"
import { BatteryIndicator } from "ts/icons/battery"

const battery = await Service.import("battery")


const makeButton = (
    menuItem: MItem,
    icon: string | GtkWidget,
    label: string | Binding<any, any, string>,
    condition: boolean | Binding<any, any, boolean> = true
) => Widget.Button({
    className: "menu-button",
    child: Widget.CenterBox({
        startWidget: Widget.Box({
            children: [
                icon instanceof GtkWidget ? icon : Widget.Icon({
                    icon: icon,
                    className: "menu-icon"
                }),
                Widget.Label({
                    label: label
                }),
            ]
        }),
        endWidget: Widget.Icon({
            hpack: "end",
            className: "menu-item-arrow",
            icon: "go-next-symbolic"
        })
    }),
    onClicked: () => { activeMenu.value = menuItem },
    visible: condition
})

const MainMenu = () => Widget.Box({
    vertical: true,
    children: [
        makeButton("cal", "x-office-calendar-symbolic", datetime.bind().as((dt) => dt.toLocaleString(
            "en-US",
            {
                weekday: "long",
                month: "long",
                day: "numeric",
                year: "numeric"
            }
        ))),
        makeButton("audio", VolumeIndicator(), "Audio"),
        makeButton("network", NetworkIndicator(), "Network"),
        makeButton("battery", BatteryIndicator(), "Battery", battery.bind("available"))
    ]
})

export { MainMenu }