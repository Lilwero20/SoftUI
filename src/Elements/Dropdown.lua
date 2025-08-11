local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(softUI, parent, options)
    local self = setmetatable({}, Dropdown)
    self.SoftUI = softUI
    self.Options = options.Options or {}
    self.MultiSelect = options.MultiSelect or false
    self.Selected = options.Default or (self.MultiSelect and {} or nil)

    -- Contenedor principal
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 40)
    self.Frame.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Frame.Parent = parent

    -- Botón principal
    self.MainButton = Instance.new("TextButton")
    self.MainButton.Text = options.Placeholder or "Seleccionar..."
    self.MainButton.Size = UDim2.new(1, 0, 1, 0)
    self.MainButton.BackgroundTransparency = 1
    self.MainButton.TextColor3 = softUI.Themes:GetColor("Text")
    self.MainButton.TextXAlignment = Enum.TextXAlignment.Left
    self.MainButton.PaddingLeft = UDim.new(0, 10)
    self.MainButton.Parent = self.Frame

    -- Ícono flecha
    self.Arrow = Instance.new("ImageLabel")
    self.Arrow.Image = softUI.Icons:GetIcon("dropdown_arrow")
    self.Arrow.Size = UDim2.new(0, 16, 0, 16)
    self.Arrow.Position = UDim2.new(1, -25, 0.5, -8)
    self.Arrow.BackgroundTransparency = 1
    self.Arrow.Parent = self.Frame

    -- Lista de opciones
    self.OptionsFrame = Instance.new("ScrollingFrame")
    self.OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    self.OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
    self.OptionsFrame.BackgroundColor3 = softUI.Themes:GetColor("Primary")
    self.OptionsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.OptionsFrame.ScrollBarThickness = 5
    self.OptionsFrame.Visible = false
    self.OptionsFrame.Parent = self.Frame

    -- Efectos
    softUI.Animations:ApplyRoundCorners(self.Frame, 0.15)
    softUI.Animations:ApplyRoundCorners(self.OptionsFrame, 0.15)
    softUI.Animations:SetupButtonEffects(self.MainButton)

    -- Interacción
    self.MainButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    self:BuildOptions()
    return self
end

function Dropdown:Toggle()
    local targetSize = self.OptionsFrame.Visible and UDim2.new(1, 0, 0, 0) 
        or UDim2.new(1, 0, 0, math.min(#self.Options * 35 + 10, 200))
    
    self.SoftUI.Animations:Tween(self.OptionsFrame, {
        Size = targetSize,
        BackgroundTransparency = self.OptionsFrame.Visible and 1 or 0
    }, 0.3)
    
    self.SoftUI.Animations:Tween(self.Arrow, {
        Rotation = self.OptionsFrame.Visible and 0 or 180
    }, 0.3)
    
    self.OptionsFrame.Visible = not self.OptionsFrame.Visible
end

function Dropdown:BuildOptions()
    for i, option in ipairs(self.Options) do
        local optionFrame = Instance.new("TextButton")
        optionFrame.Text = option
        optionFrame.Size = UDim2.new(1, -10, 0, 30)
        optionFrame.Position = UDim2.new(0, 5, 0, (i-1)*35 + 5)
        optionFrame.BackgroundColor3 = self.SoftUI.Themes:GetColor("Secondary")
        optionFrame.TextColor3 = self.SoftUI.Themes:GetColor("Text")
        optionFrame.Parent = self.OptionsFrame

        self.SoftUI.Animations:ApplyRoundCorners(optionFrame, 0.1)
        self.SoftUI.Animations:SetupButtonEffects(optionFrame)

        optionFrame.MouseButton1Click:Connect(function()
            if self.MultiSelect then
                -- Lógica multi-selección
            else
                self.Selected = option
                self.MainButton.Text = option
                self:Toggle()
            end
            
            if self.Options.Callback then
                self.Options.Callback(self.Selected)
            end
        end)
    end
end

return Dropdown