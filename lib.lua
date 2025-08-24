local lib = {}

---@class KristalImgui
local Imgui = _G.Imgui or {}
_G.Imgui = Imgui

Imgui.first_update = false

function lib:preInit()
    Imgui.init()
end

function Imgui.firstInit()
    -- this is the worst thing i've ever done
    package.path = package.path .. ";"..love.filesystem.getSaveDirectory().."/?.lua"
    package.cpath = package.cpath .. ";"..love.filesystem.getSaveDirectory().."/?."..((function()
        local os = require("ffi").os
        if os == "Windows" then
            return "dll"
        elseif os == "Linux" then
            return "so"
        elseif os == "OSX" then -- TODO: Is "OSX" correct?
            return "dylib"
        else
            error("\"" ..os.."\" isn't supported, sorry! If you're a player, tell the dev to remove the imgui stuff.")
        end
    end)())
    Imgui.active = true
    ---@type imgui
    Imgui.lib = libRequire("imgui", "cimgui.cimgui.init")
end

function Imgui.init()
    if Imgui.active == nil then
        Imgui.firstInit()
    end
    if not Imgui.initialized then
        Imgui.lib.love.Init()

        Imgui.initialized = true
        local io = Imgui.lib.C.igGetIO()
        io.ConfigFlags = bit.bor(
            io.ConfigFlags,
            Imgui.lib.ImGuiConfigFlags_NavEnableGamepad,
            Imgui.lib.ImGuiConfigFlags_DockingEnable,
        0)
    end
end

function Imgui.preDraw() end

function Imgui.draw()
    if not (Imgui.first_update and Imgui.active) then
        return
    end
    if not Kristal.callEvent("drawImgui") then
        Imgui.lib.ShowDemoWindow()
    end
    Imgui.lib.Render()
    Imgui.lib.love.RenderDrawLists()
end

function Imgui.update()
    if not Imgui.active then
        return
    end
    Imgui.lib.love.Update(DT)
    Imgui.lib.NewFrame()
    Imgui.first_update = true
end

function Imgui.reboot()
    lib:unload()
end

function lib:unload()
    Imgui.first_update = false
    Imgui.initialized = false
    Imgui.lib.love.Shutdown()
end

function lib:onKeyPressed(key)
    if key == "f10" then
        Imgui.active = not Imgui.active
    end
end

return lib