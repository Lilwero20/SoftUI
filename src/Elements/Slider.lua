local Slider = {}
Slider.__index = Slider

function Slider.new(softUI, parent, options)
    local self = setmetatable({}, Slider)
    self.SoftUI = softUI
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Step = options.Step or 1
    self.Value = options.Default or self.Min

    -- Contenedor
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -20, 0, 50)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Parent = parent

    -- Barra de fondo
    self.Track = Instance.new("Frame")
    self.Track.Size = UDim2.new(1, 0, 0, 6)
    self.Track.Position = UDim2.new(0, 0, 0.5, -3)
    self.Track.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.Track.Parent = self.Frame

    -- Barra de progreso
    self.Progress = Instance.new("Frame")
    self.Progress.Size = UDim2.new((self.Value - self.Min)/(self.Max - self.Min), 0, 1, 0)
    self.Progress.BackgroundColor3 = softUI.Themes:GetColor("Accent")
    self.Progress.Parent = self.Track

    -- Controlador
    self.Thumb = Instance.new("TextButton")
    self.Thumb.Size = UDim2.new(0, 16, 0, 16)
    self.Thumb.Position = UDim2.new(self.Progress.Size.X.Scale, -8, 0.5, -8)
    self.Thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    self.Thumb.Text = ""
    self.Thumb.Parent = self.Frame

    -- Texto de valor
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    self.ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    self.ValueLabel.TextColor3 = softUI.Themes:GetColor("Text")
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Parent = self.Frame

    -- Efectos
    softUI.Animations:ApplyRoundCorners(self.Track, 1)
    softUI.Animations:ApplyRoundCorners(self.Progress, 1)
    softUI.Animations:ApplyRoundCorners(self.Thumb, 1)

    -- Interacción
    local function updateValue(input)
        local relativeX = (input.Position.X - self.Track.AbsolutePosition.X) / self.Track.AbsoluteSize.X
        local value = math.clamp(
            math.floor((self.Min + (self.Max - self.Min) * relativeX) / self.Step + 0.5) * self.Step,
            self.Min, self.Max
        )
        
        if value ~= self.Value then
            self.Value = value
            self.ValueLabel.Text = tostring(value)
            self.Progress.Size = UDim2.new((value - self.Min)/(self.Max - self.Min), 0, 1, 0)
            self.Thumb.Position = UDim2.new(self.Progress.Size.X.Scale, -8, 0.5, -8)
            
            if options.Callback then
                options.Callback(value)
            end
        end
    end

    self.Thumb.MouseButton1Down:Connect(function()
        updateValue(game:GetService("UserInputService"):GetMouseLocation())
        
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                updateValue(input)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)

    return self
end

return Slider