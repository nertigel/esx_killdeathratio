ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

createUser = function(xPlayer)
    if xPlayer then
        MySQL.Async.execute('INSERT INTO kdr (identifier, kills, deaths) VALUES (@identifier, @kills, @deaths)', {
            ['@identifier'] = xPlayer.identifier, 
            ['@kills'] = 0,
            ['@deaths'] = 0,
        })
    end
end

insertData = function(target, type)
    local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM kdr WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local data = {
                    kills = result[1].kills,
                    deaths = result[1].deaths,
                }
                
                if type == 'kills' then
                    MySQL.Async.execute('UPDATE kdr SET kills = @amount WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@amount'] = data.kills + 1
                    })
                elseif type == 'deaths' then
                    MySQL.Async.execute('UPDATE kdr SET deaths = @amount WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@amount'] = data.deaths + 1
                    })
                else
                    print(GetPlayerName(target)..' attempted to exploit insertData by providing an incorrect type')
                end
            else
                createUser(xPlayer)
            end
        end)
	else
		print('esx_killdeathratio: xPlayer not found (addKill)')
	end
end

AddEventHandler('esx_killdeathratio:requestUpload', function(type)
    local _source = source

    insertData(_source, type)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    data.victim = source

    if data and data.victim then
        insertData(data.victim, 'deaths')
        if data.killedByPlayer then
            insertData(data.killerServerId, 'kills')
        end
    else
        TriggerClientEvent('esx:showNotification', -1, GetPlayerName(data.victim) .. ' died')
    end
end)

RegisterServerEvent('esx_killdeathratio:requestUpdate')
AddEventHandler('esx_killdeathratio:requestUpdate', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM kdr WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local data = {
                    kills = result[1].kills,
                    deaths = result[1].deaths,
                }

                TriggerClientEvent('esx_killdeathratio:pushUpdate', _source, data)
            else
                createUser(xPlayer)
            end
        end)
	else
		print('esx_killdeathratio: xPlayer not found (requestUpdate)')
    end
end)

