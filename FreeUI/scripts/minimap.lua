local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -20)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
F.CreateBG(Minimap)

Minimap:EnableMouseWheel(true)
MinimapCluster:EnableMouse(false)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
	if zoom > 0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut()
	end
end)

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", -162, 190)
	else
		Minimap_OnClick(self)
	end
end)

local mail = CreateFrame("Frame", "FreeUIMailFrame", Minimap)
mail:Hide()
mail:RegisterEvent("UPDATE_PENDING_MAIL")
mail:SetScript("OnEvent", function(self)
	if HasNewMail() then
		self:Show()
	else
		self:Hide()
	end
end)

local mt = F.CreateFS(mail, 8)
mt:SetText("|cffFFFF00Mail|r")
mt:SetPoint("BOTTOM", Minimap, 0, 6)

MiniMapMailFrame:SetAlpha(0)
MiniMapMailFrame:SetSize(22, 10)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("CENTER", mt)

ZoneTextFrame:SetFrameStrata("MEDIUM")
SubZoneTextFrame:SetFrameStrata("MEDIUM")

ZoneTextString:ClearAllPoints()
ZoneTextString:SetPoint("CENTER", Minimap)
ZoneTextString:SetWidth(138)
ZoneTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
SubZoneTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
SubZoneTextString:SetWidth(138)
PVPInfoTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
PVPInfoTextString:SetWidth(138)
PVPArenaTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
PVPArenaTextString:SetWidth(138)

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("CENTER", Minimap)
MinimapZoneTextButton:SetFrameStrata("HIGH")
MinimapZoneTextButton:EnableMouse(false)
MinimapZoneTextButton:SetAlpha(0)
MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton)
MinimapZoneText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
MinimapZoneText:SetShadowColor(0, 0, 0, 0)
MinimapZoneText:SetJustifyH("CENTER")

Minimap:HookScript("OnEnter", function()
	MinimapZoneTextButton:SetAlpha(1)
end)
Minimap:HookScript("OnLeave", function()
	MinimapZoneTextButton:SetAlpha(0)
end)

do
	local frames = {
		"MiniMapInstanceDifficulty",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MiniMapTracking",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MinimapBorder",
	}

	for i = 1, #frames do
		_G[frames[i]]:Hide()
		_G[frames[i]].Show = F.dummy
	end
end

Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)

GuildInstanceDifficulty:SetAlpha(0)

GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -1, -1)
GameTimeFrame:SetSize(16, 16)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:SetNormalTexture("")
GameTimeFrame:SetPushedTexture("")
GameTimeFrame:SetHighlightTexture("")

local _, _, _, _, dateText = GameTimeFrame:GetRegions()
dateText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
dateText:SetTextColor(1, 1, 1)
dateText:SetPoint("CENTER")

QueueStatusMinimapButtonBorder:SetAlpha(0)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap)
QueueStatusMinimapButton:SetHighlightTexture("")
QueueStatusMinimapButton.Eye.texture:SetTexture("")

QueueStatusFrame:ClearAllPoints()
QueueStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -4, -1)

local dots = {}
for i = 1, 8 do
	dots[i] = F.CreateFS(QueueStatusMinimapButton, 16)
	dots[i]:SetText(".")
end
dots[1]:SetPoint("TOP", 2, 2)
dots[2]:SetPoint("TOPRIGHT", -6, -1)
dots[3]:SetPoint("RIGHT", -3, 2)
dots[4]:SetPoint("BOTTOMRIGHT", -6, 5)
dots[5]:SetPoint("BOTTOM", 2, 2)
dots[6]:SetPoint("BOTTOMLEFT", 9, 5)
dots[7]:SetPoint("LEFT", 6, 2)
dots[8]:SetPoint("TOPLEFT", 9, -1)

local counter = 0
local last = 0
local interval = .06
local diff = .014

local function onUpdate(self, elapsed)
	last = last + elapsed
	if last >= interval then
		counter = counter + 1

		dots[counter]:SetShown(not dots[counter]:IsShown())

		if counter == 8 then
			counter = 0
			diff = diff * -1
		end

		interval = interval + diff
		last = 0
	end
end

hooksecurefunc("EyeTemplate_StartAnimating", function(eye)
	eye:SetScript("OnUpdate", onUpdate)
end)

hooksecurefunc("EyeTemplate_StopAnimating", function(eye)
	for i = 1, 8 do
		dots[i]:Show()
	end
	counter = 0
	last = 0
	interval = .06
	diff = .014
end)

