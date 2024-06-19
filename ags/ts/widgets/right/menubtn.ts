import { Clock } from "./clock"
import { StatusIcons } from "./icons"

const MenuBtn = () => Widget.Button({
    className: "bar-button",
    child: Widget.Box({
        children: [
            StatusIcons(),
            Clock()
        ]
    })
})

export { MenuBtn }