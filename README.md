# Roshpit-Champions-Hero-RPG
## Online Action RPG - Dota 2 Mod

### Preparation
Yon need to make folders: 
`C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota_addons\roshpit_champions`
and
`C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\content\dota_addons\roshpit_champions`

Create a folder anywhere on a computer called `Roshpit Champions Root`.

In command line, change directory to your `Roshpit Champions Root` folder and type the following commands:

`mklink /j "Game" "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota_addons\roshpit_champions"`

`mklink /j "Content" "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\content\dota_addons\roshpit_champions"`

```
git init
git remote add origin https://github.com/ChalkyBrush/Roshpit-Champions-Hero-RPG
git pull origin master
```

_________________________________________

### Do not forget to branch
Create your branch (git checkout my-unique-branch). You can start working on your updates from this branch. When your branch is ready to be merged with master, create a pull request using this branch and ChalkyBrush will approve it.

You will want to unpack the Roshpit Champions VPK downloaded from Dota and put all contents into `"C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota_addons\roshpit_champions"`

_________________________________________

### Updating ability, item or unit definitions

Do not use npc_abilties_custom or npc_units_custom or npc_items_custom. Instead, use the templates found in the root directory.
Go to your root directory in command line and type py roshpit_npc_builder.py to run the builder. Whenever you save a change to the template, it updates your npc_abilities_custom file.

please add the following line to your gitignore: game/scripts/npc

