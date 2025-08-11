local Window = {}
Window.__index = Window

function Window.new(softUI, options)
    local self = setmetatable({}, Window)
    self.SoftUI = softUI
    self.Tabs = {}
    self.ActiveTab = nil

    -- Crear GUI principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SoftUIWindow"
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Marco principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = options.Size or UDim2.new(0, 600, 0, 400)
    self.MainFrame.BackgroundColor3 = softUI.Themes:GetColor("Primary")
    self.MainFrame.Parent = self.ScreenGui

    -- Barra de título
    self.TitleBar = Instance.new("TextLabel")
    self.TitleBar.Text = options.Title or "Ventana SoftUI"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.TitleBar.TextColor3 = softUI.Themes:GetColor("Text")
    self.TitleBar.Font = Enum.Font.GothamBold
    self.TitleBar.Parent = self.MainFrame

    -- Contenedor de pestañas
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(0, 150, 1, -30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundColor3 = softUI.Themes:GetColor("Secondary")
    self.TabContainer.Parent = self.MainFrame

    -- Contenedor de contenido
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Size = UDim2.new(1, -150, 1, -30)
    self.ContentContainer.Position = UDim2.new(0, 150, 0, 30)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame

    -- Aplicar efectos
    softUI.Animations:ApplyRoundCorners(self.MainFrame, 0.15)
    softUI.Animations:ApplyRoundCorners(self.TitleBar, 0.15, true, false, true, false)
    softUI.Animations:SlideIn(self.MainFrame, "Top")

    return self
end

function Window:CreateTab(tabName, icon)
    local Tab = require(script.Parent.Tab)
    local newTab = Tab.new(self.SoftUI, self, {Name = tabName, Icon = icon})
    table.insert(self.Tabs, newTab)
    
    if #self.Tabs == 1 then
        self:SelectTab(newTab)
    end
    
    return newTab
end

function Window:SelectTab(tab)
    if self.ActiveTab then
        self.ActiveTab.Container.Visible = false
        self.SoftUI.Animations:Fade(self.ActiveTab.TabButton, 0.5):Play()
    end
    
    self.ActiveTab = tab
    tab.Container.Visible = true
    self.SoftUI.Animations:Fade(tab.TabButton, 0):Play()
end

return Window