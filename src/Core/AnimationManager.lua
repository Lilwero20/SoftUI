local AnimationManager = {}
AnimationManager.__index = AnimationManager

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

function AnimationManager:Init(softUI)
    self.SoftUI = softUI
    self.ActiveTweens = {}
end

-- Animación básica con configuración flexible
function AnimationManager:Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    
    -- Gestión automática de tweens activos
    table.insert(self.ActiveTweens, tween)
    tween.Completed:Connect(function()
        table.remove(self.ActiveTweens, table.find(self.ActiveTweens, tween))
    end)
    
    return tween
end

-- Efectos predefinidos
function AnimationManager:ApplyRoundCorners(instance, cornerRadius, topLeft, topRight, bottomLeft, bottomRight)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(cornerRadius or 0.2, 0)
    
    if topLeft ~= nil then
        corner:SetCornerRadius(Enum.Corner.TopLeft, topLeft and cornerRadius or 0)
    end
    -- Repetir para otros corners...
    
    corner.Parent = instance
    return corner
end

-- Efecto de "shake" para errores
function AnimationManager:Shake(instance, intensity, duration)
    intensity = intensity or 5
    duration = duration or 0.5
    
    local originalPos = instance.Position
    local shakeCount = 0
    local maxShakes = 8
    
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        shakeCount = shakeCount + dt * (maxShakes / duration)
        if shakeCount >= maxShakes then
            connection:Disconnect()
            instance.Position = originalPos
            return
        end
        
        local offset = UDim2.new(
            math.sin(shakeCount * math.pi * 2) * intensity / 100,
            0,
            math.cos(shakeCount * math.pi * 2) * intensity / 100,
            0
        )
        instance.Position = originalPos + offset
    end)
end

-- Efectos para botones (hover/click)
function AnimationManager:SetupButtonEffects(button)
    local originalSize = button.Size
    local originalPos = button.Position
    local originalColor = button.BackgroundColor3
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        self:Tween(button, {
            BackgroundColor3 = originalColor:Lerp(Color3.new(1,1,1), 0.1),
            Size = originalSize + UDim2.new(0,2,0,2),
            Position = originalPos - UDim2.new(0,1,0,1)
        }, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        self:Tween(button, {
            BackgroundColor3 = originalColor,
            Size = originalSize,
            Position = originalPos
        }, 0.2)
    end)
    
    -- Efecto click
    button.MouseButton1Down:Connect(function()
        self:Tween(button, {
            BackgroundColor3 = originalColor:Lerp(Color3.new(0,0,0), 0.2),
            Size = originalSize - UDim2.new(0,2,0,2),
            Position = originalPos + UDim2.new(0,1,0,1)
        }, 0.1)
    end)
end

return AnimationManager