import { FocusedTitle } from "./center/focusedTitle"

const CenterBox = () => Widget.Box({
    hpack: "center",
    children: [
        FocusedTitle()
    ]
})

export { CenterBox }