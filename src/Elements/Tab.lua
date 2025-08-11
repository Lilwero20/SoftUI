local Tab = {}
Tab.__index = Tab

function Tab.new(softUI, window, options)
    local self = setmetatable({}, Tab)
    self.SoftUI = softUI
    self.Window = window
    self.Name = options.Name or "Nueva Pestaña"
    self.Icon = options.Icon

    -- Contenedor de contenido
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, -10, 1, -10)
    self.Container.Position = UDim2.new(0, 5, 0, 5)
    self.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Container.ScrollBarThickness = 5
    self.Container.BackgroundTransparency = 1
    self.Container.Visible = false
    self.Container.Parent = window.ContentContainer

    -- Botón de pestaña
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Text = self.Icon and "" or self.Name
    self.TabButton.Size = UDim2.new(1, -10, 0, 30)
    self.TabButton.Position = UDim2.new(0, 5, 0, #window.Tabs * 35 + 5)
    self.TabButton.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.TabButton.TextColor3 = softUI.Themes:GetColor("Text")
    self.TabButton.Parent = window.TabContainer

    -- Ícono opcional
    if self.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Image = softUI.Icons:GetIcon(self.Icon)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0.5, -10, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Parent = self.TabButton
    end

    -- Efectos interactivos
    softUI.Animations:SetupButtonEffects(self.TabButton)
    softUI.Animations:ApplyRoundCorners(self.TabButton, 0.1)

    self.TabButton.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)

    return self
end

function Tab:AddSection(title)
    local section = {}
    section.Title = title

    -- Marco de sección
    section.Frame = Instance.new("Frame")
    section.Frame.Size = UDim2.new(1, 0, 0, 0)
    section.Frame.AutomaticSize = Enum.AutomaticSize.Y
    section.Frame.BackgroundColor3 = self.SoftUI.Themes:GetColor("Primary")
    section.Frame.Parent = self.Container

    -- Título de sección
    section.TitleLabel = Instance.new("TextLabel")
    section.TitleLabel.Text = title
    section.TitleLabel.Size = UDim2.new(1, -10, 0, 25)
    section.TitleLabel.Position = UDim2.new(0, 5, 0, 5)
    section.TitleLabel.TextColor3 = self.SoftUI.Themes:GetColor("Text")
    section.TitleLabel.Font = Enum.Font.GothamBold
    section.TitleLabel.BackgroundTransparency = 1
    section.TitleLabel.Parent = section.Frame

    -- Contenido
    section.Content = Instance.new("Frame")
    section.Content.Size = UDim2.new(1, -10, 0, 0)
    section.Content.Position = UDim2.new(0, 5, 0, 30)
    section.Content.AutomaticSize = Enum.AutomaticSize.Y
    section.Content.BackgroundTransparency = 1
    section.Content.Parent = section.Frame

    -- Aplicar estilos
    self.SoftUI.Animations:ApplyRoundCorners(section.Frame, 0.1)

    -- Espaciado entre secciones
    if #self.Container:GetChildren() > 1 then
        section.Frame.Position = UDim2.new(0, 0, 0, #self.Container:GetChildren() * 40)
    end

    return section
end

return Tab