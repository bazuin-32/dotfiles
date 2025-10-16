import { SysTray } from "./right/systray"
import { MenuBtn } from "./right/menubtn"

const RightBox = (monitor: number) => Widget.Box({
    className: "right-container",
    hpack: "end",
    children: [
        SysTray(),
        MenuBtn(monitor)
    ]
})
// const RightBox = () => SysTray()
// const RightBox = SysTray

export { RightBox }