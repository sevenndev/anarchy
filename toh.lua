local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UI = Venyx.new({
    title = "Anarchy Hub - Tower Of Hell"
})

local LocalPlayerPage = UI:addPage({
    title = "Local Player"
})
local MainPage = UI:addPage({
    title = "Main"
})

local MainSection = MainPage:addSection({
    title = "Main"
})

local LocalPlayerSection = LocalPlayerPage:addSection({
    titel = "Local Player"
})

local infjumpenabled = false
local godmodeenabled = false

game:GetService("UserInputService").JumpRequest:Connect(function()
	if infjumpenabled then
		game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState("Jumping")
	end
end)

local gm = getrawmetatable(game)
setreadonly(gm, false)
local OldNameCall = gm.__namecall
local OldIndex = gm.__index
local oldspeed, oldjump = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed, game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower
gm.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "Kick" and self == game.Players.LocalPlayer then print("Fuck no nigga")
    elseif args[1] == "kills" and getnamecallmethod() == "FindFirstChild" and godmodeenabled then return false
    else return OldNameCall(self, ...) end
end)
gm.__index = newcclosure(function(self, key)
    if key == "WalkSpeed" and self == game.Players.LocalPlayer.Character.Humanoid then
        return oldspeed;
    elseif key == "JumpPower" and self == game.Players.LocalPlayer.Character.Humanoid then
        return oldjump;
    else
        return OldIndex(self, key)
    end
end)
setreadonly(gm, true)
game.Players.LocalPlayer.PlayerScripts.LocalScript:Destroy()

MainSection:addToggle({
    title = "Infinite Jump",
    callback = function(value)
        infjumpenabled = value
    end
})

MainSection:addToggle({
    title = "God Mode",
    callback = function(value)
        godmodeenabled = value
    end
})

MainSection:addButton({
    title = "Give All Tools",
    callback = function()
        for i,v in pairs(game:GetService("ReplicatedStorage").Gear:GetChildren()) do
            local tool = v:Clone()
            tool.Parent = game.Players.LocalPlayer.Backpack
        end	
    end
})

MainSection:addButton({
    title = "Instant Win",
    callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.tower.finishes:FindFirstChild("Finish").CFrame
    end
})

LocalPlayerSection:addSlider({
    title = "Walk Speed",
    default = 16,
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
        game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
    end
})
