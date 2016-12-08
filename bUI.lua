--Move Tooltip
GameTooltip:SetScript("OnTooltipSetUnit", function(self)
    self:ClearAllPoints()
    self:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", 0, 0)
        
end)

--ClassIcons
local events = CreateFrame("Frame")
function events:PLAYER_ENTERING_WORLD()
        local _, instanceType = IsInInstance()
        if instanceType == "arena" then
        
            hooksecurefunc("UnitFramePortrait_Update",function(self)
                    if self.portrait then
                            if UnitIsPlayer(self.unit) then                         
                                    local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
                                    if t then
                                            self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                                            self.portrait:SetTexCoord(unpack(t))
                                    end
                            else
                                    self.portrait:SetTexCoord(0,1,0,1)
                            end
                    end
            end)

            UFP="UnitFramePortrait_Update" UICC="Interface\\TargetingFrame\\UI-Classes-Circles" CIT=CLASS_ICON_TCOORDS UC=UnitClass

            hooksecurefunc(UFP,function(self) if self.portrait then t=CIT[select(2,UC(self.unit))] if t and UnitIsPlayer(self.unit) then self.portrait:SetTexture(UICC) self.portrait:SetTexCoord(unpack(t)) else self.portrait:SetTexCoord(0,1,0,1) end end end)

        end
end
        
--[[Status Texture
        PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");			
		TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
		PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist");
]]
--HealthBars
local UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS =

UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS

local _, class, c

local function colour(statusbar, unit)

if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then

_, class = UnitClass(unit)

c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

statusbar:SetStatusBarColor(c.r, c.g, c.b)

end

end

hooksecurefunc("UnitFrameHealthBar_Update", colour)

hooksecurefunc("HealthBar_OnValueChanged", function(self)

colour(self, self.unit)

end)

local sb = _G.GameTooltipStatusBar

local addon = CreateFrame("Frame", "StatusColour")

addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

addon:SetScript("OnEvent", function()

colour(sb, "mouseover")

end)

--Behind Names
local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_FACTION")

local function eventHandler(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            if UnitIsPlayer("player") then
                    c = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
                    PlayerFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
            end
        end
        if UnitIsPlayer("target") then
                c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
                TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
        end
        if UnitIsPlayer("focus") then
                c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
                FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
        end
end

frame:SetScript("OnEvent", eventHandler)

for _, BarTextures in pairs({TargetFrameNameBackground, FocusFrameNameBackground, PlayerFrameNameBackground}) do
        BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
        --BarTextures:SetTexture("Interface\\AddOns\\ClassHP\\Textures\\minimalist")
end

UIP=UnitIsPlayer RCC=RAID_CLASS_COLORS UC=UnitClass TFNB=TargetFrameNameBackground FFNB=FocusFrameNameBackground

f=CreateFrame("FRAME") f:RegisterEvent("PARTY_MEMBERS_CHANGED") f:RegisterEvent("PLAYER_TARGET_CHANGED") f:RegisterEvent("PLAYER_FOCUS_CHANGED") f:RegisterEvent("UNIT_FACTION")

function e(self,event,...) if UIP("target") then c=RCC[select(2,UC("target"))] TFNB:SetVertexColor(c.r,c.g,c.b) end if UIP("focus") then c=RCC[select(2,UC("focus"))] FFNB:SetVertexColor(c.r,c.g,c.b) end end f:SetScript("OnEvent",e)

--CastBar Timer
--CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
--CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE");
--CastingBarFrame.timer:SetPoint("TOP", CastingBarFrame, "TOP", 0, 23);
--CastingBarFrame.update = .1;

hooksecurefunc("CastingBarFrame_OnUpdate", function(self, elapsed)
        if not self.timer then return end
        if self.update and self.update < elapsed then
                if self.casting then
                        self.timer:SetText(format("%2.1f/%1.1f", max(self.maxValue - self.value, 0), self.maxValue))
                elseif self.channeling then
                        self.timer:SetText(format("%.1f", max(self.value, 0)))
                else
                        self.timer:SetText("")
                end
                self.update = .1
        else
                self.update = self.update - elapsed
        end
end)

--Textures
local frame=CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, addon)
        if (addon == "Blizzard_TimeManager") then
                for i, v in pairs({PlayerFrameTexture, TargetFrameTextureFrameTexture, PetFrameTexture, PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture, PartyMemberFrame4Texture,
                        PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture, PartyMemberFrame4PetFrameTexture, FocusFrameTextureFrameTexture,
                        TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture, BonusActionBarFrameTexture0, BonusActionBarFrameTexture1, BonusActionBarFrameTexture2, BonusActionBarFrameTexture3,
                        BonusActionBarFrameTexture4, MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2,
                        MainMenuMaxLevelBar3, MinimapBorder, CastingBarFrameBorder, FocusFrameSpellBarBorder, TargetFrameSpellBarBorder, MiniMapTrackingButtonBorder, MiniMapLFGFrameBorder, MiniMapBattlefieldBorder,
                        MiniMapMailBorder, MinimapBorderTop,
                        select(1, TimeManagerClockButton:GetRegions())
                }) do
                        v:SetVertexColor(.4, .4, .4)
                end

                for i,v in pairs({ select(2, TimeManagerClockButton:GetRegions()) }) do
                        v:SetVertexColor(1, 1, 1)
                end

                self:UnregisterEvent("ADDON_LOADED")
                frame:SetScript("OnEvent", nil)
        end
