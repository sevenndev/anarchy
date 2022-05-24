local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UI = Venyx.new({
    title = "Anarchy Hub - Murder Mystery 2"
})

local LocalPlayerPage = UI:addPage({
    title = "Local Player"
})

local TeleportsPage = UI:addPage({
    title = "Teleports"
})

local EmotesPage = UI:addPage({
    title = "Emotes"
})

local VisualsPage = UI:addPage({
    title = "ESP"
})

local LocalPlayerSection = LocalPlayerPage:addSection({
    title = "Local Player"
})

local TeleportsSection = TeleportsPage:addSection({
    title = "Teleports"
})

local EmotesSection = EmotesPage:addSection({
    title = "Emotes"
})

local ESPSection = VisualsPage:addSection({
    title = "ESP"
})

local client = game.Players.LocalPlayer
local char = client.Character

local noclip = false

LocalPlayerSection:addSlider({
    title = "Walk Speed",
    default = 50,
    min = 0,
    max = 350,
    callback = function(value)
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

LocalPlayerSection:addSlider({
    title = "Jump Power",
    default = 50,
    min = 0,
    max = 350,
    callback = function(value)
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

LocalPlayerSection:addToggle({
    title = "Toggle Noclip",
    callback = function(value)
        noclip = value
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if noclip == true then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end)

LocalPlayerSection:addSlider({
    title = "Gravity",
    default = 196,
    min = 0,
    max = 500,
    callback = function(value)
        workspace.Gravity = value
    end
})

LocalPlayerSection:addToggle({
    title = "Auto Pickup Gun",
    callback = function(value)
        if value == true then
            sheriff.Character.Humanoid.Died:Connect(function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sheriff.Character.HumanoidRootPart.CFrame end)
        end
    end
})

LocalPlayerSection:addButton({
    title = "Find Murder",
    callback = function()
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife") then
                UI:Notify({
                    title = "Anarchy Hub",
                    text = "Murderer is".. v.Name.." !"
                })  
            end
        end
    end
})

LocalPlayerSection:addButton({
    title = "Find Sheriff",
    callback = function()
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Character:FindFirstChild("Revolver") or v.Backpack:FindFirstChild("Revolver") then
                UI:Notify({
                    title = "Anarchy Hub",
                    text = "Sheriff is".. v.Name.." !"
                })  
            end
        end
    end
})

TeleportsSection:addButton({
    title = "Teleport To Murderer",
    callback = function()
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

TeleportsSection:addButton({
    title = "Teleport To Sheriff",
    callback = function()
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Character:FindFirstChild("Revolver") or v.Backpack:FindFirstChild("Revolver") or v.Character:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Gun") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

EmotesSection:addButton({
    title = "Sit",
    callback = function()
        local string_1 = "sit";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

EmotesSection:addButton({
    title = "Zombie",
    callback = function()
        local string_1 = "zombie";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

EmotesSection:addButton({
    title = "Spray",
    callback = function()
        local string_1 = "SprayPaint";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

EmotesSection:addButton({
    title = "Dab",
    callback = function()
        local string_1 = "dab";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

EmotesSection:addButton({
    title = "Ninja",
    callback = function()
        local string_1 = "ninja";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

EmotesSection:addButton({
    title = "Floss",
    callback = function()
        local string_1 = "floss";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

EmotesSection:addButton({
    title = "Zen",
    callback = function()
        local string_1 = "zen";
        local Target = game:GetService("ReplicatedStorage").PlayEmote;
        Target:Fire(string_1);
    end
})

local ESPEnabled = false
local DistanceEnabled = true
local TracersEnabled = true

pcall(function()
	
	Camera = game:GetService("Workspace").CurrentCamera
	RunService = game:GetService("RunService")
	camera = workspace.CurrentCamera
	Bottom = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)

	function GetPoint(vector3)
		local vector, onScreen = camera:WorldToScreenPoint(vector3)
		return {Vector2.new(vector.X,vector.Y),onScreen,vector.Z}
	end
	
	function MakeESP(model)
		local CurrentParent = model.Parent
	
		local TopL = Drawing.new("Line")
		local BottomL = Drawing.new("Line")
		local LeftL = Drawing.new("Line")
		local RightL = Drawing.new("Line")
		local Tracer = Drawing.new("Line")
		local Display = Drawing.new("Text")

        coroutine.resume(coroutine.create(function()
			while model.Parent == CurrentParent and model.Humanoid.Health > 0 do
				
				local Distance = (Camera.CFrame.Position - model.HumanoidRootPart.Position).Magnitude
                local GetP = GetPoint(model.Head.Position)
                local headps = model.Head.CFrame
                
				if ESPEnabled and GetP[2] then
					
                    -- Calculate Cords
                    local topright = headps * CFrame.new(3,0.5, 0)
                    local topleft = headps * CFrame.new(-3,0.5, 0)
                    local bottomleft = headps * CFrame.new(-3,-7,0)
                    local bottomright = headps * CFrame.new(3,-7,0)
					topright = GetPoint(topright.p)[1]
					topleft = GetPoint(topleft.p)[1]
					bottomleft = GetPoint(bottomleft.p)[1]
					bottomright = GetPoint(bottomright.p)[1]

                    teamcolor = ReturnColor(model)
                    TopL.Color, BottomL.Color, RightL.Color, LeftL.Color = teamcolor, teamcolor, teamcolor, teamcolor
                    TopL.From, BottomL.From, RightL.From, LeftL.From = topleft, bottomleft, topright, topleft
                    TopL.To, BottomL.To, RightL.To, LeftL.To = topright, bottomright, bottomright, bottomleft
					TopL.Visible, BottomL.Visible, RightL.Visible, LeftL.Visible = true, true, true, true
				else
					TopL.Visible, BottomL.Visible, RightL.Visible, LeftL.Visible = false, false, false, false
                end
                
                if ESPEnabled and TracersEnabled and GetP[2] then
                    Tracer.Color = ReturnColor(model)
					Tracer.From = Bottom
					Tracer.To = GetPoint(headps.p)[1]
					Tracer.Thickness = 1.5
					Tracer.Visible = true
				else
					Tracer.Visible = false
                end
                
				if ESPEnabled and DistanceEnabled and GetP[2] then
					Display.Visible = true
					Display.Position = GetPoint(headps.p + Vector3.new(0,0.5,0))[1]
					Display.Center = true
					Display.Text = tostring(math.floor(Distance)).." studs"
				else
					Display.Visible = false
                end
                
				RunService.RenderStepped:Wait()
			end
	
			TopL:Remove()
			BottomL:Remove()
			RightL:Remove()
			LeftL:Remove()
			Tracer:Remove()
			Display:Remove()
        
        end))
    end
    
	for _, Player in next, game:GetService("Players"):GetChildren() do
		if Player.Name ~= game.Players.LocalPlayer.Name then
			MakeESP(Player.Character)
			Player.CharacterAdded:Connect(function()
				delay(0.5, function()
					MakeESP(Player.Character)
				end)
			end)
		end	
	end
	
	game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            delay(0.5, function()
                MakeESP(player.Character)
            end)
		end)
	end)
	
end)

ESPSection:addToggle({
    title = "Toggle ESP",
    callback = function(value)
        ESPEnabled = value
    end
})

ESPSection:addToggle({
    title = "Toggle Tracers",
    callback = function(value)
        TracersEnabled = value
    end
})

ESPSection:addToggle({
    title = "Toggle Display Distance",
    callback = function(value)
        DistanceEnabled = value
    end
})
