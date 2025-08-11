local Tab = {}
Tab.__index = Tab

function Tab.new(softUI, window, options)
    local self = setmetatable({}, Tab)
    self.SoftUI = softUI
    self.Window = window
    self.Name = options.Name or "Nueva Pestaña"
    self.Icon = options.Icon
    
    -- Contenedor principal (autoajustable)
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, -10, 1, -40)
    self.Container.Position = UDim2.new(0, 5, 0, 35)
    self.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Container.ScrollingDirection = Enum.ScrollingDirection.Y
    self.Container.BackgroundTransparency = 1
    self.Container.Visible = false
    self.Container.Parent = window.MainFrame

    -- Botón de pestaña (con ícono opcional)
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Text = self.Icon and "" or self.Name
    self.TabButton.Size = UDim2.new(1, -10, 0, 30)
    self.TabButton.Position = UDim2.new(0, 5, 0, #window.Tabs * 35 + 5)
    self.TabButton.Parent = window.TabContainer
    
    if self.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Image = softUI.Icons:GetIcon(self.Icon)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0.5, -10, 0.5, -10)
        icon.Parent = self.TabButton
    end

    -- Efectos interactivos
    softUI.Animations:SetupButtonEffects(self.TabButton)
    
    self.TabButton.MouseButton1Click:Connect(function()
        window:SelectTab(self)
    end)
    
    return self
end

function Tab:AddSection(title)
    -- Lógica para secciones colapsables
end
