local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 壁貫通（Noclip）機能
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
    -- 仮の座標: マップ外（例: ゲームの端や地下）。調整が必要
    local hiddenPosition = Vector3.new(1000, -50, 1000)  -- マップ外の推定座標
    TweenService:Create(RootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(hiddenPosition)}):Play()
    print("隠しエリアにテレポートしました！")
end

-- AIモンスター取得（自動購入＆盗む）
local function autoGetMonsters()
    -- ブレインロットの自動購入（例: レアモンスター）
    local monsters = {"Basic Brainrot", "Rare Spider", "Secret Cow", "Mutated Ikai"}
    for _, monster in ipairs(monsters) do
        game:GetService("ReplicatedStorage").Remotes.BuyBrainrot:FireServer(monster)
        wait(0.5)  -- サーバー負荷軽減
    end
    -- 全プレイヤーから自動盗む
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            game:GetService("ReplicatedStorage").Remotes.StealBrainrot:FireServer(player, "Random")
            wait(0.5)
        end
    end
end

-- GUIメニュー（最小化対応）
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MonsterList = Instance.new("ScrollingFrame")
local TeleportButton = Instance.new("TextButton")
local GetMonsterButton = Instance.new("TextButton")
local MenuIcon = Instance.new("TextButton") -- メニューアイコン

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Visible = false -- 初期状態で非表示（最小化）

Title.Parent = Frame
Title.Text = "ブレインロット制御パネル"
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
        print("召喚: " .. monster)
    end)
end

-- テレポートボタン
TeleportButton.Parent = Frame
TeleportButton.Position = UDim2.new(0, 0, 1, -60)
TeleportButton.Size = UDim2.new(1, 0, 0, 30)
TeleportButton.Text = "マップの裏に移動"
TeleportButton.MouseButton1Click:Connect(teleportToHiddenArea)

-- モンスター取得ボタン
GetMonsterButton.Parent = Frame
GetMonsterButton.Position = UDim2.new(0, 0, 1, -30)
GetMonsterButton.Size = UDim2.new(1, 0, 0, 30)
GetMonsterButton.Text = "全モンスター取得"
GetMonsterButton.MouseButton1Click:Connect(autoGetMonsters)

-- メニューアイコン（トグルボタン）
MenuIcon.Parent = ScreenGui
MenuIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MenuIcon.Position = UDim2.new(0.05, 0, 0.05, 0)
MenuIcon.Size = UDim2.new(0, 50, 0, 50)
MenuIcon.Text = "☰" -- メニューアイコン（ハンバーガーメニュー風）
MenuIcon.TextScaled = true
MenuIcon.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible -- メニューの表示/非表示を切り替え
    if Frame.Visible then
        MenuIcon.Text = "✖" -- メニュー表示中は閉じるアイコン
    else
        MenuIcon.Text = "☰" -- メニュー非表示時はメニューアイコン
    end
end)

-- 自動キャッシュ収集（おまけ）
local function autoCollect()
    while true do
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CollectCash:FireServer()
    end
end
spawn(autoCollect)

print("スクリプト読み込み完了: マップの裏に移動してAIモンスターを取得する準備ができました！メニューはアイコンで切り替え可能です！")
