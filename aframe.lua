--show aframes
LoadAddOn("Blizzard_ArenaUI");
ArenaEnemyFrames:Show();
ArenaEnemyFrame1:Show();
ArenaEnemyFrame2:Show();
ArenaEnemyFrame3:Show();
ArenaEnemyFrame1CastingBar:Show();
ArenaEnemyFrame2CastingBar:Show();
ArenaEnemyFrame3CastingBar:Show();

--aframe scale
ArenaEnemyFrames:SetScale(1.7)

--status
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

--trinket disp
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
        SendChatMessage("Trinket: "..GetUnitName(unitID, true), "PARTY")
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
