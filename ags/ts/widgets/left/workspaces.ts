const hyprland = await Service.import('hyprland')

const dispatch = ws => hyprland.messageAsync(`dispatch workspace ${ws}`);

const Workspaces = () => Widget.Box({
    children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
        className: "workspace",
        attribute: i,
        label: `${i}`,
        onClicked: () => dispatch(i),
    })),

    // remove this setup hook if you want fixed number of buttons
    setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
        btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute);
        btn.toggleClassName("active", btn.attribute == hyprland.active.workspace.id)
    })),
})

export { Workspaces }