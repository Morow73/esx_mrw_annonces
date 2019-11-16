----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------- AUTHORS Morow:https://github.com/Morow73 ------------------------------------------------------------------------------

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

			if IsControlJustReleased(0, 38) then

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


Citizen.CreateThread(function()

	local blip = AddBlipForCoord(Config.Zones.Annonces.Pos.x, Config.Zones.Annonces.Pos.y, Config.Zones.Annonces.Pos.z)
	SetBlipSprite (blip, 184)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 68)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Annonces")
	EndTextCommandSetBlipName(blip)

end)
 
