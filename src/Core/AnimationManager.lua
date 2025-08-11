local AnimationManager = {}
AnimationManager.__index = AnimationManager

local TweenService = game:GetService("TweenService")

function AnimationManager:Init()
    self.Tweens = {}
end

function AnimationManager:Tween(instance, properties, duration, easingStyle)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.5, easingStyle or Enum.EasingStyle.Quad),
        properties
    )
    tween:Play()
    table.insert(self.Tweens, tween)
    return tween
end

function AnimationManager:ApplyRoundCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(radius or 0.2, 0)
    corner.Parent = instance
end

return AnimationManager
