local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 250) 
frame.Position = UDim2.new(0.5, -130, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui


local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0.15, 0)
speedLabel.Text = "현재 속도: " .. humanoid.WalkSpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = frame


local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0.8, 0, 0.15, 0)
speedSlider.Position = UDim2.new(0.1, 0, 0.2, 0)
speedSlider.PlaceholderText = "속도를 입력하세요"
speedSlider.Text = tostring(humanoid.WalkSpeed)
speedSlider.Parent = frame


local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0.8, 0, 0.15, 0)
applyButton.Position = UDim2.new(0.1, 0, 0.4, 0)
applyButton.Text = "적용하기"
applyButton.Parent = frame


local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.8, 0, 0.15, 0)
resetButton.Position = UDim2.new(0.1, 0, 0.6, 0)
resetButton.Text = "초기화"
resetButton.Parent = frame


local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0.12, 0)
creditLabel.Position = UDim2.new(0, 0, 0.85, 0)
creditLabel.Text = "제작 : 승호"
creditLabel.TextColor3 = Color3.new(1, 1, 1)
creditLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
creditLabel.Parent = frame


local isApplied = false
local defaultSpeed = 16  
applyButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(speedSlider.Text)
    if newSpeed and newSpeed > 0 then
        humanoid.WalkSpeed = newSpeed
        isApplied = true  
    end
end)


resetButton.MouseButton1Click:Connect(function()
    
    isApplied = false
    speedSlider.Text = tostring(defaultSpeed)  
    humanoid.WalkSpeed = defaultSpeed  
end)


local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.2, 0, 0.15, 0)
toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
toggleButton.Text = "-"
toggleButton.Parent = frame


local mark = Instance.new("TextButton")
mark.Size = UDim2.new(0, 40, 0, 40)
mark.Position = UDim2.new(0.5, -20, 0.5, -20) 
mark.Text = "S"
mark.TextColor3 = Color3.new(1, 1, 1)
mark.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
mark.Visible = false
mark.Active = true
mark.Draggable = true
mark.Parent = screenGui


local draggingMark = false
local lastClickTime = 0
local mouse = player:GetMouse()

mark.MouseButton1Down:Connect(function()
    draggingMark = true
    lastClickTime = tick()
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingMark and input.UserInputType == Enum.UserInputType.MouseMovement then
        mark.Position = UDim2.new(0, math.clamp(mouse.X - 20, 0, screenGui.AbsoluteSize.X - 40),
                                  0, math.clamp(mouse.Y - 20, 0, screenGui.AbsoluteSize.Y - 40))
    end
end)

mark.MouseButton1Up:Connect(function()
    if tick() - lastClickTime < 0.2 then
        frame.Visible = true
        mark.Visible = false
    end
    draggingMark = false
end)

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    mark.Visible = true
end)


humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if humanoid.WalkSpeed ~= tonumber(speedSlider.Text) then
        if isApplied then
            humanoid.WalkSpeed = tonumber(speedSlider.Text) or 16
        end
    end
end)


game:GetService("RunService").RenderStepped:Connect(function()
    if humanoid then
        speedLabel.Text = "현재 속도: " .. math.floor(humanoid.WalkSpeed)
    end
end)
