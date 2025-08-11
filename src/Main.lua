local SoftUI = {}
SoftUI.__index = SoftUI
SoftUI.Version = "1.2.0"

-- Servicios
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Módulos principales
local function LoadModule(moduleName)
    return loadstring(game:HttpGetAsync(
        "https://raw.githubusercontent.com/Lilwero20/SoftUI/main/src/"..moduleName..".lua"
    ))()
end

function SoftUI:Init(options)
    -- Configuración predeterminada
    local config = {
        LoadingTitle = options.LoadingTitle or "SoftUI",
        LoadingSubtitle = options.LoadingSubtitle or "Cargando interfaz...",
        DefaultTheme = options.DefaultTheme or "Dark",
        LoadingDuration = options.LoadingDuration or 2,
        DebugMode = options.DebugMode or false
    }

    local self = setmetatable({}, SoftUI)
    self.Config = config
    self.Elements = {}
    self.Plugins = {}

    -- Cargar módulos esenciales
    self.Loader = LoadModule("Core/Loader")
    self.Themes = LoadModule("Core/ThemeManager")
    self.Animations = LoadModule("Core/AnimationManager")
    self.Icons = LoadModule("Core/IconManager")
    self.Events = LoadModule("Core/EventManager")

    -- Inicializar subsistemas
    self.Themes:Init(self)
    self.Animations:Init(self)
    self.Icons:Preload()

    -- Mostrar pantalla de carga
    self.Loader:Show(
        config.LoadingTitle,
        config.LoadingSubtitle,
        {
            Duration = config.LoadingDuration,
            Theme = config.DefaultTheme
        }
    )

    -- Cargar tema predeterminado
    if not self.Themes:LoadTheme(config.DefaultTheme) then
        warn("[SoftUI] Falló al cargar el tema predeterminado. Usando valores de respaldo.")
    end

    -- Precargar elementos comunes
    if not config.DebugMode then
        self:_PreloadAssets()
    end

    return self
end

-- Métodos principales
function SoftUI:CreateWindow(options)
    local Window = LoadModule("Elements/Window")
    local window = Window.new(self, options)
    table.insert(self.Elements, window)
    return window
end

function SoftUI:SetTheme(themeName)
    return self.Themes:LoadTheme(themeName)
end

function SoftUI:Notify(title, message, notificationType)
    local Notification = LoadModule("Elements/Notification")
    return Notification.new(self, title, message, notificationType)
end

-- Funciones internas
function SoftUI:_PreloadAssets()
    -- Precargar íconos y temas para mejor rendimiento
    task.spawn(function()
        local assetsToPreload = {
            self.Icons:GetIcon("close"),
            self.Icons:GetIcon("dropdown_arrow")
        }
        game:GetService("ContentProvider"):PreloadAsync(assetsToPreload)
    end)
end

-- Registro de plugins
function SoftUI:RegisterPlugin(name, pluginFunction)
    if type(pluginFunction) == "function" then
        self.Plugins[name] = pluginFunction
        return true
    end
    return false
end

return SoftUI