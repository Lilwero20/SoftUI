local Button = {}
Button.__index = Button

function Button.new(softUI, parent, options)
    local self = setmetatable({}, Button)
    
    self.Button = Instance.new("TextButton")
    self.Button.Text = options.Text or "Button"
    self.Button.Size = UDim2.new(1, -20, 0, 40)
    self.Button.BackgroundColor3 = softUI.Themes:GetColor("Accent")
    self.Button.TextColor3 = softUI.Themes:GetColor("Text")
    self.Button.Parent = parent
    
    -- Animaciones y estilo
    softUI.Animations:ApplyRoundCorners(self.Button, 0.25)
    
    -- Efecto hover
    self.Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            self.Button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = softUI.Themes:GetColor("Accent"):Lerp(Color3.new(1,1,1), 0.2)}
        ):Play()
    end)
    
    -- Callback
    if options.Callback then
        self.Button.MouseButton1Click:Connect(options.Callback)
    end
    
    return self
end

return Button