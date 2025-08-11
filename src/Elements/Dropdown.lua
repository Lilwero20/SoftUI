local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(softUI, parent, options)
    local self = setmetatable({}, Dropdown)
    
    -- Contenedor principal
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 40)
    self.Frame.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Frame.Parent = parent

    -- Botón principal (corregido)
    self.MainButton = Instance.new("TextButton")
    self.MainButton.Text = options.Placeholder or "Seleccionar..."
    self.MainButton.Size = UDim2.new(1, 0, 1, 0)
    self.MainButton.BackgroundTransparency = 1
    self.MainButton.TextXAlignment = Enum.TextXAlignment.Left
    self.MainButton.PaddingLeft = UDim.new(0, 10)
    self.MainButton.Parent = self.Frame

    -- Ícono flecha (usando IconManager)
    self.Arrow = Instance.new("ImageLabel")
    self.Arrow.Image = softUI.Icons:GetIcon("dropdown_arrow")
    self.Arrow.Size = UDim2.new(0, 16, 0, 16)
    self.Arrow.Position = UDim2.new(1, -25, 0.5, -8)
    self.Arrow.Parent = self.Frame

    -- Resto del código corregido...
    return self
end

return Dropdown
