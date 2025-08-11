local HttpService = game:GetService("HttpService")
local ThemeManager = {
    Themes = {},
    CurrentTheme = "Dark"
}

function ThemeManager:LoadTheme(themeName)
    local url = "https://raw.githubusercontent.com/TuUsuario/SoftUI/main/Assets/Themes/"..themeName..".json"
    local success, response = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    
    if success then
        local themeData = HttpService:JSONDecode(response)
        self.Themes[themeName] = themeData
        self.CurrentTheme = themeName
        return themeData
    else
        warn("Error al cargar el tema: "..themeName)
        return nil
    end
end

function ThemeManager:GetColor(colorName)
    local theme = self.Themes[self.CurrentTheme]
    return theme and Color3.fromRGB(unpack(theme.Colors[colorName])) or Color3.new(1, 0, 1)
end

return ThemeManager