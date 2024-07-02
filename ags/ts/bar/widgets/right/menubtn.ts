import { Clock } from "./clock"
import { StatusIcons } from "./icons"
import { menuVisibility } from "ts/vars/menustate"

const MenuBtn = (monitor: number) => Widget.Button({
    className: "bar-button",
    onClicked: () => {
        menuVisibility[monitor].value = !menuVisibility[monitor].value
    },
    child: Widget.Box({
        children: [
            StatusIcons(),
            Clock()
        ]
    })
})

export { MenuBtn }