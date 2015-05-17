--cbar
CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE");
CastingBarFrame.timer:SetPoint("TOP", CastingBarFrame, "TOP", 0, 23);
CastingBarFrame.update = .1;

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

--cbar scale
CastingBarFrame:SetPoint("BOTTOMLEFT",873,133);
CastingBarFrame:SetScale(1.1);

--tcbar
TargetFrameSpellBar:ClearAllPoints()
TargetFrameSpellBar:SetPoint("BOTTOM", TargetFrame, "TOP", -75, 0)
TargetFrameSpellBar.SetPoint = function() end
TargetFrameSpellBar:SetScale(1.3)
