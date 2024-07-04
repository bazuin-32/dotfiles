import Gdk from "types/@girs/gdk-3.0/gdk-3.0"
import MenuItem from "types/widgets/menuitem"
import { Box } from "resource:///com/github/Aylur/ags/widgets/box.js"
import { Stream } from "resource:///com/github/Aylur/ags/service/audio.js"
import { Object } from "types/@girs/gobject-2.0/gobject-2.0.cjs"

import { VolumeIndicator, MicrophoneIndicator } from "ts/icons/audio"
import { makeButton } from "./mainmenu"

const audio = await Service.import("audio")

const VolumeSlider = (type: "speaker" | "microphone") => Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => audio[type].volume = value,
    value: audio[type].bind("volume")
})

const VolumeControl = (type: "speaker" | "microphone") => Widget.Box({
    children: [
        type == "speaker" ? VolumeIndicator() : MicrophoneIndicator(),
        Widget.Label({
            label: audio[type].bind("volume").as((vol: number) => `${Math.round(vol * 100)}%`)
        }),
        VolumeSlider(type),
    ]      
})

const or_default = <T>(val: T | null | undefined, def: T) => (val ? val : def)

const SpeakerPortControl = (stream: Stream) => { 
    const menu = Widget.Menu({
        children: stream.bind("stream").as(s => {
            let result: MenuItem<any, any>[] = []
            const ports = s?.get_ports()
            if (!ports) {
                print("no ports")
                return []
            }

            for (const port of ports) {
                result.push(Widget.MenuItem({
                    child: Widget.Label({
                        label: or_default(port.human_port, "err"),
                        hpack: "start"
                    }),
                    onActivate: () => {
                        if (port.port) {
                            s?.change_port(port.port)
                        }
                    }
                }))
            }
            
            return result
        }),
        widthRequest: 250
    })

    return Widget.Button({
        child: Widget.CenterBox({
            startWidget: Widget.Label({
                label: stream.bind("stream").as(s => or_default(s?.get_port().human_port, "err")),
                hpack: "start"
            }),
            endWidget: Widget.Icon({
                icon: "go-down-symbolic",
                hpack: "end"
            })
        }),
        onPrimaryClick: (self, event) => {
            // menu.popup_at_pointer(event)
            menu.popup_at_widget(self, Gdk.Gravity.CENTER, Gdk.Gravity.CENTER, event)
        },
        setup: (self) => {
            stream.stream?.bind_property("port", self.child.start_widget ? self.child.start_widget : new Object(), "label", 0)
        }
    })
}

const SpeakerDeviceControl = () => Widget.Box({
    vertical: true,
    children: audio.bind("speakers").as(arr => {
        let result: Box<any, any>[] = []
        
        for (const stream of arr) {
            result.push(Widget.Box({
                vertical: true,
                className: "device-control",
                children: [
                    Widget.Label({
                        label: stream.bind("stream").as(s => or_default(s?.description, "err")),
                        wrap: true,
                        xalign: 0
                    }),
                    SpeakerPortControl(stream)
                ] 
            }))
        }

        return result
    })
})

const AudioPanel = () => Widget.Box({
    vertical: true,
    hpack: "fill",
    className: "audio-panel",
    children: [
        VolumeControl("speaker"),
        VolumeControl("microphone"),
        makeButton("audiodev", "audio-speakers-symbolic", "Devices")
    ]
})


export { AudioPanel, SpeakerDeviceControl }