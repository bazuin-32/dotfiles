import { VolumeIndicator, MicrophoneIndicator } from "ts/icons/audio"

const audio = await Service.import("audio")

const VolumeSlider = (type: string) => Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => audio[type].volume = value,
    value: audio[type].bind("volume")
})

const VolumeControl = (type: string) => Widget.Box({
    children: [
        type == "speaker" ? VolumeIndicator() : MicrophoneIndicator(),
        Widget.Label({
            label: audio[type].bind("volume").as((vol: number) => `${Math.round(vol * 100)}%`)
        }),
        VolumeSlider(type),
    ]      
})


const AudioPanel = () => Widget.Box({
    vertical: true,
    hpack: "fill",
    className: "audio-panel",
    children: [
        VolumeControl("speaker"),
        VolumeControl("microphone")
    ]
})

export { AudioPanel }