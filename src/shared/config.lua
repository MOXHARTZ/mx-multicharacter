MX = {
     -- Core 
     players = {},
     CreatedCharacters = {},
     DefaultModels = {`mp_m_freemode_01`, `mp_f_freemode_01`},
     createdPeds = {},
     currentCharacter = false,
     CitizenId = false,
     beforeAnim = false,
     NewCharacterData = false,

     -- Config
     DeleteTables = {
          {
               table = 'addon_account_data',
               owner = 'owner'
          },
          {
               table = 'datastore_data',
               owner = 'owner'
          },
          {
               table = 'users',
               owner = 'citizenid'
          }
     },
     Identifier = 'license', 
     Anims = {
          {
               dict = 'anim@amb@nightclub@peds@',
               name = 'rcmme_amanda1_stand_loop_cop'
          },
          {
               dict = 'mp_player_int_uppergang_sign_a',
               name = 'mp_player_int_gang_sign_a'
          },
          {
               dict = 'amb@world_human_leaning@male@wall@back@foot_up@idle_a',
               name = 'idle_a'
          },
          {
               dict = 'amb@world_human_stupor@male@idle_a',
               name = 'idle_a'
          },
          {
               dict = 'anim@mp_player_intupperslow_clap',
               name = 'idle_a'
          },
          {
               dict = 'rcmbarry',
               name = 'base'
          },
          {
               dict = 'anim@mp_player_intupperthumbs_up',
               name = 'idle_a'
          },
          {
               dict = 'rcmnigel1a',
               name = 'base'
          },
     },
     essentialmode = false, 
     GeneralSpawn = vec3(-1049.942, -2724.759, 20.169294),
     InvisibleSpawn = vec3(1170.10, -1264.40, 70.75),
     UseVIP = true, -- true or false
     PedSpawnLocs = {
          [1] = vec4(1133.10, -1264.40, 20.75, 44.13),
          [2] = vec4(1130.40, -1265.90, 20.65, 44.13),
          [3] = vec4(1128.60, -1268.20, 20.52, 40.24),
          [4] = vec4(1125.94, -1270.38, 20.41, 0.99)
     },
}

-- sağa doğru gidersen x azalır y artar