QueueStatusMinimapButton:HookScript("OnEnter", function()
	for i = 1, 8 do
		dots[i]:SetTextColor(r, g, b)
	end
end)

QueueStatusMinimapButton:HookScript("OnLeave", function()
	for i = 1, 8 do
		dots[i]:SetTextColor(1, 1, 1)
	end
end)

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -49, 0)

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5, -5)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")

local rdt = F.CreateFS(rd, 8, "LEFT")
rdt:SetPoint("TOPLEFT")

rd:SetScript("OnEvent", function()
	local _, _, difficulty, _, maxPlayers = GetInstanceInfo()

	if difficulty == 0 then
		rdt:SetText("")
	elseif maxPlayers == 3 then
		rdt:SetText("|cff33FFFF3|r")
	elseif difficulty == 1 then
		rdt:SetText("|cff33FFFF5|r")
	elseif difficulty == 2 then
		rdt:SetText("|cff33FFFF5H|r")
	elseif difficulty == 3 then
		rdt:SetText("|cff33FFFF10|r")
	elseif difficulty == 4 then
		rdt:SetText("|cff33FFFF25|r")
	elseif difficulty == 5 then
		rdt:SetText("|cff33FFFF10H|r")
	elseif difficulty == 6 then
		rdt:SetText("|cff33FFFF25H|r")
	elseif difficulty == 7 then
		rdt:SetText("|cff33FFFFLFR|r")
	elseif difficulty == 8 then
		rdt:SetText("|cff33FFFF5CM|r")
	elseif difficulty == 9 then
		rdt:SetText("|cff33FFFF40|r")
	end

	if GuildInstanceDifficulty:IsShown() then
		rdt:SetTextColor(0, .9, 0)
	else
		rdt:SetTextColor(1, 1, 1)
	end
end)

HelpOpenTicketButtonTutorial:Hide()
HelpOpenTicketButtonTutorial.Show = F.dummy

local function positionTicketButtons()
	if HelpOpenTicketButton:IsShown() then
		if HelpOpenWebTicketButton:IsShown() then
			HelpOpenTicketButton:ClearAllPoints()
			HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", -17, -5)
			HelpOpenWebTicketButton:ClearAllPoints()
			HelpOpenWebTicketButton:SetPoint("TOP", Minimap, "TOP", 17, -5)
		else
			HelpOpenTicketButton:ClearAllPoints()
			HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", 0, -5)
		end
	elseif HelpOpenWebTicketButton:IsShown() then
		HelpOpenWebTicketButton:ClearAllPoints()
		HelpOpenWebTicketButton:SetPoint("TOP", Minimap, "TOP", 0, -5)
	end
end

for _, ticketButton in pairs({HelpOpenTicketButton, HelpOpenWebTicketButton}) do
	ticketButton:SetParent(Minimap)
	ticketButton:SetHeight(8)
	ticketButton:SetHitRectInsets(0, 0, 0, 0)
	ticketButton:ClearAllPoints()

	ticketButton:SetNormalTexture("")
	ticketButton:SetHighlightTexture("")
	ticketButton:SetPushedTexture("")

	local gmtext = F.CreateFS(ticketButton, 8)
	gmtext:SetPoint("CENTER", 2, 0)
	gmtext:SetText(gsub(CHAT_FLAG_GM, "[<>]", "")) -- magic!

	ticketButton:HookScript("OnShow", positionTicketButtons)
	ticketButton:HookScript("OnHide", positionTicketButtons)
end


local shadows = {
	edgeFile = "Interface\\Addons\\FreeUI\\media\\glowTex", 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
function CreateShadow(f)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -4, 4)
	shadow:SetPoint("BOTTOMRIGHT", 4, -4)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	return shadow
end
function CreateInnerBorder(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", 1, -1)
	f.iborder:SetPoint("BOTTOMRIGHT", -1, 1)
	f.iborder:SetFrameLevel(f:GetFrameLevel())
	f.iborder:SetBackdrop({
	  edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.iborder:SetBackdropBorderColor(0, 0, 0)
	return f.iborder
end
function frame1px(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -1, right = -1, top = -1, bottom = -1} 
	})
	f:SetBackdropColor(.06,.06,.06,1)
	f:SetBackdropBorderColor(.15,.15,.15,1)
CreateInnerBorder(f)	
end

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Hide()
			else
				region:SetTexture(nil)
			end
		end
	end		
end


frame1px(Minimap)
CreateShadow(Minimap)

FRAMELOCK_STATES["PETBATTLES"]["MinimapCluster"]=""