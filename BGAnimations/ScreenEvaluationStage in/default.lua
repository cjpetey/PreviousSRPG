-- assume that all human players failed
local failed = true

local style = ThemePrefs.Get("VisualStyle")

-- loop through all available human players
for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	-- if any of them passed, we want to display the "cleared" graphic
	if not STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetFailed() then
		failed = false
	end
end
	
if style == "SRPG6" then
		local af = Def.ActorFrame {
		InitCommand=function(self)
			self:xy(_screen.cx, _screen.cy)
		end,
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(_screen.w,  100):diffuse(Color.Black):diffusealpha(0):fadetop(0.2):fadebottom(0.2)
			end,
			OnCommand=function(self)
				self:linear(0.25):diffusealpha(0.7):sleep(2):linear(0.25):diffusealpha(0)
			end,
		},
	}

	if failed then
		af[#af+1] = Def.Sprite {
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG6/YouDied.png"),
			InitCommand=function(self) self:zoom(0.36):diffusealpha(0) end,
			OnCommand=function(self)
				self:linear(0.25):diffusealpha(1):linear(2):zoom(0.38):linear(0.25):diffusealpha(0):zoom(0.39)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG6-YouDied.ogg"))
			end
		}
	else
		local image = THEME:GetPathG("", "_VisualStyles/SRPG6/EnemyFelled.png")

		local bosses = {
			["e25513cb3c801604"]="LegendFelled.png",
			["be1811d125b4b9d5"]="LegendFelled.png",
			["945ec467c0b8fd94"]="LegendFelled.png",
			["e410d5bf872d5f37"]="LegendFelled.png",
			["e61476eec77277ca"]="LegendFelled.png",
			["21a111709f4416b3"]="LegendFelled.png",
			["ccb5ff37f938b057"]="LegendFelled.png",
			["65910d53c611f328"]="LegendFelled.png",
			["12031d8f99c8b88c"]="LegendFelled.png",
			["24a05523a0131b20"]="LegendFelled.png",
			["24a05523a0131b20"]="LegendFelled.png",

			["2184afe998acc7a5"]="GodSlain.png",
			["bd80236dc1de432f"]="GodSlain.png",
			["f56588cee23985ed"]="GodSlain.png",
			["eb20a2c5f6674882"]="GodSlain.png",
		}

		local found_boss = false
		for player in ivalues(GAMESTATE:GetHumanPlayers()) do
			local pn = ToEnumShortString(player)
			local chartHash = SL[pn].Streams.Hash
			if bosses[chartHash] ~= nil then
				image = THEME:GetPathG("", "_VisualStyles/SRPG6/"..bosses[chartHash])
				found_boss = true
				break
			end
		end

		if not found_boss and not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong():GetLastSecond() > 16 * 60 then
			image = THEME:GetPathG("", "_VisualStyles/SRPG6/GreatEnemyFelled.png")
		end

		af[#af+1] = Def.Sprite {
			Texture=image,
			InitCommand=function(self) self:zoomx(0.4):zoomy(0.38):diffusealpha(0) end,
			OnCommand=function(self)
				self:linear(0.25):diffusealpha(0.15):decelerate(2):zoomx(0.44):linear(0.25):diffusealpha(0)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG6-EnemyFelled.ogg"))
			end
		}

		af[#af+1] = Def.Sprite {
			Texture=image,
			InitCommand=function(self) self:zoom(0.38):diffusealpha(0) end,
			OnCommand=function(self)
				self:linear(0.25):diffusealpha(1):linear(2):linear(0.25):diffusealpha(0)
			end
		}
	end

	return af

