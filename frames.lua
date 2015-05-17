--cicons
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

    hooksecurefunc(UFP,function(self) if self.portrait then t=CIT[select(2,UC(self.unit))] if t and UnitIsPlayer(self.unit) then
        self.portrait:SetTexture(UICC) self.portrait:SetTexCoord(unpack(t)) else self.portrait:SetTexCoord(0,1,0,1) end end end)

    end
end
        
--status tex
PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");			
TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");
PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\bUI\\Textures\\minimalist");

--absolute status
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function()
        PlayerFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("player")))
        PlayerFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("player")))

        TargetFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("target")))
        TargetFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("target")))

        FocusFrameHealthBar.TextString:SetText(AbbreviateLargeNumbers(UnitHealth("focus")))
        FocusFrameManaBar.TextString:SetText(AbbreviateLargeNumbers(UnitMana("focus")))
end)

--status col
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

--nbar col
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
    BarTextures:SetTexture("Interface\\AddOns\\bUI\\Textures\\minimalist")
end

UIP=UnitIsPlayer RCC=RAID_CLASS_COLORS UC=UnitClass TFNB=TargetFrameNameBackground FFNB=FocusFrameNameBackground

f=CreateFrame("FRAME") f:RegisterEvent("PARTY_MEMBERS_CHANGED") f:RegisterEvent("PLAYER_TARGET_CHANGED") f:RegisterEvent("PLAYER_FOCUS_CHANGED") f:RegisterEvent("UNIT_FACTION")

function e(self,event,...) if UIP("target") then c=RCC[select(2,UC("target"))] TFNB:SetVertexColor(c.r,c.g,c.b) end if UIP("focus") then c=RCC[select(2,UC("focus"))] FFNB:SetVertexColor(c.r,c.g,c.b) end end f:SetScript("OnEvent",e)

--Frame sc
PlayerFrame:SetScale(1.3);
TargetFrame:SetScale(1.3);
FocusFrame:SetScale(1.5);

--Frame Loc
TargetFrame:ClearAllPoints()
TargetFrame:SetPoint("RIGHT", UIParent, "CENTER", 280, -200)
TargetFrame:SetUserPlaced(true)

PlayerFrame:ClearAllPoints()
PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -50, -200)
PlayerFrame:SetUserPlaced(true)

FocusFrame:ClearAllPoints()
FocusFrame:SetPoint("RIGHT", UIParent, "CENTER", 475, -100)
FocusFrame:SetUserPlaced(true)









