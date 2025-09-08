local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateDestroyPortal = ReplicatedStorage.CreateDestroyPortal -- The remote event for creating and destroying portals

local playerMouse = Players.LocalPlayer:GetMouse()

local Tool = script.Parent
local Raycaster = Tool.Part.Raycaster -- An attachment in front of the portal gun used for raycasting

local PortalParts = workspace.PortalParts -- A folder containing the portals
local Wall = workspace.Wall

Tool.Activated:Connect(function()
	-- The amount of portals currently placed
	local portals = #PortalParts:GetChildren()
	
	-- If both portals are already placed, then destroy both of them
	if portals == 2 then
		CreateDestroyPortal:FireServer("Destroy")
		return
	end
	
	local rayOrigin = Raycaster.Position -- Where the ray begins
	local direction = (playerMouse.Hit.Position - rayOrigin).Unit * 100 -- In which direction to raycast
	
	-- Filter for raycasting (only cares about hitting Wall1 and Wall2)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {Wall}
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	
	-- If the ray hit the wall, then it will return a raycast result
	local raycastResult = workspace:Raycast(rayOrigin, direction, raycastParams)
	
	if portals == 0 then -- If no portals placed and the ray hit the wall, then place a blue portal
		if raycastResult then
			CreateDestroyPortal:FireServer("Blue", raycastResult.Position)
		end
		
	elseif portals == 1 then -- If 1 portal placed and the ray hit the wall, then place an orange portal
		if raycastResult then
			CreateDestroyPortal:FireServer("Orange", raycastResult.Position)
		end
	end
end)
