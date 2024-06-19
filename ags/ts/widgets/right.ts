import { SysTray } from "./right/systray"
import { MenuBtn } from "./right/menubtn"

const RightBox = () => Widget.Box({
    className: "right-container",
    hpack: "end",
    children: [
        SysTray(),
        MenuBtn()
    ]
})
// const RightBox = () => SysTray()
// const RightBox = SysTray

export { RightBox }