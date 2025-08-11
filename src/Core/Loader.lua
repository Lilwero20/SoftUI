local Loader = {}
Loader.__index = Loader

local TweenService = game:GetService("TweenService")

function Loader:Show(title, subtitle, options)
    local container = Instance.new("ScreenGui")
    container.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 200)
    frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = container
    
    -- Barra de progreso
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0, 4)
    progressBar.Position = UDim2.new(0, 0, 1, -4)
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    progressBar.Parent = frame
    
    TweenService:Create(
        progressBar,
        TweenInfo.new(options.Duration or 2),
        {Size = UDim2.new(1, 0, 0, 4)}
    ):Play()
    
    task.delay(options.Duration or 2, function()
        container:Destroy()
    end)
end

return Loader