local lib = {}

---@class KristalImgui
local Imgui = _G.Imgui or {}
_G.Imgui = Imgui

Imgui.first_update = false

function lib:preInit()
    if not Imgui.initialized then
        ---@type imgui
        Imgui.lib = libRequire("imgui", "cimgui.cimgui.init")

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
    if not Imgui.first_update then
        return
    end
    if not Kristal.callEvent("drawImgui") then
        Imgui.lib.ShowDemoWindow()
    end
    Imgui.lib.Render()
    Imgui.lib.love.RenderDrawLists()
end

function Imgui.update()
    Imgui.lib.love.Update(DT)
    Imgui.lib.NewFrame()
    Imgui.first_update = true
end

return lib