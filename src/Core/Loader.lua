local Loader = {}
Loader.__index = Loader

local TweenService = game:GetService("TweenService")

function Loader:Init(softUI)
    self.SoftUI = softUI
    self.LoaderGui = nil
end

-- Muestra la pantalla de carga
function Loader:Show(title, subtitle, options)
    -- Destruir loader existente
    if self.LoaderGui then
        self.LoaderGui:Destroy()
    end

    -- Configuración
    local config = {
        Title = title or "SoftUI",
        Subtitle = subtitle or "Cargando recursos...",
        Duration = options.Duration or 2,
        Theme = options.Theme or "Dark"
    }

    -- Crear GUI
    self.LoaderGui = Instance.new("ScreenGui")
    self.LoaderGui.Name = "SoftUILoader"
    self.LoaderGui.IgnoreGuiInset = true
    self.LoaderGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Fondo
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = self.SoftUI.Themes:GetColor("Primary")
    background.Parent = self.LoaderGui

    -- Contenido central
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 350, 0, 200)
    container.Position = UDim2.new(0.5, -175, 0.5, -100)
    container.BackgroundTransparency = 1
    container.Parent = self.LoaderGui

    -- Logo/Imagen
    if options.ImageUrl then
        local logo = Instance.new("ImageLabel")
        logo.Size = UDim2.new(0, 80, 0, 80)
        logo.Position = UDim2.new(0.5, -40, 0.2, -40)
        logo.Image = options.ImageUrl
        logo.Parent = container
    end

    -- Textos
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.Title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = self.SoftUI.Themes:GetColor("Text")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0.5, -30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = container

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Text = config.Subtitle
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 16
    subtitleLabel.TextColor3 = self.SoftUI.Themes:GetColor("TextSecondary")
    subtitleLabel.Size = UDim2.new(1, 0, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 0, 0.5, 10)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Parent = container

    -- Barra de progreso
    local progressBackground = Instance.new("Frame")
    progressBackground.Size = UDim2.new(0.7, 0, 0, 6)
    progressBackground.Position = UDim2.new(0.15, 0, 0.7, 0)
    progressBackground.BackgroundColor3 = self.SoftUI.Themes:GetColor("Secondary")
    progressBackground.Parent = container

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = self.SoftUI.Themes:GetColor("Accent")
    progressBar.Parent = progressBackground

    -- Animación de entrada
    container.Size = UDim2.new(0, 0, 0, 0)
    self.SoftUI.Animations:Tween(container, {
        Size = UDim2.new(0, 350, 0, 200)
    }, 0.5, Enum.EasingStyle.Back)

    -- Animación de progreso
    self.SoftUI.Animations:Tween(progressBar, {
        Size = UDim2.new(1, 0, 1, 0)
    }, config.Duration, Enum.EasingStyle.Linear)

    -- Auto-destrucción
    task.delay(config.Duration, function()
        self:Hide()
    end)
end

-- Oculta la pantalla de carga
function Loader:Hide()
    if self.LoaderGui then
        self.SoftUI.Animations:Tween(self.LoaderGui, {
            BackgroundTransparency = 1
        }, 0.5):Wait()
        
        self.LoaderGui:Destroy()
        self.LoaderGui = nil
    end
end

return Loader