import { menuVisibility } from "ts/vars/menuvisibitily"
import { DtLabel, Calendar } from "./widgets"

const MenuWidget = () => Widget.Box({
    className: "menu",
    vertical: true,
    children: [
        DtLabel(),
        Calendar()
    ]
})

const MenuRevealer = (monitor: number) => Widget.Revealer({
    revealChild: menuVisibility[monitor].bind(),
    transition: "slide_down",
    transitionDuration: 500,
    child: MenuWidget(),
})

const Menu = (monitor: number) => Widget.Window({
    monitor,
    name: `menu${monitor}`,
    anchor: ["top", "right"],
    className: "menu-window",
    child: Widget.Box({ // see https://aylur.github.io/ags-docs/config/common-issues/#window-doesnt-show-up for why i need this 1px box
        css: "padding: 1px;",
        child: MenuRevealer(monitor)
    })
})

export { Menu }