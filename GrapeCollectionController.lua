
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local grapes = workspace.Grapes
local hrp = char:WaitForChild("HumanoidRootPart")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local humanoid = char:WaitForChild("Humanoid")
local GrapeCollectionService = replicatedStorage.Remotes.CollectGrape

local function movement(bool)
	humanoid.WalkSpeed = bool and 0 or 16
end

local function nearestGrape()
	local nearestGrape = nil
	local shortestDistance = math.huge
	for _, grape in grapes:GetChildren() do
		local distance = (grape.Position - hrp.Position).Magnitude
		if distance < shortestDistance then
			shortestDistance = distance
			nearestGrape = grape
		end
	end

	return shortestDistance
end

local GrapeCollection = {}

local CanCollect = false
runService.Heartbeat:Connect(function(DeltaTime)
	local distance = nearestGrape()
	if distance < 10 then
CanCollect = true
	else
		CanCollect = false
	end
end)

UIS.InputBegan:Connect(function(input,proccesed)
	if proccesed then return end
	if  input.KeyCode == Enum.KeyCode.E  then
		if CanCollect then
			print("collecting")
			movement(true)
			CanCollect = false
			task.delay(2,function()
				print("collected")
				GrapeCollectionService:FireServer()
				movement(false)
				CanCollect = true
			end)
		end
	end
end)

return GrapeCollection
