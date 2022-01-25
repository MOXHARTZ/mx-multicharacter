RegisterNetEvent('mx-multicharacter:GetCharacters')
RegisterNetEvent('mx-multicharacter:DeleteCharacter')
RegisterNetEvent('mx-multicharacter:GetLastLoc')
RegisterNetEvent('mx-multicharacter:CheckCharacterIsOwner')
RegisterNetEvent('mx-multicharacter:CreateCharacter')

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
     local fetch = [[SELECT position FROM users WHERE identifier = @cid;]]
     local fetchData = {
          ['@cid'] = MX:GetIdentifier(src)
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     if result and result[1] then
          local pos = vec3(json.decode(result[1].position).x or 1, json.decode(result[1].position).y or 1, json.decode(result[1].position).z or 1)
          MX:TCE('mx-multicharacter:GetLastLoc', src, pos)
     else
          MX:TCE('mx-multicharacter:GetLastLoc', src, vec3(1, 1, 1))
     end
end)

AddEventHandler('mx-multicharacter:CreateCharacter', function (data)
     local src = source
     MX:SetLastCharacter(src, tonumber(data.queue))
     MX:TCE('mx-multicharacter:StartESX', src)
     while not ESX.GetPlayerFromId(src) do Wait(500) print('Loading ESX for '..GetPlayerName(src)..'') end
     MX:SetGeneralInfos(MX:GetIdentifier(src), data)
     if MX.skinnothave then
          MX:TCE('mx-multicharacter:OpenSkinMenu', src, data.sex)
     end
end)