elseif style == "SRPG7" then
	local img = failed and THEME:GetPathG("","_VisualStyles/SRPG7/Banner-Failed.png") or THEME:GetPathG("","_VisualStyles/SRPG7/Banner-Passed.png")

	local af = Def.ActorFrame{
		InitCommand=function(self)
			self:xy(_screen.cx, 100)
		end,
		Def.Quad{
			InitCommand=function(self)
				-- 100 + 140 = 240. SL is 480 tall, so 240 is the center.
				self:FullScreen():xy(0, 140):diffuse(color("#000000")):diffusealpha(0.9)
			end,
			OnCommand=function(self)
				self:sleep(4.5)
						:decelerate(0.5):diffusealpha(0)
			end
		},

		-- Backgrounds
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(0, 60):diffuse(color("#000000"))
			end,
			OnCommand=function(self)
				self:sleep(1)
						:decelerate(0.25):zoomto(_screen.w - 150, 60)
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},
		Def.Quad{
			InitCommand=function(self)
				local c = failed and Color.Red or Color.Yellow
				self:zoomto(0, 45):diffusecolor(c):diffusealpha(0.3):addy(7)
			end,
			OnCommand=function(self)
				local c = failed and color("#292929") or color("#292929")
				self:sleep(1)
						:decelerate(0.25):zoomto(_screen.w - 150, 45):diffusecolor(c)
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},
		Def.Quad{
			InitCommand=function(self)
				local c = failed and Color.Red or Color.Yellow
				self:zoomto(0, 30):diffusecolor(c):diffusealpha(0.3)
			end,
			OnCommand=function(self)
				local c = failed and color("#292929") or color("#292929")
				self:sleep(1)
						:decelerate(0.25):zoomto(_screen.w - 150, 30):diffusecolor(c)
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},

		-- Top line
		Def.Quad{
			InitCommand=function(self)
				local c = failed and color("#959c96") or color("#d19213")
				self:zoomto(0, 2):diffuse(c):addy(-30)
			end,
			OnCommand=function(self)
				self:sleep(1)
						:decelerate(0.25):zoomto(_screen.w - 150, 2)
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},
		-- Bottom line
		Def.Quad{
			InitCommand=function(self)
				local c = failed and color("#6e0000") or color("#d19213")
				self:zoomto(0, 2):diffuse(c):addy(30)
			end,
			OnCommand=function(self)
				self:sleep(1)
						:decelerate(0.25):zoomto(_screen.w - 400, 2)
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},

		-- Sprites
		Def.Sprite{
			Texture=img,
			InitCommand=function(self)
				self:zoom(0.5):zoomy(0)
			end,
			OnCommand=function(self)
				local c = failed and Color.Red or Color.Yellow
				local offset = failed and 75 or WideScale(75, 105)
				self:sleep(1)
						:linear(0.05):zoomy(0.5):diffuse(c)
						:decelerate(0.2):x(-_screen.w / 2 + offset):diffuse(color(0, 0, 0, 0))
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},
		Def.Sprite{
			Texture=img,
			InitCommand=function(self)
				self:rotationy(180):zoom(0.5):zoomy(0)
			end,
			OnCommand=function(self)
				local c = failed and Color.Red or Color.Yellow
				local offset = failed and 75 or WideScale(75, 105)
				self:sleep(1)
						:linear(0.05):zoomy(0.5):diffuse(c)
						:decelerate(0.2):x(_screen.w / 2 - offset):diffuse(color(0, 0, 0, 0))
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},
	}

	if failed then
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG7/NoEscape.png"),
			InitCommand=function(self)
				self:zoom(0.3):zoomx(0.26):diffusealpha(0)
			end,
			OnCommand=function(self)
				self:sleep(1):diffusealpha(1)
						:linear(3.25):zoomx(0.3)
						:decelerate(0.5):diffusealpha(0)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG7-Failed.ogg"))
			end
		}
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG7/Death.mp4"),
			InitCommand=function(self)
				self:zoom(0.45):y(220):blend("BlendMode_Add")
			end,
			OnCommand=function(self)
				self:sleep(4.5)
						:linear(0.5):diffusealpha(0)
			end,
		}
	else
		local image = THEME:GetPathG("", "_VisualStyles/SRPG7/MonsterVanquished.png")

		local bosses = {
			["e52ab3c368462981"]="RaidBossVanquished.png",
			["2cef87c3665147a5"]="RaidBossVanquished.png",
			["17a52e081e74857e"]="RaidBossVanquished.png",
			["33ff572412b63ac0"]="RaidBossVanquished.png",
			["100ea9df724484aa"]="RaidBossVanquished.png",
			["96bdaba7a0310912"]="RaidBossVanquished.png",
			["64d6272b10a0333d"]="RaidBossVanquished.png",
			["b537bc44519c5c08"]="RaidBossVanquished.png",
			["da61d81de440979c"]="RaidBossVanquished.png",
			["fe05440c9e2a75cc"]="RaidBossVanquished.png",
			["fbe6e5cd839f4d19"]="RaidBossVanquished.png",
			["28ebefeb4a4dc6f7"]="RaidBossVanquished.png",

			["da01b926476f9a8c"]="GodVanquished.png",
			["9a7a415331832c1a"]="GodVanquished.png",
			["9d8bd02b2620a03b"]="GodVanquished.png",
		}

		local found_boss = false
		for player in ivalues(GAMESTATE:GetHumanPlayers()) do
			local pn = ToEnumShortString(player)
			local chartHash = SL[pn].Streams.Hash
			if bosses[chartHash] ~= nil then
				image = THEME:GetPathG("", "_VisualStyles/SRPG7/"..bosses[chartHash])
				found_boss = true
				break
			end
		end

		if not found_boss and not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong():GetLastSecond() > 16 * 60 then
			image = THEME:GetPathG("", "_VisualStyles/SRPG7/HorrorVanquished.png")
		end

		af[#af+1] = Def.Sprite{
			Texture=image,
			InitCommand=function(self)
				self:zoom(0.25):zoomx(0.2):diffusealpha(0):addy(5)
			end,
			OnCommand=function(self)
				self:sleep(1):diffusealpha(1):queuecommand("Next")
			end,
			NextCommand=function(self)
				self:linear(3.25):zoomx(0.25)
						:decelerate(0.5):diffusealpha(0)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG7-Passed.ogg"))
			end
		}
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG7/Cleared.mp4"),
			InitCommand=function(self)
				self:zoom(0.9):y(260):blend("BlendMode_Add"):croptop(0.2):cropbottom(0.2):diffusealpha(0)
			end,
			OnCommand=function(self)
				self:linear(0.5):diffusealpha(1)
						:sleep(4)
						:linear(0.5):diffusealpha(0)
			end,
		}

	end

	return af	

