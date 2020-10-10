ESX              = nil
local PlayerData = {}
local isDead = false

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

local datastore = {
    kills = 0,
    deaths = 0,
    total = 1.00
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  	PlayerData.job = job
end)

AddEventHandler('playerSpawned', function()
    isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

--[[main shit]]
RegisterNetEvent('esx_killdeathratio:pushUpdate')
AddEventHandler('esx_killdeathratio:pushUpdate', function(data)
	if data then
		datastore = {
			kills = data.kills,
			deaths = data.deaths
		}
		datastore.total = ESX.Math.Round((data.kills / data.deaths), 2)
	end
end)

--[[heartbeat]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		print('kdr update sent')
		TriggerServerEvent('esx_killdeathratio:requestUpdate')
	end
end)

local drawText = function(text, x, y, r, g, b, a)
	SetTextFont(4)
	SetTextScale(0.5, 0.5)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(tostring(text))
	EndTextCommandDisplayText(x, y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        drawText(('K: '..datastore.kills..'\nD: '..datastore.deaths..'\nR: '..datastore.total), 0.0, 0.85, 255, 255, 255, 255)
    end
end)
