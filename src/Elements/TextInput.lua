local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(softUI, parent, options)
    local self = setmetatable({}, TextInput)

    -- Contenedor
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 40)
    self.Frame.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Frame.Parent = parent

    softUI.Animations:ApplyRoundCorners(self.Frame, 0.15)

    -- Campo de texto
    self.Input = Instance.new("TextBox")
    self.Input.Size = UDim2.new(1, -20, 1, 0)
    self.Input.Position = UDim2.new(0, 10, 0, 0)
    self.Input.PlaceholderText = options.Placeholder or "Escribe aquí..."
    self.Input.TextColor3 = softUI.Themes:GetColor("Text")
    self.Input.BackgroundTransparency = 1
    self.Input.ClearTextOnFocus = false
    self.Input.Parent = self.Frame

    -- Lógica de validación
    if options.Numeric then
        self.Input:GetPropertyChangedSignal("Text"):Connect(function()
            self.Input.Text = self.Input.Text:gsub("[^%d]", "")
        end)
    end

    self.Input.FocusLost:Connect(function()
        if options.Callback then
            options.Callback(self.Input.Text)
        end
    end)

    return self
end

return TextInput