elseif style == "SRPG8" then
	local bgWidth = 200
	local bgHeight = 250

	local af = Def.ActorFrame{
		InitCommand=function(self)
			self:xy(SCREEN_WIDTH/2,SCREEN_HEIGHT/2-50)
			self:zoomy(0)
		end,
		OnCommand=function(self)
			self:decelerate(0.5)
			self:zoomy(1)
		end,

		Def.Quad{
			InitCommand=function(self)
				-- Opaque quad for the main middle segment.
				self:SetWidth(bgWidth):SetHeight(bgHeight)
					:diffuse(color("#000000")):diffusealpha(0.99)
			end,
			OnCommand=function(self)
				self:sleep(failed and 4 or 3.5)
						:decelerate(0.5):diffusealpha(0)
			end
		},


		Def.Quad{
			InitCommand=function(self)
				local width = (SCREEN_WIDTH - bgWidth) / 2
				-- Transparent side quads
				self:SetWidth(width):SetHeight(bgHeight):addx(-(width + bgWidth)/2)
					:diffuse(color("#000000")):diffusealpha(0.99)
					:diffuseleftedge(color("0,0,0,0.4"))
			end,
			OnCommand=function(self)
				self:sleep(failed and 4 or 3.5)
						:decelerate(0.5):diffusealpha(0)
			end
		},

		-- Top line
		Def.Quad{
			InitCommand=function(self)
				local c = failed and color("#959c96") or color("#d19213")
				self:zoomto(0, 2):diffuse(c):addy(-30)
			end,
			OnCommand=function(self)
				self:sleep(1)
						:decelerate(0.25):zoomto(_screen.w - 150, 2)
						:sleep(3)
						:decelerate(0.5):diffusealpha(0)
			end,
		},
		-- Bottom line
		Def.Quad{
			InitCommand=function(self)
				local width = (SCREEN_WIDTH - bgWidth) / 2
				-- Transparent side quads
				self:SetWidth(width):SetHeight(bgHeight):x((width + bgWidth)/2)
					:diffuse(color("#000000")):diffusealpha(0.99)
					:diffuserightedge(color("0,0,0,0.4"))
			end,
			OnCommand=function(self)
				self:sleep(failed and 4 or 3.5)
						:decelerate(0.5):diffusealpha(0)
			end
		},
	}

	if failed then
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG8/Failed.mp4"),
			InitCommand=function(self)
				self:y(50):zoom(0.75):blend("BlendMode_Add")
			end,
			OnCommand=function(self)
				self:sleep(4)
					:linear(0.5):diffusealpha(0)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG8-Failed.ogg"))
			end,
		}
	else
		af[#af+1] = Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG8/Cleared.mp4"),
			InitCommand=function(self)
				self:y(50):zoom(0.75):blend("BlendMode_Add")
			end,
			OnCommand=function(self)
				self:sleep(3.5)
					:linear(0.5):diffusealpha(0)
				SOUND:PlayOnce(THEME:GetPathS("", "SRPG8-Cleared.ogg"))
			end,
		}

	end

	return af
