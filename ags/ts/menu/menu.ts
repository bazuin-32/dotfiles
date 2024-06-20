
const MenuRevealer = (monitor: number) => Widget.Revealer({
    revealChild: false,
    transition: "slide_down",
    transitionDuration: 1000,
    child: (() => Widget.Label("hello"))(),
})

const Menu = (monitor: number) => Widget.Window({
    monitor,
    name: `menu${monitor}`,
    anchor: ["top", "right"],
    className: "menu-window",
    child: MenuRevealer(monitor),
    exclusivity: "ignore"
})

export { Menu }