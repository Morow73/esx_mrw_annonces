----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------- AUTHORS Morow:https://github.com/Morow73 ------------------------------------------------------------------------------

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}





ESX                             = nil

local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


AddEventHandler('esx_mrw_annonces:hasEnteredMarker', function(zone)
	if zone == 'Annonces' then
		CurrentAction     = 'passer_annonces'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour passer une annonces ~r~(100$)'
		CurrentActionData = {zone= zone}
	end		
end)


AddEventHandler('esx_mrw_annonces:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()  

	CurrentAction = nil
end)


AddEventHandler('onResourceStart', function(resource)

  blips()

end)


Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do

			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
	end
end)


Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_mrw_annonces:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_mrw_annonces:hasExitedMarker', LastZone)
		end
	
	end
end)


Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0,  Keys['E']) then

				if CurrentAction == 'passer_annonces' then
					TriggerServerEvent('esx_mrw_annonces:PayToAnnonces')
					
				end
				
				CurrentAction = nil
			end
		end
	end
end)


RegisterNetEvent('esx_mrw_annonces:Annonces')
AddEventHandler('esx_mrw_annonces:Annonces', function()

    Citizen.CreateThread(function()

      Citizen.Wait(1)

        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 100)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
           Citizen.Wait(1)
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            TriggerServerEvent('esx_mrw_annonces:Annonces', result)
                 
        end   
    end)
end)      

RegisterNetEvent('esx_mrw_annonces:ToAnnonces')
AddEventHandler('esx_mrw_annonces:ToAnnonces', function(result)


    ESX.Scaleform.ShowBreakingNews('Petite-Annonce', result, bottom, 10)  
	
end)


function blips()

	local blip = AddBlipForCoord(Config.Zones.Annonces.Pos.x, Config.Zones.Annonces.Pos.y, Config.Zones.Annonces.Pos.z)
	SetBlipSprite (blip, 184)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 68)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Annonces")
	EndTextCommandSetBlipName(blip)

end
 