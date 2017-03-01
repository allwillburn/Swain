local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Swain" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Swain/master/Swain.lua', SCRIPT_PATH .. 'Swain.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Swain/master/Swain.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local SwainMenu = Menu("Swain", "Swain")

SwainMenu:SubMenu("Combo", "Combo")

SwainMenu.Combo:Boolean("Q", "Use Q in combo", true)
SwainMenu.Combo:Boolean("W", "Use W in combo", true)
SwainMenu.Combo:Boolean("E", "Use E in combo", true)
SwainMenu.Combo:Boolean("R", "Use R in combo", true)
SwainMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
SwainMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
SwainMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
SwainMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
SwainMenu.Combo:Boolean("RHydra", "Use RHydra", true)
SwainMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
SwainMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
SwainMenu.Combo:Boolean("Randuins", "Use Randuins", true)


SwainMenu:SubMenu("AutoMode", "AutoMode")
SwainMenu.AutoMode:Boolean("Level", "Auto level spells", false)
SwainMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
SwainMenu.AutoMode:Boolean("Q", "Auto Q", false)
SwainMenu.AutoMode:Boolean("W", "Auto W", false)
SwainMenu.AutoMode:Boolean("R", "Auto R", false)

SwainMenu:SubMenu("LaneClear", "LaneClear")
SwainMenu.LaneClear:Boolean("Q", "Use Q", true)
SwainMenu.LaneClear:Boolean("W", "Use W", true)
SwainMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
SwainMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

SwainMenu:SubMenu("Harass", "Harass")
SwainMenu.Harass:Boolean("Q", "Use Q", true)
SwainMenu.Harass:Boolean("W", "Use W", true)

SwainMenu:SubMenu("KillSteal", "KillSteal")
SwainMenu.KillSteal:Boolean("Q", "KS w Q", true)


SwainMenu:SubMenu("AutoIgnite", "AutoIgnite")
SwainMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

SwainMenu:SubMenu("Drawings", "Drawings")
SwainMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

SwainMenu:SubMenu("SkinChanger", "SkinChanger")
SwainMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
SwainMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if SwainMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if SwainMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if SwainMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 900) then
				CastTargetSpell(target, _W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if SwainMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if SwainMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if SwainMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if SwainMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            

            if SwainMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end

            if SwainMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if SwainMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if SwainMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if SwainMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 900) then
			CastTargetSpell(target, _W)
	    end

            
	    if SwainMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			CastTargetSpell(target, _E)
	    end
	    
	    
            if SwainMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 500) >= SwainMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and SwainMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if SwainMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 550) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if SwainMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 900) then
	        	CastTargetSpell(target, _W)
	        end

                

                if SwainMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if SwainMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if SwainMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 700) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if SwainMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 900) then
	  	      CastTargetSpell(target, _W)
          end
        end
        
        if SwainMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 500) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if SwainMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if SwainMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 550, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Swainempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if SwainMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Swain</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