elseif style == "SRPG9" then
	local zoomFactor = 480 / 2160

	local totalTime = 3

	local dir = nil
	local sectionColor = nil
	local filename = nil
	if failed then
		dir = 1
		sectionColor = color("#fb014d")
		bgColor = color("#c73434")
		filename = "FID.mp4"
	else
		dir = -1
		sectionColor = color("#2092A8")
		bgColor = color("#0B3138")
		filename = "FLO.mp4"
	end

	local af = Def.ActorFrame{
		InitCommand=function(self)
			self:Center()
		end,
		OnCommand=function(self)
			self:sleep(totalTime - 0.5):linear(0.5):diffusealpha(0)
		end,
	}

	af[#af+1] = Def.Quad{
		InitCommand=function(self)
			self:diffuse(bgColor):diffusealpha(0.2)
			self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
		end,
	}

	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:y(-SCREEN_CENTER_Y)
		end,
		OnCommand=function(self)
			self:decelerate(0.016 * 40):addx(-240 * dir)
		end,

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/section.png"),
			InitCommand=function(self)
				self:rotationz(70 * dir):y(10):diffuse(sectionColor)
			end,
			OnCommand=function(self)
				self:accelerate(0.1):rotationz(-110 * dir):decelerate(0.7):rotationz(-270 * dir):accelerate(0.3):rotationz(-280 * dir):diffusealpha(0)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/moon.png"),
			InitCommand=function(self)
				self:y(self:GetHeight()/2 * zoomFactor):zoom(zoomFactor)
			end,
		},

		Def.ActorFrame{
			InitCommand=function(self)
				self:y(-15)
			end,

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskSource():zoom(0.295)
				end,
			},

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskDest():zoom(0.3)
				end,
			},
		},


		Def.ActorFrame{  
			InitCommand=function(self)
				self:y(-15)
			end,

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskSource():zoom(0.2):visible(false)
				end,
				OnCommand=function(self)
					self:sleep(0.16):linear(0.16):visible(true):zoom(0.355)
				end,
			},

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskDest():zoom(0.2):visible(false)
				end,
				OnCommand=function(self)
					self:sleep(0.16):linear(0.16):visible(true):zoom(0.36)
				end,
			},
		},



		Def.ActorFrame{  
			InitCommand=function(self)
				self:y(-15)
			end,

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskSource():zoom(1):visible(false)
				end,
				OnCommand=function(self)
					self:sleep(0.16):linear(0.16):visible(true):zoom(0.99)
				end,
			},

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskDest():zoom(0.2):visible(false):diffuse(sectionColor):diffusealpha(0.2)
				end,
				OnCommand=function(self)
					self:sleep(0.16):linear(0.16):visible(true):zoom(1)
				end,
			},
		},

		Def.Quad{
			InitCommand=function(self)
				self:diffuse(sectionColor):diffusealpha(0.2):rotationz(15 * dir)
				self:zoomto(2, 2000)
			end,
			OnCommand=function(self)
				self:linear(1.4):rotationz(-90 * dir)
			end,
		},

		Def.Quad{
			InitCommand=function(self)
				self:diffusealpha(0.2)
				self:zoomto(2, 2000)
			end,
			OnCommand=function(self)
				self:linear(1.4):rotationz(-150 * dir)
			end,
		},

		Def.Quad{
			InitCommand=function(self)
				self:zoomto(60, SCREEN_WIDTH):rotationz(90 * dir):x(SCREEN_WIDTH/2 + 95):y(30):visible(false)
			end,
			OnCommand=function(self)
				self:sleep(0.4):queuecommand("Show")
			end,
			ShowCommand=function(self)
				self:visible(true)
				self:decelerate(1):zoomto(0, SCREEN_WIDTH):y(15)
			end,
		},

		Def.ActorFrame{  
			InitCommand=function(self)
				self:y(-15)
			end,
			Def.Sprite{
				Name="Mask",
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskSource():diffuse(color("#ff0000"))
				end,
				OnCommand=function(self)
					self:zoom(0.17):linear(1.2):zoom(3.45)
				end,
			},

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskDest()
				end,
				OnCommand=function(self)
					self:visible(true):zoom(0.2):linear(1):zoom(2.9):linear(0.4):diffusealpha(0)
				end,
			},
		},

		Def.ActorFrame{  
			InitCommand=function(self)
				self:x(-30):y(-15)
			end,
			Def.Sprite{
				Name="Mask",
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskSource():diffuse(color("#ff0000"))
				end,
				OnCommand=function(self)
					self:zoom(0.17):linear(1.2):zoom(3.45)
				end,
			},

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskDest()
				end,
				OnCommand=function(self)
					self:visible(true):zoom(0.2):linear(1):zoom(2.9):linear(0.4):diffusealpha(0)
				end,
			},
		},

		Def.ActorFrame{  
			InitCommand=function(self)
				self:x(20):y(-30)
			end,
			Def.Sprite{
				Name="Mask",
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskSource():diffuse(color("#ff0000"))
				end,
				OnCommand=function(self)
					self:zoom(0.17):linear(1.2):zoom(3.45)
				end,
			},

			Def.Sprite{
				Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/circle.png"),
				InitCommand=function(self)
					self:MaskDest()
				end,
				OnCommand=function(self)
					self:visible(true):zoom(0.2):linear(1):zoom(2.9):linear(0.4):diffusealpha(0)
				end,
			},
		},
	}

	-- All the moving triangles
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:y(300):x(-200):visible(false)
		end,
		OnCommand=function(self)
			self:sleep(0.2):queuecommand("Move")
		end,
		MoveCommand=function(self)
			self:visible(true):linear(0.7):addy(-400):addx(400 * dir):queuecommand("Hide")
		end,
		HideCommand=function(self)
			self:linear(0.1):diffusealpha(0)
		end,
		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/right.png"),
			InitCommand=function(self)
				self:zoom(0.3):rotationz(170):rotationy(180):x(-80)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.07):rotationz(80):x(-140):y(-80)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.04):rotationz(120):x(-130):y(-140)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.2):rotationz(10):x(0):y(-120)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/right.png"),
			InitCommand=function(self)
				self:zoom(0.14):rotationz(-100):rotationy(180):x(70):y(-130)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.13):rotationz(-10):rotationy(180):x(80):y(-80)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.2):rotationz(-10):x(200)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.16):rotationz(-140):x(230):y(-210)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/right.png"),
			InitCommand=function(self)
				self:zoom(0.24):rotationz(10):rotationy(180):x(260):y(-320)
			end,
		},
	}

	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:y(300):x(-300):visible(false)
		end,
		OnCommand=function(self)
			self:sleep(0.2):queuecommand("Move")
		end,
		MoveCommand=function(self)
			self:visible(true):linear(0.7):addy(-500):addx(200 * dir):queuecommand("Hide")
		end,
		HideCommand=function(self)
			self:linear(0.1):diffusealpha(0)
		end,
		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/right.png"),
			InitCommand=function(self)
				self:zoom(0.2):rotationz(80):x(-80)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.1):rotationz(-10):rotationy(180):x(-140):y(-80)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.04):rotationz(80):x(-130):y(-140)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.2):rotationz(-110):x(0):y(-120)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/right.png"),
			InitCommand=function(self)
				self:zoom(0.14):rotationz(50):rotationy(180):x(70):y(-130)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/iso.png"),
			InitCommand=function(self)
				self:zoom(0.13):rotationz(10):rotationy(180):x(80):y(-80)
			end,
		},
	}

	af[#af+1] = Def.Quad{
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH, 0):diffuse(Color.Black):visible(false) end,
		OnCommand=function(self) self:sleep(1):accelerate(0.5):visible(true):zoomto(SCREEN_WIDTH, SCREEN_HEIGHT) end,
	}

	af[#af+1] = Def.Sprite{
		Texture=THEME:GetPathG("", "_VisualStyles/SRPG9/Eval/"..filename),
		InitCommand=function(self)
			self:zoom(0.75):blend("BlendMode_Add")
		end,
	}

	return af
else 
	local img = failed and "failed text.png" or "cleared text.png"

	return Def.ActorFrame{
		Def.Quad{
			InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end,
			OnCommand=function(self) self:sleep(0.2):linear(0.5):diffusealpha(0) end,
		},

		LoadActor(img)..{
			InitCommand=function(self) self:Center():zoom(0.8):diffusealpha(0) end,
			OnCommand=function(self) self:accelerate(0.4):diffusealpha(1):sleep(0.6):decelerate(0.4):diffusealpha(0) end
		}
	}
end