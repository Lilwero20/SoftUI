local Window = {}
Window.__index = Window

function Window.new(softUI, options)
    local self = setmetatable({}, Window)
    self.SoftUI = softUI
    
    -- Crear instancias
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = softUI.Themes:GetColor("Primary")
    self.MainFrame.Parent = self.ScreenGui
    
    -- Aplicar animación y esquinas redondeadas
    softUI.Animations:ApplyRoundCorners(self.MainFrame, 0.15)
    softUI.Animations:SlideIn(self.MainFrame, "Center", 0.7)
    
    return self
end

return Window