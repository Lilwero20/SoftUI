local Tab = {}
Tab.__index = Tab

function Tab.new(softUI, window, tabName)
    local self = setmetatable({}, Tab)
    self.SoftUI = softUI
    self.Window = window
    self.Name = tabName
    self.Buttons = {}
    self.Sections = {}

    -- Crear contenedor de pestaña
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, -170, 1, -40) -- Ajustar según diseño
    self.Frame.Position = UDim2.new(0, 160, 0, 30)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Visible = false
    self.Frame.Parent = self.Window.MainFrame

    -- Crear botón de pestaña en la barra lateral
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Text = tabName
    self.TabButton.Size = UDim2.new(1, -10, 0, 30)
    self.TabButton.Position = UDim2.new(0, 5, 0, #self.Window.Tabs * 35 + 5)
    self.TabButton.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.TabButton.TextColor3 = softUI.Themes:GetColor("Text")
    self.TabButton.Font = Enum.Font.GothamMedium
    self.TabButton.TextSize = 14
    self.TabButton.Parent = self.Window.TabContainer

    softUI.Animations:ApplyRoundCorners(self.TabButton, 0.1)

    -- Efectos hover/interacción
    self.TabButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            self.TabButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = softUI.Themes:GetColor("Accent"):Lerp(Color3.new(1,1,1), 0.3)}
        ):Play()
    end)

    self.TabButton.MouseLeave:Connect(function()
        if not self.Active then
            game:GetService("TweenService"):Create(
                self.TabButton,
                TweenInfo.new(0.2),
                {BackgroundColor3 = softUI.Themes:GetColor("Secondary")}
            ):Play()
        end
    end)

    -- Lógica de selección
    self.TabButton.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)

    return self
end

-- Métodos para añadir elementos a la pestaña
function Tab:CreateSection(title)
    local section = {
        Title = title,
        Frame = Instance.new("Frame")
    }
    
    section.Frame.Size = UDim2.new(1, -20, 0, 0) -- Altura se ajusta automáticamente
    section.Frame.Position = UDim2.new(0, 10, 0, #self.Sections * 40 + 10)
    section.Frame.BackgroundColor3 = self.SoftUI.Themes:GetColor("Secondary")
    section.Frame.AutomaticSize = Enum.AutomaticSize.Y
    section.Frame.Parent = self.Frame

    self.SoftUI.Animations:ApplyRoundCorners(section.Frame, 0.1)

    -- Título de la sección
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.TextColor3 = self.SoftUI.Themes:GetColor("Text")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = "Left"
    titleLabel.Parent = section.Frame

    -- Contenedor de elementos
    section.Content = Instance.new("Frame")
    section.Content.Size = UDim2.new(1, -10, 0, 0)
    section.Content.Position = UDim2.new(0, 5, 0, 30)
    section.Content.BackgroundTransparency = 1
    section.Content.AutomaticSize = Enum.AutomaticSize.Y
    section.Content.Parent = section.Frame

    table.insert(self.Sections, section)
    return section
end

-- Métodos abreviados para crear elementos dentro de secciones
function Tab:CreateButton(options)
    local lastSection = self.Sections[#self.Sections]
    if not lastSection then
        lastSection = self:CreateSection("General")
    end
    return self.SoftUI.Elements.Button.new(self.SoftUI, lastSection.Content, options)
end

function Tab:CreateToggle(options)
    -- Similar al de botón pero para toggles
end

return Tab