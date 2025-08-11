local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(softUI, parent, options)
    local self = setmetatable({}, Toggle)
    self.SoftUI = softUI
    self.State = options.Default or false

    -- Contenedor
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 30)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Parent = parent

    -- Texto
    self.Label = Instance.new("TextLabel")
    self.Label.Text = options.Text or "Toggle"
    self.Label.Size = UDim2.new(1, -60, 1, 0)
    self.Label.TextColor3 = softUI.Themes:GetColor("Text")
    self.Label.BackgroundTransparency = 1
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame

    -- Base del toggle
    self.Track = Instance.new("Frame")
    self.Track.Size = UDim2.new(0, 50, 0, 25)
    self.Track.Position = UDim2.new(1, -50, 0.5, -12)
    self.Track.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Track.Parent = self.Frame

    -- Control deslizante
    self.Thumb = Instance.new("Frame")
    self.Thumb.Size = UDim2.new(0, 20, 0, 20)
    self.Thumb.Position = UDim2.new(self.State and 0.6 or 0.1, 0, 0.5, -10)
    self.Thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    self.Thumb.Parent = self.Track

    -- Efectos
    softUI.Animations:ApplyRoundCorners(self.Track, 1)
    softUI.Animations:ApplyRoundCorners(self.Thumb, 1)

    -- Interacción
    self.Track.MouseButton1Click:Connect(function()
        self:SetState(not self.State)
    end)

    return self
end

function Toggle:SetState(state)
    self.State = state
    self.SoftUI.Animations:Tween(self.Thumb, {
        Position = UDim2.new(state and 0.6 or 0.1, 0, 0.5, -10)
    }, 0.2)
    
    if self.Options.Callback then
        self.Options.Callback(state)
    end
end

return Toggle