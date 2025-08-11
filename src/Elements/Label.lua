local Label = {}
Label.__index = Label

function Label.new(softUI, parent, options)
    local self = setmetatable({}, Label)
    
    self.Label = Instance.new("TextLabel")
    self.Label.Text = options.Text or "Label"
    self.Label.Size = options.Size or UDim2.new(1, -20, 0, 20)
    self.Label.TextColor3 = softUI.Themes:GetColor(options.TextColor or "Text")
    self.Label.BackgroundTransparency = 1
    self.Label.Font = Enum.Font[options.Font or "Gotham"]
    self.Label.TextSize = options.TextSize or 14
    self.Label.TextXAlignment = options.Align or "Left"
    self.Label.Parent = parent
    
    return self
end

return Label