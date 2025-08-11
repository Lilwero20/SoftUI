local ThemeManager = {}
ThemeManager.__index = ThemeManager

local HttpService = game:GetService("HttpService")
local REQUIRED_COLORS = {"Primary", "Secondary", "Text", "Accent", "Error"}

function ThemeManager:Init(softUI)
    self.SoftUI = softUI
    self.Themes = {}
    self.CurrentTheme = "Dark"
    self.Event = Instance.new("BindableEvent")
end

-- Carga un tema desde GitHub
function ThemeManager:LoadTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        self.Event:Fire("ThemeChanged", themeName)
        return true
    end

    local url = "https://raw.githubusercontent.com/Lilwero20/SoftUI/main/assets/Themes/"..themeName..".json"
    
    local success, response = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    
    if not success then
        warn("[ThemeManager] Error cargando tema: "..tostring(response))
        return false
    end

    local themeData
    success, themeData = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not success then
        warn("[ThemeManager] Error decodificando tema: "..tostring(themeData))
        return false
    end

    -- Validar campos requeridos
    for _, colorName in ipairs(REQUIRED_COLORS) do
        if not themeData.Colors[colorName] then
            warn("[ThemeManager] Tema inválido: falta el color "..colorName)
            return false
        end
    end

    -- Convertir colores a Color3
    for name, rgb in pairs(themeData.Colors) do
        themeData.Colors[name] = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
    end

    self.Themes[themeName] = themeData
    self.CurrentTheme = themeName
    self.Event:Fire("ThemeChanged", themeName)
    
    return true
end

-- Obtiene un color del tema actual
function ThemeManager:GetColor(colorName)
    local theme = self.Themes[self.CurrentTheme]
    if not theme then
        warn("[ThemeManager] Tema no cargado: "..self.CurrentTheme)
        return Color3.new(1, 0, 1) -- Magenta como fallback
    end
    
    local color = theme.Colors[colorName]
    if not color then
        warn("[ThemeManager] Color no encontrado: "..colorName)
        return theme.Colors.Error or Color3.new(1, 0, 0)
    end
    
    return color
end

-- Aplica el tema a todos los elementos UI
function ThemeManager:ApplyToExistingElements()
    for _, element in pairs(self.SoftUI.Elements) do
        if element.ApplyTheme then
            element:ApplyTheme(self)
        end
    end
end

return ThemeManager