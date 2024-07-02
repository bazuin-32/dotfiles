const audio = await Service.import('audio')

const VolumeIndicator = () => Widget.Icon({
    className: "status-icon menu-icon",
}).hook(audio.speaker, self => {
    const vol = audio.speaker.volume * 100;
    const icon = audio.speaker.is_muted ? "muted" : [
        [101, 'overamplified'],
        [67, 'high'],
        [34, 'medium'],
        [1, 'low'],
        [0, 'muted'],
    ].find(([threshold]) => +threshold <= vol)?.[1]; // use `+threshold` because ts thinks the type is `string | number` and then complains

    self.icon = `audio-volume-${icon}-symbolic`;
    self.tooltip_text = `Volume ${Math.floor(vol)}%` + (
        audio.speaker.is_muted ? " (muted)" : ""
    );
})

const MicrophoneIndicator = () => Widget.Icon({
    className: "menu-icon"
}).hook(audio.microphone, self => {
    const vol = audio.microphone.volume * 100
    const icon = [
        [50, "high"],
        [0, "low"]
    ].find(([threshold]) => +threshold <= vol)?.[1]
    
    self.icon = `microphone-sensitivity-${icon}-symbolic`
})

export { VolumeIndicator, MicrophoneIndicator }