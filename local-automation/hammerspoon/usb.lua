usbWatcher = nil


function usbDeviceCallback(data)
    if (data["productName"] =="") then
        if (data["eventType"] == "added") then
            hs.application.launchOrFocus("")
        elseif (data["eventType"] == "removed") then
            app = hs.appfinder.appFromName("")
            app:kill()
        end
    end
end

usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
