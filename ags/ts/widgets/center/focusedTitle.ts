const hyprland = await Service.import("hyprland")

const FocusedTitle = () => Widget.Label({
    className: "window-title",
    label: hyprland.active.client.bind('title'),
    visible: hyprland.active.client.bind('address')
        .as(addr => !!addr),
})
        
export { FocusedTitle }