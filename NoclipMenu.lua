local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local noclipEnabled = false
local isAdminAuthenticated = false  -- 管理者認証状態
local connection
local CORRECT_PASSWORD = "15240"  -- 管理者パスワード

-- RemoteEvent設定
local TeleportPlayerRemote = Instance.new("RemoteEvent")
TeleportPlayerRemote.Name = "TeleportPlayerRequest"
TeleportPlayerRemote.Parent = ReplicatedStorage

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

-- 島の形変更機能
local function changeIslandShape()
    local terrain = Workspace.Terrain
    if terrain then
        local center = character.HumanoidRootPart.Position  -- プレイヤー位置を中心
        local radius = math.random(10, 30)  -- ランダム半径
        local material = Enum.Material.Grass  -- 地形素材
        terrain:FillBall(center, radius, material)
        print("島の形を変更しました！ 半径: " .. radius)
    else
        print("Terrainが見つかりません")
    end
end

-- GUIメニュー作成（Androidタッチ対応）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "NoclipMenu"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 350)  -- フレーム高さを全要素対応で350
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
Frame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "Noclip & Admin Menu"
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -90, 0.1, -20)
ToggleButton.Text = "Noclip: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame

local ChangeIslandButton = Instance.new("TextButton")
ChangeIslandButton.Size = UDim2.new(0, 180, 0, 40)
ChangeIslandButton.Position = UDim2.new(0.5, -90, 0.25, -20)
ChangeIslandButton.Text = "Change Island Shape"
ChangeIslandButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ChangeIslandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeIslandButton.TextScaled = true
ChangeIslandButton.Parent = Frame

local PasswordInput = Instance.new("TextBox")
PasswordInput.Size = UDim2.new(0, 180, 0, 40)
PasswordInput.Position = UDim2.new(0.5, -90, 0.4, -20)
PasswordInput.Text = "パスワードを入力 (15240)"
PasswordInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PasswordInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PasswordInput.TextScaled = true
PasswordInput.ClearTextOnFocus = true
PasswordInput.Parent = Frame

local PlayerNameInput = Instance.new("TextBox")
PlayerNameInput.Size = UDim2.new(0, 180, 0, 40)
PlayerNameInput.Position = UDim2.new(0, -90, 0.55, -20)
PlayerNameInput.Text = "プレイヤー名を入力"
PlayerNameInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PlayerNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameInput.TextScaled = true
PlayerNameInput.ClearTextOnFocus = true
PlayerNameInput.Parent = Frame

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 180, 0, 40)
TeleportButton.Position = UDim2.new(0.5, -90, 0.7, -20)
TeleportButton.Text = "Teleport Player (認証必要)"
TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextScaled = true
TeleportButton.Active = false  -- 初期無効
TeleportButton.Parent = Frame

local AuthButton = Instance.new("TextButton")
AuthButton.Size = UDim2.new(0, 180, 0, 40)
AuthButton.Position = UDim2.new(0.5, -90, 0.85, -20)
AuthButton.Text = "認証"
AuthButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
AuthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AuthButton.TextScaled = true
AuthButton.Parent = Frame

-- ボタンクリック処理（Noclip）
ToggleButton.MouseButton1Click:Connect(function()
    toggleNoclip()
    ToggleButton.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
end)

-- 島変更ボタンクリック処理
ChangeIslandButton.MouseButton1Click:Connect(changeIslandShape)

-- パスワード認証処理
AuthButton.MouseButton1Click:Connect(function()
    local inputPassword = PasswordInput.Text
    if inputPassword == CORRECT_PASSWORD then
        isAdminAuthenticated = true
        TeleportButton.Active = true
        TeleportButton.Text = "Teleport Player"
        TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        PasswordInput.Text = "認証済み"
        PasswordInput.Active = false
        print("管理者認証成功")
    else
        isAdminAuthenticated = false
        TeleportButton.Active = false
        TeleportButton.Text = "Teleport Player (認証必要)"
        TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        PasswordInput.Text = "パスワード不正"
        print("パスワードが間違っています")
    end
end)

-- テレポートボタンクリック処理
TeleportButton.MouseButton1Click:Connect(function()
    if isAdminAuthenticated and character and character.HumanoidRootPart then
        local targetPlayerName = PlayerNameInput.Text
        if targetPlayerName and targetPlayerName ~= "" and targetPlayerName ~= "プレイヤー名を入力" then
            TeleportPlayerRemote:FireServer(targetPlayerName, character.HumanoidRootPart.Position)
            print("テレポートリクエスト送信: " .. targetPlayerName)
        else
            print("有効なプレイヤー名を入力してください")
        end
    else
        print("認証が必要ですまたはキャラクターが見つかりません")
    end
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

print("GitHub Noclip & Adminメニュー起動！ パスワード15240で認証後、テレポート可能")
