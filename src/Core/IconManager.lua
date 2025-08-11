local IconManager = {}
IconManager.__index = IconManager

local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")

function IconManager:Init(softUI)
    self.SoftUI = softUI
    self.IconCache = {}
    self.BaseUrl = "https://raw.githubusercontent.com/Lilwero20/SoftUI/main/assets/Icons/"
end

-- Precarga íconos esenciales
function IconManager:PreloadEssentialIcons()
    local essentialIcons = {
        "close", "dropdown_arrow", "minimize", "maximize", "settings"
    }
    
    for _, iconName in pairs(essentialIcons) do
        self:GetIcon(iconName, true)
    end
end

-- Obtiene un ícon (con cacheo)
function IconManager:GetIcon(iconName, preload)
    if self.IconCache[iconName] then
        return self.IconCache[iconName]
    end
    
    -- URL del ícono (puede ser rbxassetid o URL externa)
    local iconUrl
    if iconName:match("^rbxassetid://") then
        iconUrl = iconName
    else
        iconUrl = self.BaseUrl .. iconName .. ".png"
        
        -- Verificación de existencia (solo en modo debug)
        if self.SoftUI.Config.DebugMode then
            local success = pcall(function()
                game:HttpGet(iconUrl, true)
            end)
            if not success then
                warn("[IconManager] Ícono no encontrado: " .. iconName)
                return ""
            end
        end
    end
    
    self.IconCache[iconName] = iconUrl
    
    if preload then
        ContentProvider:PreloadAsync({iconUrl})
    end
    
    return iconUrl
end

-- Carga múltiples íconos
function IconManager:LoadIconSet(iconSet)
    for name, url in pairs(iconSet) do
        self.IconCache[name] = url
    end
    ContentProvider:PreloadAsync(iconSet)
end

return IconManager