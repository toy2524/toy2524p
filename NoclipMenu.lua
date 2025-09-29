-- Android対応Noclipスクリプト（メニュー形式） - GitHubホスト版
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local noclipEnabled = false
local connection

-- Noclip機能
local function noclip()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Noclipトグル
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        print("Noclip ON - 壁貫通有効")
    else
        print("Noclip OFF - 壁貫通無効")
    end
end

-- GUIメニュー作成（Androidタッチ対応）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "NoclipMenu"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 10, 0, 10)  -- 左上に配置（Android画面に合わせ調整）
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
Frame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "Noclip Menu"
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -90, 0.5, -20)
ToggleButton.Text = "Noclip: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame

-- ボタンクリック処理
ToggleButton.MouseButton1Click:Connect(function()
    toggleNoclip()
    ToggleButton.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
end)

-- Noclip実行ループ
connection = RunService.Stepped:Connect(function()
    if noclipEnabled then
        noclip()
    end
end)

-- キャラクター再生成対応
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

print("GitHub Noclipメニュー起動！ ボタンをタップで切り替え")
