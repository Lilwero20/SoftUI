local IconManager = {}
IconManager.__index = IconManager

function IconManager:Init()
    self.Icons = {
        close = "rbxassetid://123456",  -- Reemplaza con IDs reales
        dropdown_arrow = "rbxassetid://789012",
        toggle_on = "rbxassetid://345678",
        toggle_off = "rbxassetid://901234"
    }
end

function IconManager:GetIcon(name)
    return self.Icons[name] or error("Ícono no encontrado: "..tostring(name))
end

return IconManager
