local TweenService = game:GetService("TweenService")
local AnimationManager = {}

function AnimationManager:ApplyRoundCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(radius or 0.2, 0)
    corner.Parent = instance
end

function AnimationManager:SlideIn(instance, direction)
    local startPositions = {
        Left = UDim2.new(-0.5, 0, 0.5, 0),
        Right = UDim2.new(1.5, 0, 0.5, 0),
        Top = UDim2.new(0.5, 0, -0.5, 0)
    }
    
    instance.Position = startPositions[direction] or UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(
        instance,
        TweenInfo.new(0.7, Enum.EasingStyle.Quint),
        {Position = UDim2.new(0.5, 0, 0.5, 0)}
    ):Play()
end

return AnimationManager