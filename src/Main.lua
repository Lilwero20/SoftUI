local SoftUI = {}
SoftUI.__index = SoftUI

local function Import(module)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/TuUsuario/SoftUI/main/src/"..module..".lua"))()
end

function SoftUI:Init(options)
    local self = setmetatable({}, SoftUI)
    
    self.Loader = Import("Core/Loader")
    self.Themes = Import("Core/ThemeManager")
    self.Animations = Import("Core/AnimationManager")
    self.Icons = Import("Core/IconManager")
    
    self.Loader:Show(
        options.LoadingTitle or "SoftUI",
        options.LoadingSubtitle or "Cargando...",
        {
            ImageUrl = options.LoadingImage,
            Duration = options.LoadingDuration or 2
        }
    )
    
    self.Themes:LoadTheme(options.DefaultTheme or "Dark")
    return self
end

function SoftUI:CreateWindow(options)
    local Window = Import("Elements/Window")
    return Window.new(self, options)
end

function SoftUI:SetTheme(themeName)
    self.Themes:LoadTheme(themeName)
end

return SoftUI