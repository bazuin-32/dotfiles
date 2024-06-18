import { SysTray } from "./right/systray"
import { Clock } from "./right/clock"
import { StatusIcons } from "./right/icons"

const RightBox = () => Widget.Box({
    className: "right-container",
    hpack: "end",
    children: [
        SysTray(),
        StatusIcons(),
        Clock()
    ]
})
// const RightBox = () => SysTray()
// const RightBox = SysTray

export { RightBox }