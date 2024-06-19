import { FocusedTitle } from "./center/focusedTitle"

const CenterBox = () => Widget.Box({
    className: "center-container",
    hpack: "center",
    children: [
        FocusedTitle()
    ]
})

export { CenterBox }