end)

for i, v in pairs({ MainMenuBarLeftEndCap, MainMenuBarRightEndCap }) do
        v:SetVertexColor(.35, .35, .35)
end

--Frame Scale
PlayerFrame:SetScale(1.3);
TargetFrame:SetScale(1.3);
FocusFrame:SetScale(1.5);
--CastingBarFrame:SetPoint("BOTTOMLEFT",873,85);
CastingBarFrame:SetPoint("BOTTOMLEFT",873,130);
CastingBarFrame:SetScale(1.1);
MainMenuBarLeftEndCap:Hide();
MainMenuBarRightEndCap:Hide()

--[[ Frame Loc
TargetFrame:ClearAllPoints()
TargetFrame:SetPoint("RIGHT", UIParent, "CENTER", 240, -200)
TargetFrame:SetUserPlaced(true)

PlayerFrame:ClearAllPoints()
PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -10, -200)
PlayerFrame:SetUserPlaced(true)

FocusFrame:ClearAllPoints()
FocusFrame:SetPoint("RIGHT", UIParent, "CENTER", 475, -100)
FocusFrame:SetUserPlaced(true)
--]]

--Hide pvp icon
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)
FocusFrameTextureFramePVPIcon:SetAlpha(0)

--Hide Group Number
PlayerFrameGroupIndicator.Show = function() return end

--minimap edit
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
Minimap:EnableMouseWheel(true)
Minimap:SetScript('onmousewheel', function(self, delta)
        if delta > 0 then
                Minimap_ZoomIn()
        else
                Minimap_ZoomOut()
        end
end)
--MiniMapTracking:ClearAllPoints()
--MiniMapTracking:SetPoint("TOPRIGHT", -26, 7)

--scrap
local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")

g:SetScript("OnEvent", function()  
        local bag, slot
        for bag = 0, 4 do
                for slot = 0, GetContainerNumSlots(bag) do
                        local link = GetContainerItemLink(bag, slot)
                        if link and (select(3, GetItemInfo(link)) == 0) then
                                UseContainerItem(bag, slot)
                        end
                end
        end

        if(CanMerchantRepair()) then
                local cost = GetRepairAllCost()
                if cost > 0 then
                        local money = GetMoney()
                        if IsInGuild() then
                                local guildMoney = GetGuildBankWithdrawMoney()
                                if guildMoney > GetGuildBankMoney() then
                                        guildMoney = GetGuildBankMoney()
                                end
                                if guildMoney > cost and CanGuildBankRepair() then
                                        RepairAllItems(1)
                                        print(format("|cfff07100Repair cost covered by G-Bank: %.1fg|r", cost * 0.0001))
                                        return
                                end
                        end
                        if money > cost then
                                RepairAllItems()
                                print(format("|cffead000Repair cost: %.1fg|r", cost * 0.0001))
                        else
                                print("Not enough gold to cover the repair cost.")
                        end
                end
        end
end)

