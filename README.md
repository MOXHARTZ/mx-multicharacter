# Multicharacter

# Image:
<img border="0" src="https://i.ibb.co/ns32sPR/Screenshot-1.png" />
<a href="https://ibb.co/mvr7vYw"><img src="https://i.ibb.co/Q87G8qR/Screenshot-3.png" alt="Screenshot-3" border="0"></a>

# VIDEO: 
https://youtu.be/V87r0_HAujE

## Features
- Citizenid system.
- You can see your character.
- Slots can be unlocked vip players or everyone.
- Cinematic intro

## Requirements
- mx-spawn (https://github.com/MOXHAFOREVA/mx-spawn)

# How To Install

- Open your `server.cfg` and add `ensure mx-multicharacter` `ensure mx-spawn`

# If you are using extendedmode or es_extended v.1.2

- change `mx-multicharacter` > `src` > `shared` > `config.lua` > `Identifier = 'steam'`

| SCRIPT | CHANGE |
| ------ | ------ |
| esx_identity | Remove |
| es_extended V1-final | https://github.com/MOXHAFOREVA/es_extended/commit/6632578be693e6ef59cd346ad0e2dd19e352bc50 |
| es_extended [EXTENDEDMODE] | https://github.com/MOXHAFOREVA/extendedmode/commit/2b9af6ead1ef387f166ee62afd027573ca86d58d |
| esx_skin | https://github.com/MOXHAFOREVA/esx_skin/commit/08839900e382ff9942e9899e9a0efa161aaf1e7d |
| skinchanger | https://github.com/MOXHAFOREVA/skinchanger/commit/4a628132a23697beddcffb6821aa7b645fb293c7 |

# MySQL 
Open `mysql.sql`

Remove the key of the identifier column from the users table.
Add key from users table to citizenid column.

<img border="0" src="https://i.ibb.co/VvfwmHB/2Bfma.png" />

<img border="0" src="https://i.ibb.co/dfQScnq/image.png"/>



