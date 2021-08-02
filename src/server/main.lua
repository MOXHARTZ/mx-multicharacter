RegisterNetEvent('mx-multicharacter:CreateCharacter')
RegisterNetEvent('mx-multicharacter:GetCharacters')
RegisterNetEvent('mx-multicharacter:DeleteCharacter')
RegisterNetEvent('mx-multicharacter:GetLastLoc')
RegisterNetEvent('mx-multicharacter:CheckCharacterIsOwner')

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function ()
     Wait(1000)
     if GetCurrentResourceName() ~= 'mx-multicharacter' then
          print('^2 Hey that\'s not my name :( '..GetCurrentResourceName()..'^1')
     end
end)

AddEventHandler('mx-multicharacter:DeleteCharacter', function(cid) MX:DeleteCharacter(source, cid) end)

AddEventHandler('mx-multicharacter:GetLastLoc', function()
     local src = source
     local fetch = [[SELECT position FROM users WHERE citizenid = @cid;]]
     local fetchData = {
          ['@cid'] = MX:GetCitizenId(src)
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     if result and result[1] then
          local pos = vec3(json.decode(result[1].position).x or 1, json.decode(result[1].position).y or 1, json.decode(result[1].position).z or 1)
          MX:TCE('mx-multicharacter:GetLastLoc', src, pos)
     else
          MX:TCE('mx-multicharacter:GetLastLoc', src, vec3(1, 1, 1))
     end
end)

AddEventHandler('mx-multicharacter:GetCharacters', function ()
     local src = source
     if not src then DropPlayer(src, '[MX-MULTICHARACTER] Your information was not found') end
     local player = MX:GetIdentifier(src) if not player then DropPlayer(src, '[MX-MULTICHARACTER] Your information was not found') end
     local fetch = [[SELECT * FROM users WHERE identifier = @id;]]
     local fetchData = {
          ['@id'] = player
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     if result and #result > 0 then
          local data = {}
          if not MX.essentialmode then
               for i = 1, #result do
                    table.insert(data, {
                         citizenid = result[i].citizenid or '',
                         queue = result[i].queue or '',
                         firstname = result[i].firstname or '',
                         lastname = result[i].lastname or '',
                         dateofbirth = result[i].dateofbirth or '',
                         sex = result[i].sex or '',
                         cash = json.decode(result[i].accounts).money or 0,
                         bank = json.decode(result[i].accounts).bank or 0,
                         skin = json.decode(result[i].skin) or false
                    })
               end
          else
               for i = 1, #result do
                    local resultM = MySQL.Sync.fetchAll('SELECT name, money FROM user_accounts WHERE identifier = @id', {
                         ['@id'] = result[i].citizenid
                    })
                    table.insert(data, {
                         citizenid = result[i].citizenid or '',
                         queue = result[i].queue or '',
                         firstname = result[i].firstname or '',
                         lastname = result[i].lastname or '',
                         dateofbirth = result[i].dateofbirth or '',
                         sex = result[i].sex or '',
                         skin = json.decode(result[i].skin) or false
                    })
                    if resultM and resultM[1] then
                         for j = 1, #resultM do
                              data[i].cash = resultM[j].name == 'money' and resultM[j].money or 0
                              data[i].bank = resultM[j].name == 'bank' and resultM[j].money or 0
                         end
                    end
               end
          end
          Wait(0)
          local slots = {}
          local slotsResult = [[SELECT slots FROM user_slots WHERE identifier = @id;]]
          local slotsResultData = MySQL.Sync.fetchAll(slotsResult, fetchData)
          if slotsResultData and slotsResultData[1] then
               slots = json.decode(slotsResultData[1].slots)
          else
               slots = {}
          end
          MX:TCE('mx-multicharacter:GetCharacters', src, data, slots)
     else
          local slots = {}
          local slotsResult = [[SELECT slots FROM user_slots WHERE identifier = @id;]]
          local slotsResultData = MySQL.Sync.fetchAll(slotsResult, fetchData)
          if slotsResultData and slotsResultData[1] then
               slots = json.decode(slotsResultData[1].slots)
          else
               slots = {}
          end
          MX:TCE('mx-multicharacter:GetCharacters', src, {}, slots)
     end
end)

AddEventHandler('playerDropped', function () MX:PlayerDropped(source) end)

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

exports('GetCitizenId', function (source)
     if not source then return false end
     return MX:GetCitizenId(source)
end)

function MX:GetCitizenId(source) 
     if #self.players <= 0 then return false end
     for k,v in pairs(self.players) do
          if k == source then
               return v               
          end
     end
     return false
end

AddEventHandler('mx-multicharacter:CreateCharacter', function (source, tt) 
     local src = source
     if not tt then
          local cid = MX:CreateCitizenId()
          MX:TCE('mx-multicharacter:SetCitizenId', src, cid)
          MX.players[src] = cid
     else
          MX.players[src] = tt
          MX:TCE('mx-multicharacter:SetCitizenId', src, tt)
     end
end)

AddEventHandler('mx-multicharacter:CheckCharacterIsOwner', function (data)
     local src = source
     if MX:CheckCharacterIsOwner(src, data) then
          TriggerEvent('mx-multicharacter:CreateCharacter', src, data)
          MX:TCE('mx-spawn:Open', src, data)
     else
          DropPlayer(src, 'You dont have this character.')
     end
end)

function MX:CheckCharacterIsOwner(source, cid)
     local fetch = [[SELECT citizenid FROM users WHERE identifier = @identifier;]]
     local fetchData = {
          ['@identifier'] = self:GetIdentifier(source)
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     if result and #result >= 1 then
          for i = 1, #result do
               if cid == result[i].citizenid then
                    return true
               end
          end
     else
          return false
     end
     return false
end

function MX:CreateCitizenId()
     local uniq = false
     local cid = nil
     while not uniq do
          Wait(100)
          cid = tostring(MX:RandomStr(4) .. MX:RandomInt(4))
          local fetch = [[SELECT citizenid FROM users WHERE citizenid = @cid;]]
          local fetchData = {['@cid'] = cid}
          local result = MySQL.Sync.fetchAll(fetch, fetchData)
          if #result == 0 then
               uniq = true
          end
     end
     return cid
end

function MX:DeleteCharacter(source, cid)
     if cid and source then
          if self:CheckCharacterIsOwner(source, cid) then
               for _, v in pairs(self.DeleteTables) do
                    MySQL.Sync.execute("DELETE FROM `"..v.table.."` WHERE `"..v.owner.."` = '"..cid.."'")
               end
               Wait(200)
               DropPlayer(source, 'Your character has been deleted, please login again.') 
          else
               DropPlayer(src, 'You dont have this character.')
          end
     else
          DropPlayer(source, '...') 
     end
end

function MX:PlayerDropped(source)
     if self.players[source] then
          self.players[source] = nil
     end
end

function MX:RandomInt(length)
	if length > tonumber('0') then
		return self:RandomInt(length-tonumber('1')) .. NumberCharset[math.random(tonumber('1'), #NumberCharset)]
	else
		return ''
	end
end
      
function MX:RandomStr(length)
	if length > 0 then
		return self:RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

function MX:GetIdentifier(player)
     for _,v in pairs(GetPlayerIdentifiers(player)) do
          if self.Identifier == 'steam' then  
               if string.match(v, 'steam') then
                    return v
               end
          elseif self.Identifier == 'license' then
               if string.match(v, 'license:') then
                    return string.sub(v, 9)
               end
          end
     end
     return false
end

function MX:TCE(...)
     TriggerClientEvent(...)
end

RegisterCommand('giveslot', function (source, args)
     local src = source
     local player = ESX.GetPlayerFromId(args[1])
     local playerx = ESX.GetPlayerFromId(src)
     if not src then return false end
     if playerx.getGroup() == 'admin' or playerx.getGroup() == 'superadmin' then 
          local type = args[2] == '2' and 'slot2' or args[2] == '3' and 'slot3' or args[2] == '4' and 'slot4' or false
          if not args[1] or not args[2] or not type then return MX:TCE('esx:showNotification', src, 'Usage: /giveslot id slotid | Example Usage: /giveslot 1 2') end
          local fetch = [[SELECT slots FROM user_slots WHERE identifier = @id;]]
          local fetchData = {['@id'] = player.identifier}
          local result = MySQL.Sync.fetchAll(fetch, fetchData)
          if result and result[1] then
               local data = json.decode(result[1].slots)
               data[type] = true
               local update = [[UPDATE user_slots SET slots = @slots WHERE identifier = @id;]]
               local updateData = {['@slots'] = json.encode(data), ['@id'] = player.identifier}
               MySQL.Sync.execute(update, updateData)
          else
               local newData = {
                    slot2 = false,
                    slot3 = false,
                    slot4 = false
               }
               local insert = [[INSERT INTO user_slots (identifier, slots) VALUES (@id, @slots);]]
               local insertData = {
                    ['@id'] = player.identifier,
                    ['@slots'] = json.encode(newData)
               }
               newData[type] = true
               MySQL.Sync.execute(insert, insertData)
          end
     else
          return MX:TCE('esx:showNotification', src, 'Access Denied')
     end
end)

RegisterCommand('takeslot', function (source, args)
     local src = source
     local player = ESX.GetPlayerFromId(args[1])
     local playerx = ESX.GetPlayerFromId(src)
     if not src then return false end
     if playerx.getGroup() == 'admin' or playerx.getGroup() == 'superadmin' then 
          local type = args[2] == '2' and 'slot2' or args[2] == '3' and 'slot3' or args[2] == '4' and 'slot4' or false
          if not args[1] or not args[2] or not type then return MX:TCE('esx:showNotification', src, 'Usage: /takeslot id slotid | Example Usage: /takeslot 1 2') end
          local fetch = [[SELECT slots FROM user_slots WHERE identifier = @id;]]
          local fetchData = {['@id'] = player.identifier}
          local result = MySQL.Sync.fetchAll(fetch, fetchData)
          if result and result[1] then
               local data = json.decode(result[1].slots)
               data[type] = false
               local update = [[UPDATE user_slots SET slots = @slots WHERE identifier = @id;]]
               local updateData = {['@slots'] = json.encode(data), ['@id'] = player.identifier}
               MySQL.Sync.execute(update, updateData)
          else
               local insert = [[INSERT INTO user_slots (identifier, slots) VALUES (@id, @slots);]]
               local insertData = {
                    ['@id'] = player.identifier,
                    ['@slots'] = json.encode({
                         slot2 = false,
                         slot3 = false,
                         slot4 = false
                    })
               }
               MySQL.Sync.execute(insert, insertData)
          end
     else
          return MX:TCE('esx:showNotification', src, 'Access Denied')
     end
end)
