# Roshpit-Champions-Hero-RPG
Online Action RPG - Dota 2 Mod
----------------------------

need to make folders: 
C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota_addons\roshpit_champions
AND
C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\content\dota_addons\roshpit_champions

create folder anywhere on computer called Roshpit Champions Root. In this folder create a folder called Game and another folder called Content

in command line, change directory to your Roshpit Champions Root folder and type the following commands:
_________________________________________
mklink /j "Game" "C:\Program Files\Steam\steamapps\common\dota 2 beta\game\dota_addons\roshpit_champions"

mklink /j "Content" "C:\Program Files\Steam\steamapps\common\dota 2 beta\content\dota_addons\roshpit_champions"

git init

git clone Roshpit-Champions-Hero-RPG

_________________________________________

now create your branch (git checkout my-unique-branch). You can start working on your updates from this branch. When your branch is ready to be merged with master, create a pull request using this branch and ChalkyBrush will approve it

you will want to unpack the Roshpit Champions VPK downloaded from Dota and put all contents into "C:\Program Files\Steam\steamapps\common\dota 2 beta\game\dota_addons\roshpit_champions"