--[[show arena frames
LoadAddOn("Blizzard_ArenaUI");
ArenaEnemyFrames:Show();
ArenaEnemyFrame1:Show();
ArenaEnemyFrame2:Show();
ArenaEnemyFrame3:Show();
ArenaEnemyFrame1CastingBar:Show();
ArenaEnemyFrame2CastingBar:Show();
ArenaEnemyFrame3CastingBar:Show();


ArenaEnemyFrames:SetScale(1.7)

hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function()
        ArenaEnemyFrame1HealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("arena1")))
        ArenaEnemyFrame1ManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("arena1")))

        ArenaEnemyFrame2HealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("arena2")))
        ArenaEnemyFrame2ManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("arena2")))

        ArenaEnemyFrame3HealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("arena3")))
        ArenaEnemyFrame3ManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("arena3")))
end)

local bar,color
for i=1,5 do
 bar = _G["ArenaEnemyFrame"..i.."HealthBar"]
 color = RAID_CLASS_COLORS[select(2,UnitClass("arena"..i))]
 if color then
 bar:SetStatusBarColor(color.r,color.g,color.b)
 end
end


--Trinkets

LoadAddOn("Blizzard_ArenaUI") -- You only need to run this once. You can safely delete any copies of this line.

trinkets = {}
local arenaFrame, trinket
for i = 1, 5 do
        arenaFrame = "ArenaEnemyFrame"..i
        trinket = CreateFrame("Cooldown", arenaFrame.."Trinket", ArenaEnemyFrames)
        trinket:SetPoint("TOPRIGHT", arenaFrame, 30, -6)
        trinket:SetSize(24, 24)
        trinket.icon = trinket:CreateTexture(nil, "BACKGROUND")
        trinket.icon:SetAllPoints()
        trinket.icon:SetTexture("Interface\\Icons\\inv_jewelry_trinketpvp_01")
        trinket:Hide()
        trinkets["arena"..i] = trinket
end

local events = CreateFrame("Frame")
function events:UNIT_SPELLCAST_SUCCEEDED(unitID, spell, rank, lineID, spellID)
        if not trinkets[unitID] then
                return
        end
        if spellID == 59752 or spellID == 42292 then
                CooldownFrame_SetTimer(trinkets[unitID], GetTime(), 120, 1)
                SendChatMessage("Trinket used by: "..GetUnitName(unitID, true), "PARTY")
        end
end

function events:PLAYER_ENTERING_WORLD()
        local _, instanceType = IsInInstance()
        if instanceType == "arena" then
                self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        elseif self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") then
                self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
                for _, trinket in pairs(trinkets) do
                        trinket:SetCooldown(0, 0)
                        trinket:Hide()
                end
        end
end
events:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
events:RegisterEvent("PLAYER_ENTERING_WORLD")
]]


--Remove Glow
local noop = function() return end
for _, objname in ipairs({
	"PlayerAttackGlow",
	"PetAttackModeTexture",
	"PlayerRestGlow",
	"PlayerStatusGlow",
	"PlayerStatusTexture",
	"PlayerAttackBackground",
	"PlayerFrameGroupIndicator",	
	"PlayerFrameFlash",
	"TargetFrameFlash",
	"FocusFrameFlash",
	"PetFrameFlash",
	"PlayerFrameRoleIcon",
	
}) do
	local obj = _G[objname]
	if obj then
		obj:Hide()
		obj.Show = noop
	end
end

--absolute
--[[
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function()
        PlayerFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("player")))
        PlayerFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("player")))

        TargetFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("target")))
        TargetFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("target")))

        FocusFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("focus")))
        FocusFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("focus")))
end)
]]
--chat frame buttons
--FriendsMicroButton:Hide();
ChatFrame1ButtonFrame:Hide();
ChatFrameMenuButton:Hide();

UIErrorsFrame:Hide();

--[[
TargetFrameSpellBar:ClearAllPoints()
TargetFrameSpellBar:SetPoint("BOTTOM", TargetFrame, "TOP", -75, 0)
TargetFrameSpellBar.SetPoint = function() end
TargetFrameSpellBar:SetScale(1.3)
]]

SetCVar('showArenaEnemyFrames', '0', 'SHOW_ARENA_ENEMY_FRAMES_TEXT')





