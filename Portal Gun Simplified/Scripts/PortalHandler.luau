local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateDestroyPortal = ReplicatedStorage.CreateDestroyPortal -- The remote event for detecting portal creation and destruction
local UsefulFunctions = require(ReplicatedStorage.UsefulFunctions) -- An asset made by me to shorten code (this will be seen later)

-- This is a type for the portal part (A BasePart with a proximity prompt and a portal image as their children)
type PortalPart = BasePart & {ProximityPrompt: ProximityPrompt, PortalImage: Decal}

local Portal = ReplicatedStorage.Portal -- A basepart for showing the portal and interacting with it
local PortalImages = ReplicatedStorage.PortalImages -- A folder which hold the images of the portals
local PortalParts = workspace.PortalParts -- A folder which contains the portals

-- Fired whenever a player interacts with their portal gun
CreateDestroyPortal.OnServerEvent:Connect(function(player, command: string, raycastPos: Vector3)
	if command == "Blue" or command == "Orange" then -- If a portal is made, do this:
		-- Make a copy of the portal
		local portalPart: PortalPart = Portal:Clone()
		portalPart.Position = raycastPos
		
		-- Edit their proximity prompt to show the portal's owner
		portalPart.ProximityPrompt.ObjectText = player.Name.."'s portal"
		
		-- Give it the color it needs
		local portalDecal: Decal = PortalImages[command.."Portal"]:Clone()
		portalDecal.Parent = portalPart
		
		-- Give it the player tag
		portalPart:AddTag(player.Name)
		portalPart.Parent = PortalParts
		
		-- If the portal created was orange, then do this:
		if command == "Orange" then
			-- Define the other portal part
			local otherPortalPart: PortalPart = UsefulFunctions:GetChildrenWithTag(PortalParts, player.Name)
			
			for _, portal in ipairs(otherPortalPart) do
				if portal ~= portalPart then
					otherPortalPart = portal
					break
				end
			end
			
			-- Enable their proximity prompts
			portalPart.ProximityPrompt.Enabled = true
			otherPortalPart.ProximityPrompt.Enabled = true
			
			-- If the portal part's proximity prompt got triggered, then teleport the player to the other portal part
			portalPart.ProximityPrompt.Triggered:Connect(function(player)
				local humanoidRootPart = player.Character.PrimaryPart
				humanoidRootPart.CFrame = otherPortalPart.CFrame
			end)
			
			-- If the other portal part's proximity prompt got triggered, then teleport the player to the portal part
			otherPortalPart.ProximityPrompt.Triggered:Connect(function(player)
				local humanoidRootPart = player.Character.PrimaryPart
				humanoidRootPart.CFrame = portalPart.CFrame
			end)
		end
		
	elseif command == "Destroy" then -- Otherwise, if both portals are to be destroyed, destroy them
		local playerPortals = UsefulFunctions:GetChildrenWithTag(PortalParts, player.Name)
		
		for _, portal in ipairs(playerPortals) do
			portal:Destroy()
		end
		
	else -- If the given command is not defined, throw a warning
		warn("Unknown command!")
	end
end)
