--Hide objs

--p_icon
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)
FocusFrameTextureFramePVPIcon:SetAlpha(0)

--gnum
PlayerFrameGroupIndicator.Show = function() return end

--Glow
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

--cframe 
FriendsMicroButton:Hide();
ChatFrame1ButtonFrame:Hide();
ChatFrameMenuButton:Hide();

UIErrorsFrame:Hide();

--endcaps
MainMenuBarLeftEndCap:Hide();
MainMenuBarRightEndCap:Hide()