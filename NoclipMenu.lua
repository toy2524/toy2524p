-- Steal a Brainrot: Go Behind Map & Get AI Monster (Delta Executor)
-- 教育的参考用。使用は自己責任。

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Noclip (壁貫通) 機能
local function enableNoclip()
    local function noclip()
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    RunService.Stepped:Connect(noclip)
end
enableNoclip()

-- マップの裏にテレポート（隠しエリアの例座標）
local function teleportToHiddenArea()
    -- 仮の座標: マップ外（例: ゲームの端や地下）。要調整
    local hiddenPosition = Vector3.new(1000, -50, 1000)  -- マップ外の推定座標
    TweenService:Create(RootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(hiddenPosition)}):Play()
    print("Teleported to hidden area!")
end

-- AIモンスターゲット（Auto Buy & Steal）
local function autoGetMonsters()
    -- Auto Buy Brainrot（例: レアモンスター）
    local monsters = {"Basic Brainrot", "Rare Spider", "Secret Cow", "Mutated Ikai"}
    for _, monster in ipairs(monsters) do
        game:GetService("ReplicatedStorage").Remotes.BuyBrainrot:FireServer(monster)
        wait(0.5)  -- サーバー負荷軽減
    end
    -- Auto Steal from all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            game:GetService("ReplicatedStorage").Remotes.StealBrainrot:FireServer(player, "Random")
            wait(0.5)
        end
    end
end

-- GUIメニュー（モンスター選択）
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MonsterList = Instance.new("ScrollingFrame")
local TeleportButton = Instance.new("TextButton")
local GetMonsterButton = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 300, 0, 400)
Title.Parent = Frame
Title.Text = "Brainrot Control Panel"
Title.Size = UDim2.new(1, 0, 0, 30)

MonsterList.Parent = Frame
MonsterList.Position = UDim2.new(0, 0, 0, 30)
MonsterList.Size = UDim2.new(1, 0, 1, -60)

-- モンスター選択ボタン
local monsters = {"Basic Brainrot", "Rare Spider", "Secret Cow", "Mutated Ikai"}
for i, monster in ipairs(monsters) do
    local btn = Instance.new("TextButton")
    btn.Parent = MonsterList
    btn.Text = monster
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (i-1)*35)
    btn.MouseButton1Click:Connect(function()
        game:GetService("ReplicatedStorage").Remotes.BuyBrainrot:FireServer(monster)
        print("Spawned: " .. monster)
    end)
end

-- テレポートボタン
TeleportButton.Parent = Frame
TeleportButton.Position = UDim2.new(0, 0, 1, -60)
TeleportButton.Size = UDim2.new(1, 0, 0, 30)
TeleportButton.Text = "Go Behind Map"
TeleportButton.MouseButton1Click:Connect(teleportToHiddenArea)

-- モンスターゲットボタン
GetMonsterButton.Parent = Frame
GetMonsterButton.Position = UDim2.new(0, 0, 1, -30)
GetMonsterButton.Size = UDim2.new(1, 0, 0, 30)
GetMonsterButton.Text = "Get All Monsters"
GetMonsterButton.MouseButton1Click:Connect(autoGetMonsters)

-- Auto Collect Cash（おまけ）
local function autoCollect()
    while true do
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CollectCash:FireServer()
    end
end
spawn(autoCollect)

print("Script Loaded: Ready to go behind map and get AI monsters!")
