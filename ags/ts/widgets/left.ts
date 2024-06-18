import { Workspaces } from "./left/workspaces"

const LeftBox = () => Widget.Box({
    className: "left-container",
    hpack: "start",
    children: [
        Workspaces()
    ]
})

export { LeftBox }