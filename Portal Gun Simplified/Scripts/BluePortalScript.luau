local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportPlayer = ReplicatedStorage.TeleportPlayer -- A bindable event for teleporting the player between portals

-- This is a type for the portal part (A BasePart with a proximity prompt and a portal image as their children)
type PortalPart = BasePart & {ProximityPrompt: ProximityPrompt, PortalImage: Decal}

local BluePortalPart: PortalPart = script.Parent
local BleProxPrompt = BluePortalPart.ProximityPrompt

-- Enable the proximity prompt
BleProxPrompt.Enabled = true

-- If the player enters through the blue portal, teleport him to the orange portal
BleProxPrompt.Triggered:Connect(function(player)
	TeleportPlayer:Fire(player, "Orange")
end)

-- If the player enters through the orange portal, teleport him to the blue portal
TeleportPlayer.Event:Connect(function(player: Player, color: string)
	if color == "Orange" then return end
	
	local humanoidRootPart = player.Character.PrimaryPart
	humanoidRootPart.CFrame = BluePortalPart.CFrame
end)
