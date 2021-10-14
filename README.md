# Multicharacter

# Image:
<a href="https://ibb.co/p3SXBhY"><img src="https://i.ibb.co/dQRKwm8/1.png" alt="1" border="0"></a>
<a href="https://ibb.co/2ckqJMf"><img src="https://i.ibb.co/c2rJq87/2.png" alt="2" border="0"></a>

# VIDEO: 
https://youtu.be/V87r0_HAujE

## Features
- You can see your character.
- Slots can be unlocked vip players or everyone.
- Cinematic intro

## F.A.Q
### My character is not saved, what should I do?
- Your character is not saved because es_extended is not triggered. There is currently no solution for this issue.

### My character does not appear on the screen or appears as invisible, what should I do?
- Set `skinnothave` true in the config. This error is caused because esx_skin is not triggered.

### Can I use this script without deleting my previous characters?
- Yes, if you are not using a multicharacter before, you will not have a problem when you switch to this system.

### I'm using extendedmode or a version older than 1.2. Is it supported?
- I have never used a version older than 1.2. But it's supported.

### My character does not appear or every time I open a character, it asks me to open a character again.
- Customize identifier setting via config. 

## Requirements
- mx-spawn (https://github.com/MOXHAFOREVA/mx-spawn)

# How To Install

- Open your `server.cfg` and add `ensure mx-multicharacter` `ensure mx-spawn`


- if using newest esx, es_extended > client > main.lua 3 - 12 lines find

```
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)
```

- change with
```
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		if NetworkIsPlayerActive(PlayerId()) then
-- 			TriggerServerEvent('esx:onPlayerJoined')
-- 			break
-- 		end
-- 	end
-- end)
```

- if using essentialmode, essentialmode > client > main.lua 7 - 17 lines find
```
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('es:firstJoinProper')
			TriggerEvent('es:allowedToSpawn')
			return
		end
	end
end)
```
- change with 
```
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		if NetworkIsSessionStarted() then
-- 			TriggerServerEvent('es:firstJoinProper')
-- 			TriggerEvent('es:allowedToSpawn')
-- 			return
-- 		end
-- 	end
-- end)
```

- If you are using esx_identity remove it.

- And finally add this to the skinchanger > client > main.lua

```
exports('loadmulticharpeds', function(multipedID, skin)
	local MultiPed = {}
	for i=1, #Components, 1 do
		MultiPed[Components[i].name] = Components[i].value
	end
	for k,v in pairs(skin) do
		MultiPed[k] = v
	end

	SetPedHeadBlendData			(multipedID, MultiPed['face'], MultiPed['face'], MultiPed['face'], MultiPed['skin'], MultiPed['skin'], MultiPed['skin'], 1.0, 1.0, 1.0, true)

	SetPedHairColor				(multipedID,			MultiPed['hair_color_1'],		MultiPed['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay			(multipedID, 3,		MultiPed['age_1'],				(MultiPed['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(multipedID, 0,		MultiPed['blemishes_1'],		(MultiPed['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
	SetPedHeadOverlay			(multipedID, 1,		MultiPed['beard_1'],			(MultiPed['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(multipedID,			MultiPed['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(multipedID, 2,		MultiPed['eyebrows_1'],		(MultiPed['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedHeadOverlay			(multipedID, 4,		MultiPed['makeup_1'],			(MultiPed['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
	SetPedHeadOverlay			(multipedID, 8,		MultiPed['lipstick_1'],		(MultiPed['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
	SetPedComponentVariation	(multipedID, 2,		MultiPed['hair_1'],			MultiPed['hair_2'], 2)						-- Hair
	SetPedHeadOverlayColor		(multipedID, 1, 1,	MultiPed['beard_3'],			MultiPed['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(multipedID, 2, 1,	MultiPed['eyebrows_3'],		MultiPed['eyebrows_4'])					-- Eyebrows Color
	SetPedHeadOverlayColor		(multipedID, 4, 1,	MultiPed['makeup_3'],			MultiPed['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor		(multipedID, 8, 1,	MultiPed['lipstick_3'],		MultiPed['lipstick_4'])					-- Lipstick Color
	SetPedHeadOverlay			(multipedID, 5,		MultiPed['blush_1'],			(MultiPed['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(multipedID, 5, 2,	MultiPed['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(multipedID, 6,		MultiPed['complexion_1'],		(MultiPed['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(multipedID, 7,		MultiPed['sun_1'],				(MultiPed['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(multipedID, 9,		MultiPed['moles_1'],			(MultiPed['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(multipedID, 10,		MultiPed['chest_1'],			(MultiPed['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(multipedID, 10, 1,	MultiPed['chest_3'])														-- Torso Color
	SetPedHeadOverlay			(multipedID, 11,		MultiPed['bodyb_1'],			(MultiPed['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity

	if MultiPed['ears_1'] == -1 then
		ClearPedProp(multipedID, 2)
	else
		SetPedPropIndex			(multipedID, 2,		MultiPed['ears_1'],			MultiPed['ears_2'], 2)						-- Ears Accessories
	end

	SetPedComponentVariation	(multipedID, 8,		MultiPed['tshirt_1'],			MultiPed['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(multipedID, 11,		MultiPed['torso_1'],			MultiPed['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(multipedID, 3,		MultiPed['arms'],				MultiPed['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(multipedID, 10,		MultiPed['decals_1'],			MultiPed['decals_2'], 2)					-- decals
	SetPedComponentVariation	(multipedID, 4,		MultiPed['pants_1'],			MultiPed['pants_2'], 2)					-- pants
	SetPedComponentVariation	(multipedID, 6,		MultiPed['shoes_1'],			MultiPed['shoes_2'], 2)					-- shoes
	SetPedComponentVariation	(multipedID, 1,		MultiPed['mask_1'],			MultiPed['mask_2'], 2)						-- mask
	SetPedComponentVariation	(multipedID, 9,		MultiPed['bproof_1'],			MultiPed['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(multipedID, 7,		MultiPed['chain_1'],			MultiPed['chain_2'], 2)					-- chain
	SetPedComponentVariation	(multipedID, 5,		MultiPed['bags_1'],			MultiPed['bags_2'], 2)						-- Bag

	if MultiPed['helmet_1'] == -1 then
		ClearPedProp(multipedID, 0)
	else
		SetPedPropIndex			(multipedID, 0,		MultiPed['helmet_1'],			MultiPed['helmet_2'], 2)					-- Helmet
	end

	if MultiPed['glasses_1'] == -1 then
		ClearPedProp(multipedID, 1)
	else
		SetPedPropIndex			(multipedID, 1,		MultiPed['glasses_1'],			MultiPed['glasses_2'], 2)					-- Glasses
	end

	if MultiPed['watches_1'] == -1 then
		ClearPedProp(multipedID, 6)
	else
		SetPedPropIndex			(multipedID, 6,		MultiPed['watches_1'],			MultiPed['watches_2'], 2)					-- Watches
	end

	if MultiPed['bracelets_1'] == -1 then
		ClearPedProp(multipedID,	7)
	else
		SetPedPropIndex			(multipedID, 7,		MultiPed['bracelets_1'],		MultiPed['bracelets_2'], 2)				-- Bracelets
	end
	MultiPed = nil
end)
```



