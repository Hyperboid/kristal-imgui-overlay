local imgui = Imgui.lib
local ffi = require("ffi")
---@class ImguiMiniApp : Class
local ImguiMiniApp, super = Class(nil, "ImguiMiniApp")

function ImguiMiniApp:init(title, flags)
    self.title = title or "Untitled Window"
    self.unique_id = self.id
    self.flags = flags or 0
    self.closable = false
    self.closebutton_pointer = ffi.new('bool[1]', true)
    ---@type [number,number]?
    self.initial_size = nil
end

function ImguiMiniApp:isOpen()
    ---@diagnostic disable-next-line: need-check-nil, undefined-field
    return self.closebutton_pointer[0]
end

function ImguiMiniApp:setOpen(open)
    ffi.copy(self.closebutton_pointer, ffi.new("bool[1]", open), 1)
end

function ImguiMiniApp:fullShow()
    if not self:isOpen() then
        return
    end
    if self.initial_size then
        imgui.SetNextWindowSize(self.initial_size, imgui.ImGuiCond_FirstUseEver);
    end
    if imgui.Begin(self:getTitle() .. "###" .. self.unique_id, self.closable and self.closebutton_pointer or nil, self:getFlags()) then
        self:show()
    end
    imgui.End()
end

function ImguiMiniApp:show()
    imgui.Button("Hello World")
end

function ImguiMiniApp:getFlags()
    return self.flags
end

function ImguiMiniApp:getTitle()
    return (self.title or "Untitled Window")
end

return ImguiMiniApp
