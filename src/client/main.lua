RegisterNetEvent('mx-multicharacter:GetCharacters')
RegisterNetEvent('mx-multicharacter:notification')
RegisterNetEvent('mx-multicharacter:RefreshCharacters')
RegisterNetEvent('mx-multicharacter:SetCitizenId')

CreateThread(function ()
     while true do
          Wait(0)
          if NetworkIsSessionActive() then
               MX:CharacterSelector()
               break
          end
     end
end)

function MX:Notification(msg)
     SendNUIMessage({
          type = 'notification',
          msg = msg
     })
end

function MX:Cam(bool)
     if bool then
         DoScreenFadeIn(1000)
         FreezeEntityPosition(PlayerPedId(), true)
         cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1126.08, -1262.42, 20.62, 0.0 ,0.0, 216.53, 65.00, false, 0)
         SetCamActive(cam, true)
         RenderScriptCams(true, false, 1, true, true)
     else
         SetCamActive(cam, false)
         DestroyCam(cam, true)
         RenderScriptCams(false, false, 1, true, true)
         FreezeEntityPosition(PlayerPedId(), false)
     end
end

function MX:TSE(...)
     TriggerServerEvent(...)
end

function MX:LoadAnim(dict)
     RequestAnimDict(dict)
     while not HasAnimDictLoaded(dict) do
          Wait(100)
     end
end

