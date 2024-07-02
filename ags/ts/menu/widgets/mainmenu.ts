import { Binding } from "resource:///com/github/Aylur/ags/service.js"
import { MItem, activeMenu } from "ts/vars/menustate"
import { datetime } from "ts/vars/datetime"
import { VolumeIndicator } from "ts/icons/audio"
import { Icon } from "resource:///com/github/Aylur/ags/widgets/icon.js"

const makeButton = (menuItem: MItem, icon: string | Icon<any>, label: string | Binding<any, any, string>) => Widget.Button({
    className: "menu-button",
    child: Widget.CenterBox({
        startWidget: Widget.Box({
            children: [
                icon instanceof Icon ? icon : Widget.Icon({
                    icon: icon
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
    onClicked: () => { activeMenu.value = menuItem }
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
        makeButton("audio", VolumeIndicator(), "Audio")
    ]
})

export { MainMenu }