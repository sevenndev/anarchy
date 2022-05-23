local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UI = Venyx.new({
    title = "Anarchy Hub - Arsenal"
})
local CombatPage = UI:addPage({
    title = "Combat"
})
local VisualsPage = UI:addPage({
    title = "Visuals"
})
local GunModsPage = UI:addPage({
    title = "Gun Mods"
})
local AimbotSection = CombatPage:addSection({
    title = "Aimbot"
})
local ESPSection = VisualsPage:addSection({
    title = "ESP"
})
local GunModsSection = GunModsPage:addSection({
    title = "Gun Mods"
})
local aimbotsettings = {
    enabled = false,
    freeforall = false,
    radius = 2500,
    wallcheck = false
}

local players = game:GetService("Players")
local client = players.LocalPlayer
local inputservice = game:GetService("UserInputService")
local mouse = client:GetMouse()
local runservice = game:GetService("RunService")
local aim = false

function GetMouse()
    return Vector2.new(mouse.X, mouse.Y)
end

inputservice.InputBegan:Connect(function(key)
    if key.UserInputType == Enum.UserInputType.MouseButton2 then
        aim = true
    end
end)

inputservice.InputEnded:Connect(function(key)
    if key.UserInputType == Enum.UserInputType.MouseButton2 then
        aim = false
    end
end)

function FreeForAll(targetplayer)
    if aimbotsettings.freeforall == false then
        if client.Team == targetplayer.Team then return false
        else return true end
    else return true end
end

function NotObstructing(destination, ignore)
    if aimbotsettings.wallcheck then
        Origin = workspace.CurrentCamera.CFrame.p
        CheckRay = Ray.new(Origin, destination- Origin)
        Hit = workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
        return Hit == nil
    else
        return true
    end
end

function GetClosestToCuror()
    MousePos = GetMouse()
    Radius = aimbotsettings.radius
    Closest = math.huge
    Target = nil
    for _,v in pairs(game:GetService("Players"):GetPlayers()) do
        if FreeForAll(v) then
            if v.Character:FindFirstChild("Head") and v ~= game.Players.LocalPlayer then
                Point,OnScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                clientchar = client.Character
                if OnScreen and NotObstructing(v.Character.Head.Position,{clientchar,v.Character}) then
                    Distance = (Vector2.new(Point.X,Point.Y) - MousePos).magnitude
                    if Distance < math.min(Radius,Closest) then
                        Closest = Distance
                        Target = v
                    end
                end
            end
        end
    end
    return Target
end 

runservice.RenderStepped:Connect(function()
    if aimbotsettings.enabled == false or aim == false then return end
    ClosestPlayer = GetClosestToCuror()
    if ClosestPlayer then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p,ClosestPlayer.Character.Head.CFrame.p)
    end
end)
local wallbangenabled = false
local gm = getrawmetatable(game)            
setreadonly(gm,false)                       
local OldIndex = gm.__index                 
gm.__index = newcclosure(function(self,i)   
    if i == "Clips" and wallbangenabled then                   
        return workspace.Map
    end
    return OldIndex(self,i)
end)

AimbotSection:addToggle({
    title = "WallBang",
    callback = function(value)
        wallbangenabled = value
    end
})
AimbotSection:addToggle({
    title = "Aimbot Toggle",
    callback = function(value)
        aimbotsettings.enabled = value
    end
})
AimbotSection:addToggle({
    title = "Wall Check",
    callback = function(value)
        aimbotsettings.wallcheck = value
    end
})
AimbotSection:addToggle({
    title = "Free For All",
    callback = function(value)
        aimbotsettings.freeforall = value
    end
})
AimbotSection:addSlider({
    title = "Aimbot Range",
    default = 2500,
    min = 0,
    max = 10000,
    callback = function(value)
        aimbotsettings.radius = tonumber(value)
    end
})
local ESPEnabled = false
local DistanceEnabled = false
local TracersEnabled = false

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
			while model.Parent == CurrentParent do
				
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

                    local teamcolor = game:GetService("Players")[model.Name].TeamColor.Color or Color3.fromRGB(0,0,0)
                    TopL.Color, BottomL.Color, RightL.Color, LeftL.Color = teamcolor, teamcolor, teamcolor, teamcolor
                    TopL.From, BottomL.From, RightL.From, LeftL.From = topleft, bottomleft, topright, topleft
                    TopL.To, BottomL.To, RightL.To, LeftL.To = topright, bottomright, bottomright, bottomleft
					TopL.Visible, BottomL.Visible, RightL.Visible, LeftL.Visible = true, true, true, true
				else
					TopL.Visible, BottomL.Visible, RightL.Visible, LeftL.Visible = false, false, false, false
                end
                
				if ESPEnabled and TracersEnabled and GetP[2] then
					Tracer.Color = game:GetService("Players")[model.Name].TeamColor.Color or Color3.fromRGB(0,0,0)
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
    title = "Show Distance Display",
    callback = function(value)
        DistanceEnabled = value
    end
})

local InfAmmoVar = false
local NoRecoilVar = false
local AutomaticModeVar = false
local NoSpreadVar = false

local a
local b
for i,v in next, getgc() do
  if (type(v) == 'function') and (debug.getinfo(v).name == 'firebullet') then
     a = getfenv(v);
     b = v
  end
end

game:GetService("RunService").Heartbeat:Connect(function()
	if InfAmmoVar then
		debug.setupvalue(b,5,420)
	end
	if InfAmmoVar or NoSpreadVar or AutomaticModeVar or NoRecoilVar then
		a.DISABLED = false
		a.DISABLED2 = false
	end
	if NoSpreadVar then
		a.currentspread = 0
	end
	if NoRecoilVar then
		a.recoil = 0
	end
	if AutomaticModeVar then
		a.mode = "automatic"
	end
end)

GunModsSection:addToggle({
    title = "No Recoil",
    callback = function(value)
       NoRecoilVar = value
    end
})
GunModsSection:addToggle({
    title = "Infinite Ammo",
    callback = function(value)
       InfAmmoVar = value
    end
})
GunModsSection:addToggle({
    title = "Always Automatic",
    callback = function(value)
       AutomaticModeVar = value
    end
})
GunModsSection:addToggle({
    title = "No Spread",
    callback = function(value)
       NoSpreadVar = value
    end
})