function MX:CreatePeds(data)
     for i = 1, 4 do
          if data and next(data) then
               local find = false
               for k,v in pairs(data) do
                    if v.queue == i then
                         find = data[k]
                         break
                    end
               end
               if find then
                    local model = find.skin.sex == 0 and self.DefaultModels[1] or self.DefaultModels[2]
                    if self.createdPeds[i] then SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) DeleteEntity(self.createdPeds[i].ped) end
                    self.createdPeds[i] = find
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                         Wait(100)
                    end
                    self.createdPeds[i].ped = CreatePed(16, model, self.PedSpawnLocs[i].x, self.PedSpawnLocs[i].y, self.PedSpawnLocs[i].z, self.PedSpawnLocs[i].w, 0, 1)
                    PlaceObjectOnGroundProperly(self.createdPeds[i].ped)
                    SetBlockingOfNonTemporaryEvents(self.createdPeds[i].ped, true)
                    exports['skinchanger']:loadmulticharpeds(self.createdPeds[i].ped, find.skin)
                    SetEntityAlpha(self.createdPeds[i].ped, 200)
                    math.randomseed(GetGameTimer())
                    local selAnim = math.random(1, #self.Anims)
                    while self.beforeAnim and self.beforeAnim == selAnim do
                         Wait(0)
                         math.randomseed(GetGameTimer())
                         selAnim = math.random(1, #self.Anims)
                    end
                    self.beforeAnim = selAnim
                    self:LoadAnim(self.Anims[selAnim].dict)
                    TaskPlayAnim(self.createdPeds[i].ped, self.Anims[selAnim].dict, self.Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
               else
                    local model = math.random(1, #self.DefaultModels)
                    if self.createdPeds[i] then SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) DeleteEntity(self.createdPeds[i].ped) end
                    self.createdPeds[i] = {}
                    RequestModel(self.DefaultModels[model])
                    while not HasModelLoaded(self.DefaultModels[model]) do
                         Wait(100)
                    end
                    self.createdPeds[i].ped = CreatePed(16, self.DefaultModels[model], self.PedSpawnLocs[i].x, self.PedSpawnLocs[i].y, self.PedSpawnLocs[i].z, self.PedSpawnLocs[i].w, 0, 1)
                    SetEntityAlpha(self.createdPeds[i].ped, 100)
                    math.randomseed(GetGameTimer())
                    local selAnim = math.random(1, #self.Anims)
                    while self.beforeAnim and self.beforeAnim == selAnim do
                         Wait(0)
                         math.randomseed(GetGameTimer())
                         selAnim = math.random(1, #self.Anims)
                    end
                    self.beforeAnim = selAnim
                    self:LoadAnim(self.Anims[selAnim].dict)
                    TaskPlayAnim(self.createdPeds[i].ped, self.Anims[selAnim].dict, self.Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
               end
          else
               local model = self.DefaultModels[math.random(1, #self.DefaultModels)]
               if self.createdPeds[i] then SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) DeleteEntity(self.createdPeds[i].ped) end
               self.createdPeds[i] = {}
               RequestModel(model)
               while not HasModelLoaded(model) do
                    Wait(100)
               end
               self.createdPeds[i].ped = CreatePed(16, model, self.PedSpawnLocs[i].x, self.PedSpawnLocs[i].y, self.PedSpawnLocs[i].z, self.PedSpawnLocs[i].w, 0, 1)
               SetEntityAlpha(self.createdPeds[i].ped, 100)
               math.randomseed(GetGameTimer())
               local selAnim = math.random(1, #self.Anims)
               while self.beforeAnim and self.beforeAnim == selAnim do
                    Wait(0)
                    math.randomseed(GetGameTimer())
                    selAnim = math.random(1, #self.Anims)
               end
               self.beforeAnim = selAnim
               self:LoadAnim(self.Anims[selAnim].dict)
               TaskPlayAnim(self.createdPeds[i].ped, self.Anims[selAnim].dict, self.Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)
          end
     end
end

function MX:DelEntity()
     if next(self.createdPeds) then
          for i = 1, #self.createdPeds do
               SetEntityAsMissionEntity(self.createdPeds[i].ped, true, true) 
               DeleteEntity(self.createdPeds[i].ped) 
          end
     end
end

function MX:CharacterSelector()
     DisplayRadar(0)
     DoScreenFadeOut(300)
     SetEntityCoords(PlayerPedId(), self.InvisibleSpawn)
     ShutdownLoadingScreenNui()
     RequestCollisionAtCoord(self.InvisibleSpawn)
     while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
         SetEntityCoords(PlayerPedId(), self.InvisibleSpawn)
         RequestCollisionAtCoord(self.InvisibleSpawn)
         Wait(0)
     end
     SetEntityVisible(PlayerPedId(), false)
     FreezeEntityPosition(PlayerPedId(), true)
     Citizen.Wait(3500)
     self:Cam(true)
     self:TSE('mx-multicharacter:GetCharacters')
     Wait(700)
     SetEntityCoords(PlayerPedId(), self.InvisibleSpawn)
     SetEntityVisible(PlayerPedId(), false)
     DoScreenFadeIn(300)
end

AddEventHandler('mx-multicharacter:RefreshCharacters', function () MX:TSE('mx-multicharacter:GetCharacters') end)

AddEventHandler('mx-multicharacter:SetCitizenId', function (cid) MX.CitizenId = cid end)

AddEventHandler('mx-multicharacter:GetCharacters', function (data, slots)
     MX:CreatePeds(data)
     SendNUIMessage({
          type = 'SetupCharacters',
          handler = data,
          slots = slots,
          useVIP = MX.UseVIP
     })
     SetNuiFocus(true, true)
end)

AddEventHandler('mx-multicharacter:notification', function (msg) MX:Notification(msg) end)

RegisterNUICallback('DeleteCharacter', function (data) MX:TSE('mx-multicharacter:DeleteCharacter', data.citizenid) end)

RegisterNUICallback('CreateCharacter', function (data)
     SetEntityCoords(PlayerPedId(), MX.GeneralSpawn)
     SetEntityInvincible(PlayerPedId(), false)
     SetEntityVisible(PlayerPedId(), true)
     FreezeEntityPosition(PlayerPedId(), false)
     MX:Cam(false)
     SetNuiFocus(false, false)
     TriggerServerEvent('mx-multicharacter:CreateCharacter')
     while not MX.CitizenId do
          print('Waiting...')
          Wait(100)
     end
     Wait(500)
     MX.NewCharacterData = {
          firstname = data.firstname,
          lastname = data.lastname,
          sex = data.sex,
          dateofbirth = data.date,
          queue = data.queue
     }
     MX:DelEntity()
     DisplayRadar(1)
     TriggerServerEvent('esx:onPlayerJoined', MX.CitizenId, MX.NewCharacterData)
end)

RegisterNUICallback('PlayCharacter', function (data)
     MX:Cam(false)
     SetNuiFocus(false, false)
     TriggerServerEvent('mx-multicharacter:CreateCharacter', data.data)
     TriggerEvent('mx-spawn:Open', data.data)
     MX:DelEntity()
     DisplayRadar(1)
end)

RegisterNUICallback('SelectCharacter', function (data)
     if next(MX.createdPeds) then
          for _,v in pairs(MX.createdPeds) do
               if v.queue == data.queue then
                    if v.ped ~= MX.currentCharacter then
                         SetEntityAlpha(v.ped, 255)
                         if MX.currentCharacter then
                              SetEntityAlpha(MX.currentCharacter, 200)
                         end
                         MX.currentCharacter = v.ped
                    end
                    break
               end
          end
     end
end)

exports('GetCid', function ()
     return MX.CitizenId
end)

exports('GetMulti', function ()
     return MX.NewCharacterData
end)

exports('SetMulti', function ()
     MX.NewCharacterData = false
end)