local settedIdentifier = false
AddEventHandler('mx-multicharacter:GetCharacters', function ()
     local src = source
     if not settedIdentifier then MX:CheckIdentifier() end
     if not src then DropPlayer(src, '[MX-MULTICHARACTER] Your information was not found') end
     MX:SetIdentifierToChar(MX:GetIdentifier(src), MX:GetLastCharacter(src))
     Wait(100)
     local player = MX:GetIdentifier(src) if not player then DropPlayer(src, '[MX-MULTICHARACTER] Your information was not found') end
     local fetch = [[SELECT * FROM users WHERE identifier LIKE @id;]]
     local fetchData = {
          ['@id'] = '%'..player..'%'
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     if result and #result > 0 then
          local data = {}
          if not MX.essentialmode then
               for i = 1, #result do
                    table.insert(data, {
                         queue = tonumber(result[i].identifier:sub(5, 5)),
                         citizenid = result[i].identifier or '',
                         firstname = result[i].firstname or '',
                         lastname = result[i].lastname or '',
                         dateofbirth = result[i].dateofbirth or '',
                         sex = result[i].sex or '',
                         cash = json.decode(result[i].accounts).money or 0,
                         bank = json.decode(result[i].accounts).bank or 0,
                         skin = json.decode(result[i].skin) or {},
                         phone_number = result[i].phone_number or 0,
                         job = MX:GetJobProps(result[i].job, result[i].job_grade) or 'Unemployed'
                    })
               end
          else
               for i = 1, #result do
                    local resultM = MySQL.Sync.fetchAll('SELECT name, money FROM user_accounts WHERE identifier = @id', {
                         ['@id'] = result[i].identifier
                    })
                    table.insert(data, {
                         queue = result[i].identifier:sub(5, 5),
                         citizenid = result[i].identifier or '',
                         firstname = result[i].firstname or '',
                         lastname = result[i].lastname or '',
                         dateofbirth = result[i].dateofbirth or '',
                         sex = result[i].sex or '',
                         skin = json.decode(result[i].skin) or {},
                         phone_number = result[i].phone_number or 0,
                         job = MX:GetJobProps(result[i].job, result[i].job_grade) or 'Unemployed'
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
          local slotsResultData = MySQL.Sync.fetchAll(slotsResult, {['@id'] = MX:GetIdentifier(src)})
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

AddEventHandler('mx-multicharacter:CheckCharacterIsOwner', function (data)
     local src = source
     if MX:CheckCharacterIsOwner(src, data) then
          MX:SetLastCharacter(src, tonumber(data))
          MX:SetCharacter(src, tonumber(data))
          MX:TCE('mx-multicharacter:StartESX', src)
          while not ESX.GetPlayerFromId(src) do Wait(500) print('Loading ESX for '..GetPlayerName(src)..'') end
          if MX.skinnothave then MX:TCE('mx-multicharacter:LoadSkin', src) end
          if MX.MXSpawn then MX:TCE('mx-spawn:Open', src, data) end
     else
          DropPlayer(src, 'You dont have this character.')
     end
end)

function MX:CheckCharacterIsOwner(source, charid)
     local fetch = [[SELECT identifier FROM users WHERE identifier LIKE @identifier;]]
     local fetchData = {
          ['@identifier'] = '%'..self:GetIdentifier(source)..'%'
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     if result and #result >= 1 then
          for i = 1, #result do
               if charid == tonumber(result[i].identifier:sub(5, 5)) then
                    return true
               end
          end
     else
          return false
     end
     return false
end

function MX:GetJobProps(name, grade)
     local fetch = [[SELECT label FROM job_grades WHERE job_name = @name AND grade = @grade;]]
     local fetchData = {
         ['@name'] = name,
         ['@grade'] = grade
     }
     local result = MySQL.Sync.fetchAll(fetch, fetchData)
     return result[1] and result[1].label or false
end

function MX:DeleteCharacter(source, cid)
     if cid and source then
          if self:CheckCharacterIsOwner(source, cid) then
               for _, v in pairs(self.IdentifierTables) do
                    local result = MySQL.Sync.fetchAll("select * from `"..v.table.."` where `"..v.owner.."` = 'Char"..cid..MX:GetIdentifier(source).."' limit 1")
                    if result and result[1] then
                         MySQL.Sync.execute("DELETE FROM `"..v.table.."` WHERE `"..v.owner.."` = 'Char"..cid..MX:GetIdentifier(source).."'")
                    end
               end
               Wait(200)
               self:TCE('mx-multicharacter:refresh', source)
               -- DropPlayer(source, 'Your character has been deleted, please login again.') 
          else
               DropPlayer(source, 'You dont have this character.')
          end
     else
          DropPlayer(source, '...') 
     end
end

function MX:SetLastCharacter(source, charid)
     if source and charid then
         MySQL.Sync.execute("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `identifier` = '"..MX:GetIdentifier(source).."'")
     end
end

function MX:SetIdentifierToChar(identifier, charid)
     for _, itable in pairs(self.IdentifierTables) do
          local result = MySQL.Sync.fetchAll("select * from `"..itable.table.."` where `"..itable.owner.."` = '"..identifier.."' limit 1", {
               ['@column'] = itable.table,
               ['@owner_'] = itable.owner,
               ['@owner'] = identifier
          })
          if result and result[1] then
               MySQL.Sync.execute("UPDATE `"..itable.table.."` SET `"..itable.owner.."` = 'Char"..charid..identifier.."' WHERE `"..itable.owner.."` = '"..identifier.."'")
          end
     end
 end
 
function MX:GetLastCharacter(source)
     if source then
         local LastChar = MySQL.Sync.fetchAll("SELECT `charid` FROM `user_lastcharacter` WHERE `identifier` = '"..MX:GetIdentifier(source).."'")
         if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
             return tonumber(LastChar[1].charid)
         else
             MySQL.Sync.execute("INSERT INTO `user_lastcharacter` (`identifier`, `charid`) VALUES('"..MX:GetIdentifier(source).."', 1)")
             return 1
         end
     end
end
 
function MX:SetCharacter(source, charid)
     if not source then return print('line 190') end

     local currentUserIdentifier = MX:GetIdentifier(source)
     local charIdentifier = 'Char'..charid..MX:GetIdentifier(source)

     for _, itable in pairs(self.IdentifierTables) do
          MySQL.Sync.execute("UPDATE `"..itable.table.."` SET `"..itable.owner.."` = '"..currentUserIdentifier.."' WHERE `"..itable.owner.."` = '"..charIdentifier.."'")
     end
end

function MX:SetGeneralInfos(identifier, data)
     if identifier and data then
         MySQL.Sync.execute("UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dob, sex = @sex WHERE identifier = @identifier", {
             ['@firstname'] = data.firstname,
             ['@lastname'] = data.lastname,
             ['@dob'] = data.dateofbirth,
             ['@sex'] = data.sex,
             ['@identifier'] = identifier
         })
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

function MX:CheckIdentifier()
     print('^1MX-MULTICHARACTER: ^0 Checking ur identifier')
     local result, newIdentifier = MySQL.Sync.fetchAll('select identifier from users limit 1'), false
     if result[1] then
          local identifier = result[1].identifier
          if string.match(identifier, 'steam') then newIdentifier = 'steam' else newIdentifier = 'license' end
          if self.Identifier ~= newIdentifier then self.Identifier = newIdentifier print(('^1MX-MULTICHARACTER: ^0 ^2 Changed Identifier to ^4%s.^0'):format(newIdentifier)) end
          settedIdentifier = true
     else
          print('^1MX-MULTICHARACTER: ^0 No player found on sql.')
     end
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
