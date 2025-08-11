local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(softUI, parent, options)
    local self = setmetatable({}, Dropdown)
    self.SoftUI = softUI
    self.Options = options.Options or {}
    self.MultiSelect = options.MultiSelect or false
    self.Selected = {}

    -- Contenedor principal
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 40)
    self.Frame.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Frame.Parent = parent

    softUI.Animations:ApplyRoundCorners(self.Frame, 0.15)

    -- Botón del dropdown
    self.Button = Instance.new("TextButton")
    self.Button.Text = options.Placeholder or "Seleccionar..."
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.BackgroundTransparency = 1
    self.Button.TextColor3 = softUI.Themes:GetColor("Text")
    self.Button.Parent = self.Frame

    -- Ícono flecha
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -20, 0.5, -8)
    arrow.Image = softUI.Icons:GetIcon("dropdown_arrow")
    arrow.Parent = self.Frame

    -- Lista de opciones (aparece al hacer clic)
    self.OptionsFrame = Instance.new("ScrollingFrame")
    self.OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    self.OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
    self.OptionsFrame.BackgroundColor3 = softUI.Themes:GetColor("Primary")
    self.OptionsFrame.Visible = false
    self.OptionsFrame.Parent = self.Frame

    softUI.Animations:ApplyRoundCorners(self.OptionsFrame, 0.15)

    -- Lógica interactiva
    self.Button.MouseButton1Click:Connect(function()
        self:ToggleOptions()
    end)

    self:BuildOptions()
    return self
end

function Dropdown:ToggleOptions()
    local targetSize = self.OptionsFrame.Visible and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 0, math.min(#self.Options * 30, 150))
    
    game:GetService("TweenService"):Create(
        self.OptionsFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {Size = targetSize}
    ):Play()
    
    self.OptionsFrame.Visible = not self.OptionsFrame.Visible
end

function Dropdown:BuildOptions()
    for i, option in ipairs(self.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Text = option
        optionButton.Size = UDim2.new(1, -10, 0, 30)
        optionButton.Position = UDim2.new(0, 5, 0, (i-1)*30)
        optionButton.BackgroundColor3 = self.SoftUI.Themes:GetColor("Secondary")
        optionButton.TextColor3 = self.SoftUI.Themes:GetColor("Text")
        optionButton.Parent = self.OptionsFrame

        optionButton.MouseButton1Click:Connect(function()
            if not self.MultiSelect then
                self.Button.Text = option
                self.Selected = {option}
                self:ToggleOptions()
            end
            if self.Options.Callback then
                self.Options.Callback(option)
            end
        end)
    end
end

return Dropdown