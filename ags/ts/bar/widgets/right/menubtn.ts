import { Clock } from "./clock"
import { StatusIcons } from "./icons"
import { menuVisibility, resetMenu } from "ts/vars/menustate"

const MenuBtn = (monitor: number) => Widget.Button({
    className: "bar-button",
    onClicked: () => {
        if (!menuVisibility[monitor].value) {
            resetMenu()
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