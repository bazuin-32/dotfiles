import { Clock } from "./clock"
import { StatusIcons } from "./icons"
import { menuVisibility, activeMenu } from "ts/vars/menustate"

const MenuBtn = (monitor: number) => Widget.Button({
    className: "bar-button",
    onClicked: () => {
        if (!menuVisibility[monitor].value) {
            activeMenu.value = "main"
        }
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