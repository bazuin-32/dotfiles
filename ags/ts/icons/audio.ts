const audio = await Service.import('audio')

const VolumeIndicator = () => Widget.Icon({
    className: "status-icon",
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

export { VolumeIndicator }