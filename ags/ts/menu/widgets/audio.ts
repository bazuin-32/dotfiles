const audio = await Service.import("audio")

const VolumeSlider = (type: string) => Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => audio[type].volume = value,
    value: audio[type].bind("volume")
})


const AudioPanel = () => Widget.Box({
    children: [
        VolumeSlider("speaker"),
        VolumeSlider("microphone")
    ]
})

export { AudioPanel }