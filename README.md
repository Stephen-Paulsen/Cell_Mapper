# Cell_Mapper
This is a test fork of:

*Is this cell taken - project zomboid map mod
https://github.com/RakibRyan/is_this_cell_taken__project_zomboid_map_mod*

I will merge it with this other repository when I learn how to do it properly

---
*The original idea and code was made by 
**Rakib Ryan**!*
---


This godot tool:

- Reads your Project Zomboid Workshop folder 

*(You need to place your "108600" folder inside the godot "project_zomboid_workshop_folder" folder!!!)*

- Searches for any mod with map cells
- Saves the map names and the cells used
- Loads and shows them over the default map

*(Look into the map_mods_data_loader() function inside the Cell_Searcher.gd script to enable a test dictionnary with some map data if you don't feel like using your own "108600" folder)*

For best results I recommend doing a steam collection with all of your mods and another with just your map mods since godot will need to import all the files before using them which can take **FOREVER** or just crash lol