
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_mrw_annonces:PayToAnnonces')
AddEventHandler('esx_mrw_annonces:PayToAnnonces', function()
    
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getMoney()
	local price = 100

	if money >= price then 

        xPlayer.removeMoney(price)
        TriggerClientEvent('esx_mrw_annonces:Annonces', _source)
	else 

		TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez ~r~d\'argent')
	end	
end)

RegisterServerEvent('esx_mrw_annonces:Annonces')
AddEventHandler('esx_mrw_annonces:Annonces', function(result)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local Players = ESX.GetPlayers()

    for i=1, #Players, 1 do
	    TriggerClientEvent('esx_mrw_annonces:ToAnnonces', Players[i], result)
	end
end)	