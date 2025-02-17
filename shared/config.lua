
--██╗░░██╗  ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
--╚██╗██╔╝  ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
--░╚███╔╝░  ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
--░██╔██╗░  ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
--██╔╝╚██╗  ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
--╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░
-- Support: https://discord.gg/N74Yuq9ARQ

Config = {}

Config.RequiredItem = "basic_rod" -- Here you can put your own item for fishing rod or use this one

Config.RequiredBait = "bait"     -- Bait item

Config.FishingRewards = { "fish", "shark" } -- you can put more if u need to

Config.BreakRodAfterFails = true -- true for to break the road after fails
Config.FailAttemptsToBreak = 1  -- how many times player need to fail for breaking the rod

-- Skill check difficulties
Config.Skillcheck1 = 'easy' -- easy/medium/hard
Config.Skillcheck2 = 'easy'
Config.Skillcheck3 = 'easy'

-- Skill check keys
Config.SkillKey1 = 'w'
Config.SkillKey2 = 'a'
Config.SkillKey3 = 's'
Config.SkillKey4 = 'd'

Config.speedMultiplier = 2 -- Speed of the skill check

Config.areaSize = 60 -- This is the size of the success area in degrees on the skill check


-- Notifications 

Config.Title = "Fishing"
Config.AlreadyFishing = "You are already fishing"
Config.StandInFrontOfWater = "You need to be standing in front of water to fish!"
Config.FishCaught = "You caught a fish!"
Config.Failed = "You failed to catch anything!"
Config.FishingRodBroke = "Your fishing rod broke!"
