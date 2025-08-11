local HttpService = game:GetService("HttpService")
local ThemeManager = {
    Themes = {},
    CurrentTheme = "Dark"
}

-- Validación de campos mínimos
local REQUIRED_FIELDS = {"Primary", "Secondary", "Text", "Accent"}

function ThemeManager:LoadTheme(themeName)
    local url = "https://raw.githubusercontent.com/lilwero20/SoftUI/main/assets/Themes/"..themeName..".json"
    
    local success, response = pcall(function()
        local json = game:HttpGet(url, true)
        return HttpService:JSONDecode(json)
    end)
    
    if not success then
        warn("Error cargando tema "..themeName..": "..response)
        return false
    end
    
    -- Validar campos obligatorios
    for _, field in ipairs(REQUIRED_FIELDS) do
        if not response.Colors[field] then
            warn("Tema inválido: Falta el campo "..field)
            return false
        end
    end
    
    self.Themes[themeName] = response
    self.CurrentTheme = themeName
    self:_ApplyToAllElements()
    return true
end

function ThemeManager:_ApplyToAllElements()
    -- Lógica para actualizar todos los elementos UI existentes
end

return ThemeManager
