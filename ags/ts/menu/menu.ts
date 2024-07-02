import { menuVisibility, activeMenu } from "ts/vars/menustate"
import { MainMenu, Calendar, MenuHeading, AudioPanel } from "./widgets"


const MenuStack = () => Widget.Stack({
    children: {
        "main": MainMenu(),
        "cal": Calendar(),
        "audio": AudioPanel()
    },
    shown: activeMenu.bind(),
    transition: activeMenu.bind().as((m) => (m == "main" ? "slide_left" : "slide_right"))
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