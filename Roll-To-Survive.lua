if game.PlaceId == 132508978828159 then end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Made By Zeetuan",
   Icon = 0,
   LoadingTitle = "Rayfield",
   LoadingSubtitle = "by Zeetuan",
   ShowText = "Rayfield", 
   Theme = "Default", 

   ToggleUIKeybind = "K", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "BIG HUB"
   },

   Discord = {
      Enabled = false, 
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

-- ==================== MAIN CATEGORY: AUTO TAB ====================
local MainTab = Window:CreateTab("Auto", nil) 
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "You Executed the scripted",
   Content = "Good luck",
   Duration = 4.5,
   Image = nil,
})

-- TOGGLE 1: AUTO POTION
local Toggle1 = MainTab:CreateToggle({
   Name = "Auto Collect Potion",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
      _G.AutoPotionActive = Value
      if Value then
          task.spawn(function()
              while _G.AutoPotionActive do
                  local player = game.Players.LocalPlayer
                  local character = player.Character
                  local root = character and character:FindFirstChild("HumanoidRootPart")

                  if root then
                      local orb = workspace:FindFirstChild("DropOrb")
                      if orb and orb:IsA("BasePart") then
                          local originalPos = root.CFrame
                          root.CFrame = orb.CFrame
                          task.wait(0.3)
                          root.CFrame = originalPos
                      end
                  end
                  task.wait(0.5)
              end
          end)
      end
   end,
})

-- TOGGLE 2: UPGRADED ANIMATION-SKIP AUTO ROLL
local Toggle2 = MainTab:CreateToggle({
   Name = "Auto Roll (Instant Skip)",
   CurrentValue = false,
   Flag = "Toggle2", 
   Callback = function(Value)
       _G.AutoRollActive = Value 

       if Value then
           task.spawn(function()
               local player = game.Players.LocalPlayer
               local Event = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RollWeapon")
               
               local playerGui = player:WaitForChild("PlayerGui", 5)
               local handlers = playerGui and playerGui:WaitForChild("Handlers", 5)
               local rollAnimScript = handlers and handlers:FindFirstChild("RollAnimation")

               while _G.AutoRollActive do
                   if rollAnimScript and rollAnimScript:IsA("LocalScript") then
                       rollAnimScript.Disabled = true
                   end

                   task.spawn(function() Event:FireServer(3) end)
                   task.spawn(function() Event:FireServer(3) end)
                   task.spawn(function() Event:FireServer(3) end)
                   
                   task.wait(0.03) 
               end
               
               if rollAnimScript and rollAnimScript:IsA("LocalScript") then
                   rollAnimScript.Disabled = false
               end
           end)
       end
   end,
})

-- ==================== SECONDARY CATEGORY: SELL TAB ====================
local SubTab = Window:CreateTab("Sell", nil) 
local SubSection = SubTab:CreateSection("Sell")

local SelectedRarities = {}

local RarityDropdown = SubTab:CreateDropdown({
   Name = "Auto Sell Rarities",
   Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "AutoSellRaritiesFlag", 
   Callback = function(Options)
       SelectedRarities = {}
       for _, rarity in pairs(Options) do
           SelectedRarities[rarity] = true
       end
   end,
})

local WeaponRarities = {
    -- Common
    ["Pistol"] = "Common", ["Shotgun"] = "Common",
    -- Uncommon
    ["Rifle"] = "Uncommon", ["Revolver"] = "Uncommon", ["Silencer"] = "Uncommon", ["AR"] = "Uncommon",
    -- Rare
    ["Uzi"] = "Rare", ["Flintlock"] = "Rare", ["Flare Gun"] = "Rare",
    -- Epic
    ["Tommy Gun"] = "Epic", ["AK-47"] = "Epic", ["Sniper"] = "Epic",
    -- Legendary
    ["Arcflare"] = "Legendary", ["Paintball"] = "Legendary", ["Scorcher"] = "Legendary", ["Auto Sniper"] = "Legendary",
    ["Pressure"] = "Legendary", ["Compact"] = "Legendary", ["Toxicity"] = "Legendary", ["Eclipse"] = "Legendary",
    ["Glacius"] = "Legendary", ["Sugsrshot"] = "Legendary",
    -- Mythic
    ["Inferno"] = "Mythic", ["Ashfall"] = "Mythic", ["Shock"] = "Mythic", ["Null Shot"] = "Mythic",
    ["Heavenly"] = "Mythic", ["Abyssal"] = "Mythic", ["Burst"] = "Mythic", ["Toy-a-matic"] = "Mythic",
    -- Secret
    ["Volcanic"] = "Secret", ["Wild Fire"] = "Secret"
}

local ToggleSell = SubTab:CreateToggle({
   Name = "Enable Auto Sell (UI Auto-Clicker)",
   CurrentValue = false,
   Flag = "ToggleAutoSell", 
   Callback = function(Value)
       _G.AutoSellActive = Value 

       if Value then
           task.spawn(function()
               local player = game.Players.LocalPlayer
               
               local playerGui = player:WaitForChild("PlayerGui", 5)
               local hud = playerGui and playerGui:WaitForChild("HUD", 5)
               local frames = hud and hud:WaitForChild("Frames", 5)
               local sellFrame = frames and frames:WaitForChild("Sell", 5)
               local scrollingFrame = sellFrame and sellFrame:WaitForChild("ScrollingFrames", 5)

               while _G.AutoSellActive do
                   if scrollingFrame then
                       for _, gunFrame in pairs(scrollingFrame:GetChildren()) do
                           local rarity = WeaponRarities[gunFrame.Name]
                           
                           if rarity and SelectedRarities[rarity] then
                               local sellAllButton = gunFrame:FindFirstChild("SellAll")
                               
                               if sellAllButton and (sellAllButton:IsA("TextButton") or sellAllButton:IsA("ImageButton")) then
                                   task.spawn(function()
                                       local events = {"MouseButton1Click", "MouseButton1Down", "Activated"}
                                       for _, eventName in pairs(events) do
                                           if sellAllButton[eventName] then
                                               for _, connection in pairs(getconnections(sellAllButton[eventName])) do
                                                   connection:Fire()
                                               end
                                           end
                                       end
                                   end)
                               end
                           end
                       end
                   end
                   task.wait(0.2) 
               end
           end)
       end
   end,
}) 
