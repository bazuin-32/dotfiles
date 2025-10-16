import Gtk from "types/@girs/gtk-3.0/gtk-3.0"

import { menuVisibility, activeMenu, MItem, menuTransition, toMItem } from "ts/vars/menustate"
import { MainMenu, Calendar, MenuHeading, AudioPanel, NetworkPanel, BatteryPanel, SpeakerDeviceControl } from "./widgets"

const revealify = (widget: Gtk.Widget, menuName: MItem) => Widget.Revealer({
    child: widget,
    revealChild: activeMenu.bind().as(m => m == menuName)
})

const revealifyStackChildren = (children: { [name in MItem]: Gtk.Widget }) => {
    let result = children
    
    for (const childname in children) {
        const name = toMItem(childname)
        result[name] = revealify(children[name], name)
    }

    return result
}


const MenuStack = () => Widget.Stack({
    children: revealifyStackChildren({
        "main": MainMenu(),
        "cal": Calendar(),
        "audio": AudioPanel(),
        "network": NetworkPanel(),
        "battery": BatteryPanel(),
        "audiodev": SpeakerDeviceControl(),
    }),
    shown: activeMenu.bind(),
    transition: menuTransition.bind(),
    className: "menu-stack"
})

const MenuWidget = () => Widget.Box({
    className: "menu",
    vertical: true,
    children: [
        MenuHeading(),
        MenuStack()
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
    margins: [0, 19],
    child: Widget.Box({ // see https://aylur.github.io/ags-docs/config/common-issues/#window-doesnt-show-up for why i need this 1px box
        css: "padding: 1px;",
        child: MenuRevealer(monitor)
    })
})

export { Menu }