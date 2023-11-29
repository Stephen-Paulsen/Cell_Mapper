extends Node2D

var save_path = "user://mapcells.save"
var mod_maps_data_dictionary = {}

func _ready():
	folder_analyzer("res://project_zomboid_workshop_folder")


func _process(_delta):
	pass


func folder_analyzer(path):
	var directory = DirAccess.open(path)
	if directory:
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		if file_name == "108600":
			if directory.current_is_dir():
				print("Found the Project Zomboid Workshop folder: " + file_name)
				var next_path = path + "/" + file_name
				map_mod_folder_checker(next_path)
				map_mods_data_saver(mod_maps_data_dictionary)
			else:
				print("Project Zomboid Workshop was not found!")
		else:
			print("Project Zomboid Workshop was not found!")

		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func map_mod_folder_checker(path):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		if file_name != "":
			while file_name != "":
				if directory.current_is_dir():
					#print("Found a mod folder: " + file_name)
					var next_path = path + "/" + file_name
					inner_mod_folder_finder(next_path)
					#break
				file_name = directory.get_next()
		else:
			print("Workshop mod folder was not found!")
		
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access your workshop mods!")


func inner_mod_folder_finder(path):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		if file_name == "mods":
			if directory.current_is_dir():
				#print("Found a mod's deeper mods directory: " + file_name)
				var next_path = path + "/" + file_name
				mod_name_folder_finder(next_path)
			else:
				print("The mod's inner mods folder was not found!")
		else:
			print("The mod's inner mods folder was not found!")
		
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func mod_name_folder_finder(path):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		if file_name != "":
			if directory.current_is_dir():
				#print("Found the mod's name folder: " + file_name)
				var next_path = path + "/" + file_name
				mod_media_folder_finder(next_path, file_name)
			else:
				print("The mod's name folder was not found!")
		else:
			print("The mod's name folder was not found!")
		
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func mod_media_folder_finder(path, mod_name):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		
		while file_name != "media":
			if file_name == "":
				break
			file_name = directory.get_next()
		
		if file_name == "media":
			if directory.current_is_dir():
				#print("Found the mod's media folder: " + file_name)
				var next_path = path + "/" + file_name
				mod_maps_folder_finder(next_path, mod_name)
			else:
				print("The mod's media folder was not found!")
		else:
			#print("The mod's media folder was not found!")
			pass
	
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func mod_maps_folder_finder(path, mod_name):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		
		while file_name != "maps":
			if file_name == "":
				break
			file_name = directory.get_next()
		
		if file_name == "maps":
			if directory.current_is_dir():
				#print("Found the mod's maps folder: " + file_name)
				var next_path = path + "/" + file_name
				mod_map_folders_checker(next_path, mod_name)
			else:
				print("The mod's maps folder was not found!")
		else:
			#print("This is not a map mod!")
			pass
	
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func mod_map_folders_checker(path, mod_name):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		
		while file_name != "":
			if directory.current_is_dir():
				#print("Found a map folder: " + file_name)
				var next_path = path + "/" + file_name
				if mod_map_folder_verifier(next_path):
					#print("Found the correct map folder: " + file_name)
					map_mod_files_checker(next_path, mod_name)
					break
				else:
					#print("The correct map folder is not this one!")'
					pass
			file_name = directory.get_next()
	
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func mod_map_folder_verifier(path):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		
		while file_name != "worldmap.xml":
			if  file_name == "":
				break
			file_name = directory.get_next()
		
		if file_name == "worldmap.xml":
			if !directory.current_is_dir():
				#print("Found the correct map folder!")
				directory.list_dir_end()
				return true
			else:
				#print("worldmap.xml is not here!")
				directory.list_dir_end()
				return false
		else:
			#print("worldmap.xml is not here!")
			directory.list_dir_end()
			return false
	else:
		print("An error occurred when trying to access this directory!")
		return false


