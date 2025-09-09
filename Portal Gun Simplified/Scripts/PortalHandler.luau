local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateDestroyPortal = ReplicatedStorage.CreateDestroyPortal -- The remote event for detecting portal creation and destruction

-- This is a type for the portal part (A BasePart with a proximity prompt and a portal image as their children)
type PortalPart = BasePart & {ProximityPrompt: ProximityPrompt, PortalImage: Decal}

local Portal = ReplicatedStorage.Portal -- A basepart for showing the portal and interacting with it
local PortalImages = ReplicatedStorage.PortalImages -- A folder which hold the images of the portals
local PortalScripts = ReplicatedStorage.PortalScripts -- A folder which hold the scripts for the portals
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
		
		-- Give it the script it needs
		local portalScript: Script = PortalScripts[command.."PortalScript"]:Clone()
		portalScript.Parent = portalPart
		
		-- Give it the player tag
		portalPart:AddTag(player.Name)
		portalPart.Parent = PortalParts
		
		-- If it was an orange portal, allow the player to teleport between them by enabling the scripts
		if command == "Orange" then
			-- Define the other portal part
			local otherPortalPart: PortalPart? = nil
			
			for _, part in ipairs(PortalParts:GetChildren()) do
				if part:HasTag(player.Name) and part ~= portalPart then
					otherPortalPart = part
					break
				end
			end
			
			-- Enable their scripts
			portalPart:FindFirstChildWhichIsA("Script").Enabled = true
			otherPortalPart:FindFirstChildWhichIsA("Script").Enabled = true
		end
		
	elseif command == "Destroy" then -- Otherwise, if both portals are to be destroyed, destroy them
		-- Don't destroy them instantly to give time for the loop to pass
		for _, portal in ipairs(PortalParts:GetChildren()) do
			if portal:HasTag(player.Name) then
				task.delay(0.05, function()
					portal:Destroy()
				end)
			end
		end
		
	else -- If the given command is not defined, throw a warning
		warn("Unknown command!")
	end
end)
