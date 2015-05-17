--Move Tooltip
GameTooltip:SetScript("OnTooltipSetUnit", function(self)
    self:ClearAllPoints()
end)
self:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", 0, 0)