func map_mod_files_checker(path, mod_name):
	var directory = DirAccess.open(path)
	if directory:
		#print("Entering directory: " + path)
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		while file_name != "":
			if directory.current_is_dir():
				#print("Found a folder: " + file_name)
				pass
			else:
				if map_mod_files_verifier(file_name):
					#print("Found file: " + file_name)
					#print("Found searched map file!")
					map_mods_data_organizer(mod_name,  map_mod_data_extracter(file_name))
					pass
				else:
					#print("Found file: " + file_name)
					#print("Not this one!")
					pass
				
			file_name = directory.get_next()
		
		directory.list_dir_end()
	else:
		print("An error occurred when trying to access this directory!")


func map_mod_files_verifier(file_name):
	var pattern = "[0-9]{2}_[0-9]{2}.lotheader$"
	var regex = RegEx.new()

	if regex.compile(pattern) == OK:
		if regex.search(file_name) != null:
			return true
		else:
			return false


func map_mod_data_extracter(file_name):
	var parts = file_name.split("_")

	if parts.size() == 2:
		var number1 = parts[0].to_int()
		var number2 = parts[1].to_int()

		if number1 != null and number2 != null:
			var numbers = [number1, number2]
			#print(numbers)
			return numbers
			
	return null

func map_mods_data_organizer(mod_name, data):
	var map_name = mod_name
	var map_cell = data

	# Check if the map name is already a key in the dictionary
	if not mod_maps_data_dictionary.has(map_name):
		# If not, create a new list for the map name
		mod_maps_data_dictionary[map_name] = []
		
	# Append the map cell to the list for the map name
	mod_maps_data_dictionary[map_name].append(map_cell)

func map_mods_data_saver(dictionary):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(dictionary, "\t"))
	file.close()

