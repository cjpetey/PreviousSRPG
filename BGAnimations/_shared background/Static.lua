-- --------------------------------------------------------
-- static background image

local file = ...

local style = ThemePrefs.Get("VisualStyle")

local function Brighten(color, intensity)
	color[1] = math.min(1, color[1] * intensity)
	color[2] = math.min(1, color[2] * intensity)
	color[3] = math.min(1, color[3] * intensity)
	return color
end

if style == "SRPG5" then
	local sprite = Def.Sprite {
		Texture=file,
		InitCommand=function(self)
			self:xy(_screen.cx, _screen.cy):zoomto(_screen.w, _screen.h)
			self:diffusealpha(0)
	
			local style = ThemePrefs.Get("VisualStyle")
			self:visible(style == "SRPG5")
			-- Used to prevent unnecessary self:Loads()
			self.IsYellow = true
		end,
		OnCommand=function(self) self:accelerate(0.8):diffusealpha(1) end,
		ScreenChangedMessageCommand=function(self)
			local screen = SCREENMAN:GetTopScreen()
			local style = ThemePrefs.Get("VisualStyle")
			if style == "SRPG5" then
				if screen and not yellowSrpg[screen:GetName()] and self.IsYellow then
					self:Load(THEME:GetPathG("", "_VisualStyles/" .. style .. "/Overlay-BG.png"))
					self.IsYellow = false
				end
	
				if screen and yellowSrpg[screen:GetName()] and not self.IsYellow then
					self:Load(THEME:GetPathG("", "_VisualStyles/" .. style .. "/SharedBackground.png"))
					self.IsYellow = true
				end
			end
		end,
		VisualStyleSelectedMessageCommand=function(self)
			local style = ThemePrefs.Get("VisualStyle")
	
			local new_file = THEME:GetPathG("", "_VisualStyles/" .. style .. "/SharedBackground.png")
			self:Load(new_file)
			self:zoomto(_screen.w, _screen.h)
	
			if style == "SRPG5" then
				self:visible(true)
			else
				self:visible(false)
			end
		end
	}
	
	return sprite
elseif style == "SRPG6" then
	local StaticBackgroundVideos = {
		["Unaffiliated"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"),
		["Democratic People's Republic of Timing"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Ranni.mp4"),
		["Footspeed Empire"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Malenia.mp4"),
		["Stamina Nation"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Melina.mp4"),
	}
	
	local shared_alpha = 0.6
	local static_alpha = 1
	
	local af = Def.ActorFrame {
		InitCommand=function(self)
			self:diffusealpha(0)
			local style = ThemePrefs.Get("VisualStyle")
			self:visible(style == "SRPG6")
			self.IsShared = true
		end,
		OnCommand=function(self)
			self:accelerate(0.8):diffusealpha(1)
		end,
		ScreenChangedMessageCommand=function(self)
			local screen = SCREENMAN:GetTopScreen()
			local style = ThemePrefs.Get("VisualStyle")
			if screen and style == "SRPG6" then
				local static = self:GetChild("Static")
				local video = self:GetChild("Video")
				if SharedBackground[screen:GetName()] and not self.IsShared then
					static:visible(true)
					video:Load(THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"))
					video:rotationx(180):blend("BlendMode_Add"):diffusealpha(shared_alpha):diffuse(color("#ffffff"))
					self.IsShared = true
				end
				if not SharedBackground[screen:GetName()] and self.IsShared then
					local faction = SL.SRPG8.GetFactionName(SL.Global.ActiveColorIndex)
					-- No need to change anything for Unaffiliated.
					-- We want to keep using the SharedBackground.
					if faction ~= "Unaffiliated" then
						static:visible(false)
						video:Load(StaticBackgroundVideos[faction])
						video:rotationx(0):blend("BlendMode_Normal"):diffusealpha(static_alpha):diffuse(GetCurrentColor(true))
						self.IsShared = false
					end
				end
			end
		end,
		VisualStyleSelectedMessageCommand=function(self)
			local style = ThemePrefs.Get("VisualStyle")
			if style == "SRPG6" then
				self:visible(true)
			else
				self:visible(false)
			end
		end,
		Def.Sprite {
			Name="Static",
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG6/SharedBackground.png"),
			InitCommand=function(self)
				self:xy(_screen.cx, _screen.cy):zoomto(_screen.w, _screen.h):diffusealpha(shared_alpha)
			end,
		},
		Def.Sprite {
			Name="Video",
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"),
			InitCommand= function(self)
				self:xy(_screen.cx, _screen.cy):zoomto(_screen.w, _screen.h):rotationx(180):blend("BlendMode_Add"):diffusealpha(shared_alpha)
			end,
		},
	}
	
	return af

else	
local af = Def.ActorFrame {
	InitCommand=function(self)
		self:diffusealpha(0)
		self:visible(style == "SRPG9" or style == "SRPG8" or style == "SRPG7")
	end,
	OnCommand=function(self)
		self:accelerate(0.8):diffusealpha(1)
	end,
	VisualStyleSelectedMessageCommand=function(self)
		local style = ThemePrefs.Get("VisualStyle")
		if style == "SRPG9" or style == "SRPG8" or style == "SRPG7" then
			self:visible(true)
		else
			self:visible(false)
		end
	end,
	Def.Sprite {
		Name="Background",
		InitCommand= function(self)
			if not string.match(style, "SRPG") then self:Load(nil) return end

			local video_allowed = ThemePrefs.Get("AllowThemeVideos")
			if video_allowed then
				self:Load(THEME:GetPathG("", "_VisualStyles/"..style.."/BackgroundVideo.mp4"))
			else
				self:Load(THEME:GetPathG("", "_VisualStyles/"..style.."/SharedBackground.png"))
			end
			self:xy(_screen.cx, _screen.cy)
			    :zoomto(_screen.h * 16 / 9, _screen.h)
				:diffuse(Brighten(GetCurrentColor(true), 3))
			self:visible(string.match(style, "SRPG"))
		end,
		ColorSelectedMessageCommand=function(self)
			self:diffuse(Brighten(GetCurrentColor(true), 3))
		end,
		VisualStyleSelectedMessageCommand=function(self)
			if not string.match(style, "SRPG") then self:Load(nil) return end

			local video_allowed = ThemePrefs.Get("AllowThemeVideos")
			if video_allowed then
				self:Load(THEME:GetPathG("", "_VisualStyles/"..style.."/BackgroundVideo.mp4"))
			else
				self:Load(THEME:GetPathG("", "_VisualStyles/"..style.."/SharedBackground.png"))
			end
			self:xy(_screen.cx, _screen.cy)
			    :zoomto(_screen.h * 16 / 9, _screen.h)
				:diffuse(Brighten(GetCurrentColor(true), 3))
		end,
		AllowThemeVideoChangedMessageCommand=function(self)
			if not string.match(style, "SRPG") then self:Load(nil) return end

			local video_allowed = ThemePrefs.Get("AllowThemeVideos")
			if video_allowed then
				self:Load(THEME:GetPathG("", "_VisualStyles/"..style.."/BackgroundVideo.mp4"))
			else
				self:Load(THEME:GetPathG("", "_VisualStyles/"..style.."/SharedBackground.png"))
			end
			self:xy(_screen.cx, _screen.cy)
			    :zoomto(_screen.h * 16 / 9, _screen.h)
				:diffuse(Brighten(GetCurrentColor(true), 3))
		end,
	},
	Def.Quad{
		InitCommand=function(self)
			self:FullScreen()
			 :diffuse(Color.Black)
			 :diffusealpha(0.5)
		end,
	}
}

return af
end
