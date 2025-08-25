local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- PARAMÈTRES
local AimbotEspEnabled = false
local TeamCheck = false
local AimbotFOV = 150
local DotSize = 5
local BLUE = Color3.fromRGB(0, 162, 255)

-- GUI D'ÉTAT
local statusGui = Instance.new("ScreenGui", game.CoreGui)
statusGui.Name = "Status_GUI"
local statusLabel = Instance.new("TextLabel", statusGui)
statusLabel.Position = UDim2.new(0, 10, 0.5, -60)
statusLabel.Size = UDim2.new(0, 200, 0, 120)
statusLabel.TextSize = 16
statusLabel.TextColor3 = BLUE
statusLabel.BackgroundTransparency = 1
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.SourceSansBold

local function updateStatus()
    statusLabel.Text =
        "[L] Aimbot/ESP: " .. (AimbotEspEnabled and "ON" or "OFF") .. "\n" ..
        "[T] Team Check: " .. (TeamCheck and "ON" or "OFF")
end
updateStatus()

-- FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = BLUE
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Filled = false
FOVCircle.Radius = AimbotFOV
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    local pos = UserInputService:GetMouseLocation()
    FOVCircle.Position = Vector2.new(pos.X, pos.Y)
    FOVCircle.Visible = AimbotEspEnabled
end)

-- ESP & AIMBOT
local Folder = Instance.new("Folder", game.CoreGui)
Folder.Name = "ESP_Blue_Dots"
local ActiveDots = {}
local Boxes = {}

local function CreateBox(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = BLUE
    box.Filled = false
    box.Visible = false
    Boxes[player] = box
end

local function RemoveBox(player)
    if Boxes[player] then
        Boxes[player]:Remove()
        Boxes[player] = nil
    end
end

local function UpdateBox(player, character)
    local box = Boxes[player]
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not box or not hrp then return end

    local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
    if onscreen then
        local size = Vector2.new(20, 40)
        local screenPos = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        local isSameTeam = player.Team == LocalPlayer.Team
        box.Position = screenPos
        box.Size = size
        box.Visible = AimbotEspEnabled and (not TeamCheck or not isSameTeam)
    else
        box.Visible = false
    end
end

local function CreateDot(player)
    if player == LocalPlayer then return end
    CreateBox(player)

    local function Setup(character)
        local head = character:FindFirstChild("Head")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not head or not hrp then return end

        -- DOT BLEU
        local dot = Instance.new("BillboardGui", Folder)
        dot.Adornee = head
        dot.Size = UDim2.new(0, DotSize, 0, DotSize)
        dot.AlwaysOnTop = true
        dot.LightInfluence = 0

        local frame = Instance.new("Frame", dot)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = BLUE
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0

        ActiveDots[player] = {Dot = dot, Head = head, Character = character}
        UpdateBox(player, character)

        -- HITBOX EXPANDER
        hrp.Size = Vector3.new(5, 5, 5)
        hrp.Transparency = 0.5
        hrp.Material = Enum.Material.Neon
        hrp.BrickColor = BrickColor.new("Bright blue")
        hrp.CanCollide = false
    end

    if player.Character then
        Setup(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        if ActiveDots[player] and ActiveDots[player].Dot then
            ActiveDots[player].Dot:Destroy()
        end
        ActiveDots[player] = nil
        Setup(char)
    end)

    player.CharacterRemoving:Connect(function(char)
        if ActiveDots[player] and ActiveDots[player].Character == char then
            if ActiveDots[player].Dot then ActiveDots[player].Dot:Destroy() end
            ActiveDots[player] = nil
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do CreateDot(p) end
Players.PlayerAdded:Connect(CreateDot)
Players.PlayerRemoving:Connect(function(p)
    if ActiveDots[p] and ActiveDots[p].Dot then
        ActiveDots[p].Dot:Destroy()
    end
    ActiveDots[p] = nil
    RemoveBox(p)
end)

-- ESP UPDATE
RunService.RenderStepped:Connect(function()
    for p, data in pairs(ActiveDots) do
        if not data.Head or not data.Head:IsDescendantOf(workspace) then
            if data.Dot then data.Dot:Destroy() end
            ActiveDots[p] = nil
            RemoveBox(p)
        else
            UpdateBox(p, data.Character)
        end
    end
end)

-- AIMBOT CLIC DROIT
RunService.RenderStepped:Connect(function()
    if AimbotEspEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, shortest = nil, AimbotFOV
        for player, data in pairs(ActiveDots) do
            local head = data.Head
            if head then
                local isSameTeam = player.Team == LocalPlayer.Team
                if not TeamCheck or not isSameTeam then
                    local screen, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screen.X, screen.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if dist < shortest then
                            closest = head
                            shortest = dist
                        end
                    end
                end
            end
        end

        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
        end
    end
end)

-- TOUCHE L = TOGGLE AIMBOT/ESP
-- TOUCHE T = TOGGLE TEAM CHECK
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.L then
        AimbotEspEnabled = not AimbotEspEnabled
        updateStatus()
    elseif input.KeyCode == Enum.KeyCode.T then
        TeamCheck = not TeamCheck
        updateStatus()
    end
end)