func map_mods_data_loader():
	var test_dictionnary = null
	#USE THIS TO TEST THE PROJECT WITHOUT HAVING TO LOAD YOUR WORKSHOP MODS! :D
	#test_dictionnary = { "AddamsMansion": [[37, 31]], "Ashenwoodmod": [[38, 37], [38, 38]], "BBL": [[16, 23], [16, 24], [16, 25], [16, 26], [17, 23], [17, 24], [17, 25], [17, 26], [18, 23], [18, 24], [18, 25], [18, 26], [19, 23], [19, 24], [19, 25], [19, 26], [20, 23], [20, 24], [20, 25], [20, 26], [21, 23], [21, 24], [21, 25], [21, 26], [22, 23], [22, 24], [22, 25], [22, 26]], "Bedford Falls": [[42, 36], [42, 37], [43, 33], [43, 34], [43, 35], [43, 36], [43, 37], [44, 33], [44, 34], [44, 35], [44, 36], [44, 37], [45, 25], [45, 26], [45, 27], [45, 28], [45, 29], [45, 30], [45, 31], [45, 32], [45, 33], [45, 34], [45, 35], [45, 36], [45, 37], [45, 38], [45, 39], [45, 40], [45, 41], [45, 42], [45, 43], [46, 25], [46, 26], [46, 27], [46, 28], [46, 29], [46, 30], [46, 31], [46, 32], [46, 33], [46, 34], [46, 35], [46, 36], [46, 37], [46, 38], [46, 39], [46, 40], [46, 41], [46, 42], [46, 43], [47, 25], [47, 26], [47, 27], [47, 28], [47, 29], [47, 30], [47, 31], [47, 32], [47, 33], [47, 34], [47, 35], [47, 36], [47, 37], [47, 38], [47, 39], [47, 40], [47, 41], [47, 42], [47, 43]], "Blackwood": [[26, 35]], "Breakpoint": [[42, 16]], "C.O.N. Research & Testing Facility": [[31, 42]], "Cedar Hill": [[16, 19]], "Chernaville": [[32, 34], [32, 35]], "Chestown": [[15, 22]], "Chinatown Expansion, KY": [[36, 28], [36, 29]], "Chinatown, KY": [[37, 29], [37, 30]], "CorOTRroad": [[35, 19], [35, 20], [36, 19], [36, 20]], "Dead in Hong Kong": [[44, 20], [44, 21], [45, 20], [45, 21]], "East Town of Riverside": [[23, 17], [23, 18]], "EdsAutoSalvage": [[29, 28]], "Elysium_Island": [[35, 21], [35, 22]], "Fort Knox linked to Eerie Country": [[41, 44], [41, 45], [41, 46], [41, 47], [41, 48], [41, 49], [41, 50], [41, 51], [41, 52], [41, 53], [41, 54], [41, 55], [41, 56], [41, 57], [41, 58], [41, 59], [42, 44], [42, 45], [42, 46], [42, 47], [42, 48], [42, 49], [42, 50], [42, 51], [42, 52], [42, 53], [42, 54], [42, 55], [42, 56], [42, 57], [42, 58], [42, 59], [43, 44], [43, 45], [43, 46], [43, 47], [43, 48], [43, 49], [43, 50], [43, 51], [43, 52], [43, 53], [43, 54], [43, 55], [43, 56], [43, 57], [43, 58], [43, 59], [44, 44], [44, 45], [44, 46], [44, 47], [44, 48], [44, 49], [44, 50], [44, 51], [44, 52], [44, 53], [44, 54], [44, 55], [44, 56], [44, 57], [44, 58], [44, 59], [45, 44], [45, 45], [45, 46], [45, 47], [45, 48], [45, 49], [45, 50], [45, 51], [45, 52], [45, 53], [45, 54], [45, 55], [45, 56], [45, 57], [45, 58], [45, 59], [46, 44], [46, 45], [46, 46], [46, 47], [46, 48], [46, 49], [46, 50], [46, 51], [46, 52], [46, 53], [46, 54], [46, 55], [46, 56], [46, 57], [46, 58], [46, 59], [47, 44], [47, 45], [47, 46], [47, 47], [47, 48], [47, 49], [47, 50], [47, 51], [47, 52], [47, 53], [47, 54], [47, 55], [47, 56], [47, 57], [47, 58], [47, 59], [48, 44], [48, 45], [48, 46], [48, 47], [48, 48], [48, 49], [48, 50], [48, 51], [48, 52], [48, 53], [48, 54], [48, 55], [48, 56], [48, 57], [48, 58], [48, 59], [49, 44], [49, 45], [49, 46], [49, 47], [49, 48], [49, 49], [49, 50], [49, 51], [49, 52], [49, 53], [49, 54], [49, 55], [49, 56], [49, 57], [49, 58], [49, 59], [50, 44], [50, 45], [50, 46], [50, 47], [50, 48], [50, 49], [50, 50], [50, 51], [50, 52], [50, 53], [50, 54], [50, 55], [50, 56], [50, 57], [50, 58], [50, 59], [51, 44], [51, 45], [51, 46], [51, 47], [51, 48], [51, 49], [51, 50], [51, 51], [51, 52], [51, 53], [51, 54], [51, 55], [51, 56], [51, 57], [51, 58], [51, 59], [52, 44], [52, 45], [52, 46], [52, 47], [52, 48], [52, 49], [52, 50], [52, 51], [52, 52], [52, 53], [52, 54], [52, 55], [52, 56], [52, 57], [52, 58], [52, 59]], "Fort Rock Ridge": [[22, 20], [22, 21], [23, 20], [23, 21]], "FortRedstone": [[18, 37], [18, 38], [18, 39], [18, 40], [19, 37], [19, 38], [19, 39], [19, 40]], "Grapeseed": [[24, 37]], "Greenleaf": [[21, 34], [21, 35], [22, 34], [22, 35]], "Greenport": [[27, 24], [27, 25], [28, 24], [28, 25]], "Heavens Hill": [[25, 26]], "Hilltop": [[10, 19]], "Homepie": [[29, 26], [29, 27], [30, 26], [30, 27]], "Hopefalls": [[32, 22]], "Hopewell, KY (Original)": [[49, 10], [49, 11]], "KingsmouthKY": [[10, 14], [10, 15], [10, 16], [10, 17], [11, 14], [11, 15], [11, 16], [11, 17], [12, 14], [12, 15], [12, 16], [12, 17], [13, 14], [13, 15], [13, 16], [13, 17]], "Lalafell\'s Heart Lake Town": [[33, 35]], "Lande Desolate Camping": [[34, 35]], "LittleTownship": [[27, 28]], "LoneRangersHideaway": [[20, 36]], "March Ridge Expansion": [[32, 42]], "McCoysBunker": [[44, 14]], "Military Fuel Depot": [[34, 43], [34, 44], [35, 43], [35, 44]], "Modriversidemansion": [[18, 17]], "Monmouth County": [[39, 26], [39, 27], [39, 28], [39, 29], [40, 26], [40, 27], [40, 28], [40, 29], [41, 26], [41, 27], [41, 28], [41, 29], [42, 26], [42, 27], [42, 28], [42, 29]], "Muldraugh Fire Department": [[35, 35]], "Muldraugh-Westoutskirts ShippingCo": [[32, 32]], "Nettle Township": [[22, 30], [22, 31], [23, 30], [23, 31]], "NewEkron": [[23, 27], [23, 28], [24, 27], [24, 28]], "Otr": [[37, 10], [37, 11], [37, 12], [37, 13], [37, 14], [37, 15], [37, 16], [37, 17], [37, 18], [37, 19], [37, 20], [37, 21], [38, 10], [38, 11], [38, 12], [38, 13], [38, 14], [38, 15], [38, 16], [38, 17], [38, 18], [38, 19], [38, 20], [38, 21], [39, 10], [39, 11], [39, 12], [39, 13], [39, 14], [39, 15], [39, 16], [39, 17], [39, 18], [39, 19], [39, 20], [39, 21], [40, 10], [40, 13], [40, 14], [40, 15], [40, 16], [40, 17], [40, 18], [40, 19]], "Over the River - Secondary Route": [[40, 20], [41, 20]], "OverlookMapJam": [[15, 21]], "ParkingLot": [[29, 29], [30, 29]], "Petroville": [[35, 39], [35, 40], [35, 41], [36, 39], [36, 40], [36, 41], [37, 39], [37, 40], [37, 41]], "PrisonTWD": [[32, 31]], "RabbitHashKY": [[30, 24], [31, 24]], "Ranger\'s Homestead": [[32, 33]], "RavenCreek": [[10, 37], [10, 38], [10, 39], [10, 40], [10, 41], [10, 42], [10, 43], [10, 44], [11, 37], [11, 38], [11, 39], [11, 40], [11, 41], [11, 42], [11, 43], [11, 44], [12, 37], [12, 38], [12, 39], [12, 40], [12, 41], [12, 42], [12, 43], [12, 44], [13, 37], [13, 38], [13, 39], [13, 40], [13, 41], [13, 42], [13, 43], [13, 44], [14, 37], [14, 38], [14, 39], [14, 40], [14, 41], [14, 42], [14, 43], [14, 44], [15, 37], [15, 38], [15, 39], [15, 40], [15, 41], [15, 42], [15, 43], [15, 44], [16, 37], [16, 38], [16, 39], [16, 40], [16, 41], [16, 42], [16, 43], [16, 44], [17, 37], [17, 38], [17, 39], [17, 40], [17, 41], [17, 42], [17, 43], [17, 44]], "ResearchBase": [[18, 41], [18, 42], [19, 41], [19, 42]], "Reststop Louisville": [[41, 15]], "Road from Fort Knox to Bedford Falls": [[45, 38], [45, 39], [45, 40], [45, 41], [45, 42], [45, 43]], "Road from Monmouth County to Bedford Falls": [[43, 27], [44, 27]], "RosewoodVHSGunStores": [[27, 40]], "Speck": [[30, 41]], "SpencerMansionLootable": [[21, 19]], "Springwood": [[34, 26], [34, 27]], "St Paulos Hammer": [[12, 30], [12, 31], [12, 32], [12, 33], [12, 34], [12, 35], [13, 30], [13, 31], [13, 32], [13, 33], [13, 34], [13, 35], [14, 30], [14, 31], [14, 32], [14, 33], [14, 34], [15, 30], [15, 31], [15, 32], [15, 33], [15, 34], [16, 30]], "SuperGigaMart": [[12, 21]], "TeraMartEast": [[36, 37]], "TheMallSouthMuldraughFIXED": [[37, 37]], "The_Museum": [[35, 27]], "TrimbleCountyPowerStation": [[50, 10], [50, 11], [50, 12], [50, 13], [51, 10], [51, 11], [51, 12], [51, 13], [52, 10], [52, 11], [52, 12], [52, 13], [53, 10], [53, 11], [53, 12], [53, 13], [54, 10], [54, 11], [54, 12], [54, 13], [55, 10], [55, 11], [55, 12], [55, 13], [56, 10], [56, 11], [56, 12], [56, 13], [57, 10], [57, 11], [57, 12], [57, 13], [58, 10], [58, 11], [58, 12], [58, 13], [59, 10], [59, 11], [59, 12], [59, 13], [60, 10], [60, 11], [60, 12], [60, 13], [61, 10], [61, 11], [61, 12], [61, 13], [62, 10], [62, 11], [62, 12], [62, 13]], "Uncle Red\'s Bunker (legacy)": [[36, 36]], "Utopia": [[24, 32]], "Wellsburg Lake": [[25, 34]], "WestPointGatedCommunity": [[39, 22]], "WestPointTrailerParkAndVhsStore": [[38, 24]], "Winchester, KY": [[10, 22], [10, 23], [10, 24], [10, 25], [10, 26], [10, 27], [10, 28], [11, 22], [11, 23], [11, 24], [11, 25], [11, 26], [11, 27], [11, 28], [12, 22], [12, 23], [12, 24], [12, 25], [12, 26], [12, 27], [12, 28], [13, 22], [13, 23], [13, 24], [13, 25], [13, 26], [13, 27], [13, 28]], "coryerdon": [[24, 19], [25, 19], [26, 19], [26, 20], [26, 21], [26, 22], [27, 19], [27, 20], [27, 21], [27, 22], [28, 19], [28, 20], [28, 21], [28, 22], [28, 23], [29, 19], [29, 20], [29, 21], [29, 22], [29, 23], [30, 19], [30, 20], [30, 21], [31, 19], [31, 20], [31, 21], [32, 19], [32, 20], [32, 21], [33, 19], [33, 20], [33, 21], [34, 19], [34, 20], [34, 21], [34, 22]], "li_township": [[29, 32], [29, 33], [29, 34], [30, 32], [30, 33], [30, 34], [31, 32], [31, 33], [31, 34]], "orchid": [[27, 32], [27, 33], [28, 32], [28, 33]], "pz_rosewoodexp_map": [[27, 36], [27, 37], [28, 36], [28, 37]], "rosewoodcabins": [[24, 38], [25, 38]] }
	
	if test_dictionnary == null:
		if FileAccess.file_exists(save_path):
			var file = FileAccess.open(save_path, FileAccess.READ)
			var saved_dictionary = JSON.parse_string(file.get_as_text())
			#print(type_string(typeof(saved_dictionary)))
			#print(saved_dictionary)
			file.close()
			formatDictionary(saved_dictionary)
			return saved_dictionary
	else:
		formatDictionary(test_dictionnary)
		#map_mods_data_saver(test_dictionnary)
		return test_dictionnary

func formatDictionary(dictionary):
	for map_name in dictionary:
		print(map_name, ":")
		for map_cell in dictionary[map_name]:
			print("\t[", map_cell[0], ", ", map_cell[1], "]")
