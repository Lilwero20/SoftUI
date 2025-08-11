local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(softUI, parent, options)
    local self = setmetatable({}, TextInput)
    self.SoftUI = softUI

    -- Contenedor
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 40)
    self.Frame.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Frame.Parent = parent

    -- Campo de texto
    self.Input = Instance.new("TextBox")
    self.Input.Size = UDim2.new(1, -20, 1, 0)
    self.Input.Position = UDim2.new(0, 10, 0, 0)
    self.Input.PlaceholderText = options.Placeholder or "Escribe aquí..."
    self.Input.Text = options.Default or ""
    self.Input.TextColor3 = softUI.Themes:GetColor("Text")
    self.Input.BackgroundTransparency = 1
    self.Input.ClearTextOnFocus = false
    self.Input.Parent = self.Frame

    -- Efectos
    softUI.Animations:ApplyRoundCorners(self.Frame, 0.15)
    softUI.Animations:SetupInputEffects(self.Input)

    -- Validación
    if options.Validation then
        self.Input.FocusLost:Connect(function()
            if not options.Validation(self.Input.Text) then
                softUI.Animations:Shake(self.Frame)
                if options.ErrorMessage then
                    softUI:Notify("Error", options.ErrorMessage, "error")
                end
            elseif options.Callback then
                options.Callback(self.Input.Text)
            end
        end)
    elseif options.Callback then
        self.Input.FocusLost:Connect(function()
            options.Callback(self.Input.Text)
        end)
    end

    return self
end

return TextInput