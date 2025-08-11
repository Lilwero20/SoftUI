local Button = {}
Button.__index = Button

function Button.new(softUI, parent, options)
    local self = setmetatable({}, Button)
    self.SoftUI = softUI

    -- Crear instancia
    self.Button = Instance.new("TextButton")
    self.Button.Text = options.Text or "Button"
    self.Button.Size = options.Size or UDim2.new(1, -20, 0, 40)
    self.Button.BackgroundColor3 = softUI.Themes:GetColor("Accent")
    self.Button.TextColor3 = softUI.Themes:GetColor("Text")
    self.Button.Font = Enum.Font.GothamMedium
    self.Button.TextSize = 14
    self.Button.Parent = parent

    -- Ícono opcional
    if options.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Image = softUI.Icons:GetIcon(options.Icon)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 10, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Parent = self.Button
        self.Button.TextXAlignment = Enum.TextXAlignment.Left
        self.Button.PaddingLeft = UDim.new(0, 35)
    end

    -- Efectos
    softUI.Animations:ApplyRoundCorners(self.Button, 0.25)
    softUI.Animations:SetupButtonEffects(self.Button)

    -- Callback
    if options.Callback then
        self.Button.MouseButton1Click:Connect(function()
            if options.Confirm then
                softUI:Notify("Confirmar", options.Confirm, "warning", function(confirmed)
                    if confirmed then options.Callback() end
                end)
            else
                options.Callback()
            end
        end)
    end

    return self
end

return Button