local TweenService = game:GetService("TweenService")
local AnimationManager = {}

-- Efecto de pulsación (para botones)
function AnimationManager:PressEffect(instance)
    local originalSize = instance.Size
    local originalPos = instance.Position
    
    instance.MouseButton1Down:Connect(function()
        TweenService:Create(instance, TweenInfo.new(0.1), {
            Size = originalSize - UDim2.new(0, 5, 0, 5),
            Position = originalPos + UDim2.new(0, 2.5, 0, 2.5)
        }):Play()
    end)
    
    instance.MouseButton1Up:Connect(function()
        TweenService:Create(instance, TweenInfo.new(0.2, Enum.EasingStyle.Back)), {
            Size = originalSize,
            Position = originalPos
        }):Play()
    end)
end

-- Fade in/out avanzado
function AnimationManager:Fade(instance, targetTransparency, duration)
    return TweenService:Create(instance, TweenInfo.new(duration or 0.3)), {
        BackgroundTransparency = targetTransparency
    })
end

return AnimationManager
