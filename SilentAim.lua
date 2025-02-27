-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variables
local silentAimActive = false
local currentTarget = nil -- Current target for ESP

-- Function to get the nearest target's head
local function getNearestHead()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        return closestPlayer.Character.Head, closestPlayer
    end

    return nil, nil
end

-- Silent aim functionality with headshots
local function silentAimHandler()
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and silentAimActive then
            local targetHead, closestPlayer = getNearestHead()
            if targetHead then
                local aimPosition = targetHead.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPosition)
                ReplicatedStorage.Remotes.Attack:FireServer(targetHead)
            end
        end
    end)
end

-- Activation du Silent Aim via le toggle de l'UI
local function activateSilentAim()
    silentAimActive = true
    silentAimHandler() -- Commence à écouter pour les clics de souris si activé
    print("Silent Aim activated")
end

local function deactivateSilentAim()
    silentAimActive = false
    print("Silent Aim deactivated")
end

-- Exposer les fonctions pour être appelées depuis l'UI
return {
    activateSilentAim = activateSilentAim,
    deactivateSilentAim = deactivateSilentAim
}
