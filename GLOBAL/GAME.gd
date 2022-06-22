extends Node
func is_class(value: String): return value == "GAME" or .is_class(value)
func get_class() -> String: return "GAME"

## SIGNALS

signal element_unlocked(element)

## VARS

var CAMERA_ENABLED : bool = true
var CURSOR_IN_SELECT : bool = false

const DEBUG : bool = true

const DISABLED_ELEMENT_COLOR : Color = Color(0.3, 0.3, 0.3, 1.0)
const ENABLED_ELEMENT_COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)

var game_paused : bool = false
var sceneclass_opening_journal : String = ""
const TITLESCREEN = "res://SCENES/Menu/TitleScreen/TitleScreen.tscn"
const JOURNAL = "res://SCENES/Menu/JournalDecouverte/JournalDecouverte.tscn"
const LEVEL = "res://SCENES/Level/Level.tscn"
const PAUSESCREEN = "res://SCENES/PauseScreen/PauseScene.tscn"

const DARKMATTER_SCENE : PackedScene = preload("res://SCENES/Elements/DarkMatter/DarkMatter.tscn")
const COSMICDUST_SCENE : PackedScene = preload("res://SCENES/Elements/CosmicDust/CosmicDust.tscn")
const METEROIDS_SCENE : PackedScene = preload("res://SCENES/Elements/Meteroid/Meteroid.tscn")
const PLANET_SCENE : PackedScene = preload("res://SCENES/Elements/Planet/Planet.tscn")
const STAR_SCENE : PackedScene = preload("res://SCENES/Elements/Star/Star.tscn")
const BLACKHOLE_SCENE : PackedScene = preload("res://SCENES/Elements/BlackHole/BlackHole.tscn")
const GALAXY_SCENE : PackedScene = preload("res://SCENES/Elements/Galaxy/Galaxy.tscn")

const ELEMENT_BUTTON_SCENE : PackedScene = preload("res://SCENES/HUD/ElementButton/ElementButton.tscn")
const ELEMENT_PLACEHOLDER_SCENE : PackedScene = preload("res://SCENES/HUD/ElementButton/Placeholder/ElementPlaceholder.tscn")

const ARRAY_BLACKHOLE_EXPLODE : Array = [DARKMATTER_SCENE, COSMICDUST_SCENE, METEROIDS_SCENE]

var unlocked : Array = [true, false, false, false, false, false, false]
const detailed_description = " Pour une description détaillé, merci de se référer au journal des découvertes."
const ELEMENTS = {
	0:{
		"id": 0,
		"name": "DarkMatter",
		"fr_name": "Matière Noire",
		"scene": DARKMATTER_SCENE,
		"sdescr": "Catégorie de matière encore non observé. Son existance est estimé car les galaxies ne se comporteraient pas, n'existeraient pas de la même manière qu'aujourd'hui sans cette matière. Elle représente 85% de la matière dans l'univers observable." + detailed_description,
		"ldescr": "La matière noire est une catégorie de matière permettant, grossièrement, l'estimation de la masse des galaxies ou d'amas de galaxies. Elle constitue 85% de la matière dans l'univers observable. Sa particularité est de ne ni absorber, affecter ou emettre des radiations éléctromagnétiques comme le fait la lumière par exemple. Tandi que aucune matière noire n'a été observé, l'existance de cette matière est assumé par son utilisé. S'il n'y avait pas de matière noire, les galaxies ne se seraient pas comportées ou n'existeraient peut être pas de la même manière qu'aujourd'hui.",
		"merge": "Aucune recette disponible pour fabriquer cet élément"
	},
	1:{
		"id": 1,
		"name": "CosmicDust",
		"fr_name": "Poussière cosmique",
		"scene": COSMICDUST_SCENE,
		"sdescr": "Poussière présente dans l'espace ou tombée sur la terre, elles jouent un rôle dans la formation d'étoiles et de planètes." + detailed_description,
		"ldescr": "Poussière présente dans l'espace. Composé de grains infiniment petit (millionième de mètre), ainsi que de cristaux. Il est estimé qu'environ 40 000 tonnes de poussières cosmiques y est déposé sur terre, par année. La poussière cosmique joue un rôle important dans le processus de formation d'étoiles et de planètes. ",
		"merge": "Recette : 2 MATIERES NOIRE"
	},
	2:{
		"id": 2,
		"name": "Meteroid",
		"fr_name": "Météoroïde",
		"scene": METEROIDS_SCENE,
		"sdescr": "Petit corps du système solaire rocheuses ou métallique. Certains de ces corps sont des débris causés par des choque des corps ejectés par la Lune ou Mars, et d'autre sont des fragments de comètes ou d'astéroïdes." + detailed_description,
		"ldescr": "Les Météroïdes sont des petit corps du système solaire. Elles sont rocheuses ou métallique. Ces objets spatiaux sont plus petit que des astéroïdes et les objets plus petits que ceux-ci sont considérés comme des Micrométéroïdes ou poussière cosmiques. La plupart de ces objets sont des fragments de comètes ou d'astéroïdes. D'autres peuvent aussi être des débris causés par une collision de corps ejectés par la lune ou par Mars.",
		"merge": "Recette : 2 POUSSIERES COSMIQUE"
	},
	3:{
		"id": 3,
		"name": "Planet",
		"fr_name": "Planète",
		"scene": PLANET_SCENE,
		"sdescr": "Corps céleste orbitant autour d'une étoile (dans notre galaxie, le soleil)." + detailed_description,
		"ldescr": "Corps céleste orbitant autour d'une étoile (dans notre galaxie, le soleil), possédant une masse suffisante pour que sa gravité la maintienne en équilibre. On qualifie aussi ces objets comme des objets libres de masse planétaire. La définition officiele de Planète n'existe pas, c'est l'UNION ASTRONOMIQUE INTERNATIONALE datant de 2002, modifié en 2003 qui a donné cette définition.",
		"merge": "Recette : 2 METEOROIDES"
	},
	4:{
		"id": 4,
		"name": "Star",
		"fr_name": "Etoile",
		"scene": STAR_SCENE,
		"sdescr": "Corps céleste qui rayonne sa propre lumière par réactions de fusion nucléaire. Ex : Le soleil, ayant une masse de 2x10^30 kg." + detailed_description,
		"ldescr": "Corps céleste plasmatique qui rayonne sa propre lumière par réactions de fusion nucléaire, ou des corps qui ont été dans cet état à un stade de leur cycle de vie. Cela signifie qu'ils doivent posséder une masse minimale pour que les conditions de température et de pression permettent l'amorce et le maintien de ces réactions nucléaires. Le soleil, par exemple, sa masse est de l'ordre de 2x10^30 kg. Une masse, qui est assez courrante pour ce genre d'étoile.",
		"merge": "Recette : 2 PLANETES"
	},
	5:{
		"id": 5,
		"name": "BlackHole",
		"fr_name": "Trou Noir",
		"scene": BLACKHOLE_SCENE,
		"sdescr": "Objet céleste si compact que l'intensité de son champ gravitationnel empêche toute forme de matière ou de rayonnement de s'échapper." + detailed_description,
		"ldescr": "Un trou noir est un objet céleste si compact que l'intensité de son champ gravitationnel empêche toute forme de matière ou de rayonnement de s'en échapper. Ils ne peuvent ni émettre, ni diffuser la lumière et sont donc noirs. On dit alors en astronomie, qu'ils sont optimiquement invisible. Cependant, les trous noirs emettent une quantité importante de rayons X avant d'être 'absorbée'.",
		"merge": "Recette : 2 ETOILES"
	},
	6:{
		"id": 6,
		"name": "Galaxy",
		"fr_name": "Galaxie",
		"scene": GALAXY_SCENE,
		"sdescr": "Assemblage d'étoiles, de gaz, de poussières, de vide, et peut-être essentiellement de matière noire, contenant parfois un trou noir supermassif en son centre." + detailed_description,
		"ldescr": "Une galaxie est un assemblage d'étoiles, de gaz, de poussières, de vide et peut-être essentiellement de matière noire, contenant parfois un trou noir supermassif en son centre. Notre galaxie s'appelle la Voie Lactée, le système Solaire s'y trouve et compte quelques centaines de milliards d'étoiles. On peut estimer son extension a 80 000 années-lumières. D'après Gaia, du 25 Avril 2018, nous comptons 1 692 919 135 étoiles dans notre Galaxie, représentant moins d'1% de la totalité des étoiles dans notre galaxie.",
		"merge": "Cet élément n'est pas fabriquable, cependant, vous pouvez créer votre galaxie si vous finissez le jeu en créant la votre, grâce aux éléments spatiales du jeu (planètes, trou noirs, etc..)"
	}
}
const HINTS = {
	0:{
		"id": 0,
		"name": "Light-Year",
		"fr_name": "Années-Lumières",
		"hint": "1 Année-Lumière = 9 461 milliards de kilomètres ou 0,3 Parsec"
	}
}

var current_objective : int = 0
const journal_unlock_texts : Array = ["Check your journal to learn more about this element","Vous pouvez maintenant consulter votre journal de découverte pour en apprendre plus sur cet élément"]

var current_progress = "_CURRENT_PROGRESS"
var INTRO_CURRENT_PROGRESS : Array = [0]
var DARKMATTER_CURRENT_PROGRESS : Array = [0]
var COSMICDUST_CURRENT_PROGRESS : Array = [0]
var METEOROID_CURRENT_PROGRESS : Array = [0]
var PLANET_CURRENT_PROGRESS : Array = [0]
var STAR_CURRENT_PROGRESS : Array = [0]
var BLACKHOLE_CURRENT_PROGRESS : Array = [0]
var GALAXY_CURRENT_PROGRESS : Array = [0, 0, 0, 0, 0, 0]
var END_CURRENT_PROGRESS : Array = [1]

const target_progress = "_TARGET_PROGRESS"
const INTRO_TARGET_PROGRESS : Array = [2]
const DARKMATTER_TARGET_PROGRESS : Array = [1]
const COSMICDUST_TARGET_PROGRESS : Array = [1]
const METEOROID_TARGET_PROGRESS : Array = [1]
const PLANET_TARGET_PROGRESS : Array = [1]
const STAR_TARGET_PROGRESS : Array = [1]
const BLACKHOLE_TARGET_PROGRESS : Array = [1]
const GALAXY_TARGET_PROGRESS : Array = [17, 8, 6, 5, 1, 1]
const END_TARGET_PROGRESS : Array = [1]

signal current_progress_changed(objective, progress)
signal objective_completed(objective, next_objective)
signal progress_objective(objective_id)

var objectives_finished : Array = [false, false, false, false, false, false, false, false, false]

const OBJECTIVES = {
	0:{
		"id": 0,
		"key_name":"INTRO",
		"validation_key":"PLACE_DARKMATTER",
		
		"name":"Dark Matter Intro",
		"fr_name":"Introduction à la Matière Noire",
		
		"description":"Place a darkmatter in space",
		"fr_description":"Placez de la matière noire dans l'espace",
		
		"progress":"2",
		"finished":false,
		
		"success_descr":"Congratulations! You successfully placed your first element, a Dark Matter",
		"fr_success_descr":"Félicitations! Vous venez de placer votre premier élément avec succès, une Matière Noire"
	},
	1:{
		"id": 1,
		"key_name":"DARKMATTER",
		"validation_key":"MERGE_DARKMATTER",
		
		"name":"Merge Dark Matter",
		"fr_name":"Rassemblage de Matière Noire",
		
		"description":"Merge two dark matters together with drag and drop",
		"fr_description":"Rassemblez deux matières noire ensemble en les déplaçant l'un sur l'autre",
		
		"progress":"1",
		"finished":false,
		
		"success_descr":"Congratulations! You merged your first dark matters. You just got a Cosmic Dust. Try to merge more Dark Matter to be able to unlock the Cosmic Dust !",
		"fr_success_descr":"Félications! Vous avez rassemblez vos premières matières noire avec succès et vous avez obtenu une Poussière Cosmique. Essayez de rassembler plus de Matière Noire afin de débloquer cette Poussière Cosmique !"
	},
	2:{
		"id": 2,
		"key_name":"COSMICDUST",
		"validation_key":"MERGE_COSMICDUST",
		
		"name":"Unlock Cosmic Dust",
		"fr_name":"Déblocage de la Poussière Cosmique",
		
		"description":"Unlock Cosmic Dust by merging two Cosmic Dust together",
		"fr_description":"Débloquez la Poussière Cosmique en rassemblant deux poussières cosmique",
		
		"progress":"1",
		"finished":false,
		
		"success_descr":"Congratulations! You merged two Cosmic Dust and Unlocked this item. You have now access to placing them directly into the space! You have completed the tutorial. Follow the objectives to continue the game or play freely",
		"fr_success_descr":"Félications! Vous avez rassemblez deux Poussières Cosmiques et avez débloquer cet objet. Vous pouvez maintenant directement les placer dans l'espace! Vous avez compléter le tutoriel. Suivez le reste des objectifs afin de compléter le jeu ou jouez librement à votre manière"
	},
	3:{
		"id": 3,
		"key_name":"METEOROID",
		"validation_key":"MERGE_METEROID",
		
		"name":"Unlock Meteoroids",
		"fr_name":"Déblocage des Météoroïdes",
		
		"description":"Unlock Meteoroids by merging two Meteoroids",
		"fr_description":"Débloquez les Météoroïdes en rassemblant deux météoroïdes",
		
		"progress":"1",
		"finished":false,
		
		"success_descr":"Successfully unlocked Meteoroid !",
		"fr_success_descr":"Météoroïde débloqué avec succès !"
	},
	4:{
		"id": 4,
		"key_name":"PLANET",
		"validation_key":"MERGE_PLANET",
		
		"name":"Unlock Planet",
		"fr_name":"Déblocage d'une Planète",
		
		"description":"Unlock Planet by merging two Planets together",
		"fr_description":"Débloquez la Planète en rassemblant deux Planètes",
		
		"progress":"1",
		"finished":false,
		
		"success_descr":"Successfully unlocked Planet !",
		"fr_success_descr":"Planète débloquée avec succès !"
	},
	5:{
		"id": 5,
		"key_name":"STAR",
		"validation_key":"MERGE_STAR",
		
		"name":"Unlock Star",
		"fr_name":"Déblocage d'Etoile",
		
		"description":"Unlock Star by merging two Stars together",
		"fr_description":"Débloquez l'Etoile en rassemblant deux Etoiles",
		
		"progress":"1",
		"finished":false,
		
		"success_descr":"Successfully unlocked Star !",
		"fr_success_descr":"Etoile débloquée avec succès !"
	},
	6:{
		"id": 6,
		"key_name":"BLACKHOLE",
		"validation_key":"MERGE_BLACKHOLE",
		
		"name":"Unlock Black Hole",
		"fr_name":"Déblocage d'un Trou Noir",
		
		"description":"Unlock Black Hole by merging two Black Holes together",
		"fr_description":"Débloquez un Trou Noir en rassemblant deux Trous Noir",
		
		"progress":"1",
		"finished":false,
		
		"success_descr":"Sucessfully unlocked Black Hole !",
		"fr_success_descr":"Trou Noir débloqué avec succès !"
	},
	7:{
		"id": 7,
		"key_name":"GALAXY",
		"validation_key":"BUILD_GALAXY",
		
		"name":"Unlock Galaxy and Finish The Game",
		"fr_name":"Finir le jeu en débloquant la Galaxie",
		
		"description":"Unlock Galaxy by building your own. Place Black Holes, Stars, Planets and other element to build your own !",
		"fr_description":"Débloquez la Galaxie en construisant la votre. Placez des Trous Noirs, Etoiles, Planètes et autres éléments spatiales afin de la construire !",
		
		"progress":{
			"Trou Noir":"1",
			"Etoile":"1",
			"Planete":"5",
			"Meteoroide":"6",
			"Poussiere Cosmique":"8",
			"Matiere Noire":"17"
		},
		"finished":false,
		
		
		"success_descr":"Congratulation ! You just finished the game. Please make sure to check your journal so that you learn about Galaxies and Galactic Center !",
		"fr_success_descr":"Féliciations ! Vous avez fini le jeu. S'il vous plait, soyez sur de consulter votre journal de découverte afin d'en apprendre plus sur les Galaxies et les Cetntres Galactiques !"
	},
	8:{
		"id": 8,
		"key_name":"END",
		"validation_key":"END_GAME",
		
		"name":"Game Finished",
		"fr_name":"Jeu Terminé",
		
		"description":"You Successfully Finished The Game ! Thanks for playing and check your journal for more informations about every elements you discovered ! Also, you are now able to discover what is a Galactic Center is !",
		"fr_description":"Vous avez fini le jeu avec succès ! Merci d'avoir jouer au jeu. N'hésitez pas à consulter votre Journal de Découverte pour vous renseigner sur les différents éléments découvert au long de votre expérience ! De plus, vous pouvez maintenant découvrir ce qu'est le Centre Galactique !",
		
		"progress": "1",
		"finished": false,
		
		"sucess_descr":"",
		"fr_success_descr":""
	}
}

var objects_container_nodes : Array = []

#### ACCESSORS ####

## CAMERA ENABLED

func _set_camera_enabled(b: bool) -> void:
	CAMERA_ENABLED = b

func _is_camera_enabled() -> bool:
	if is_draggable_already_selected_in_group():
		CAMERA_ENABLED = false
	else:
		CAMERA_ENABLED = true
	
	if CURSOR_IN_SELECT:
		CAMERA_ENABLED = false
	
	return CAMERA_ENABLED

func _set_cursor_in_select(b: bool) -> void:
	CURSOR_IN_SELECT = b

## ELEMENTS

func get_elements () -> Dictionary:
	return ELEMENTS

func get_last_id() -> int:
	return ( ELEMENTS[ELEMENTS.size()-1].get("id") )

func get_element_scene_by_id(id: int) -> PackedScene:
	return ELEMENTS[id].get("scene") if ELEMENTS[id].get("scene") != null else null

func get_element_scene_by_name(name: String) -> PackedScene:
	var elem : Dictionary = {}
	
	for e in ELEMENTS:
		if ELEMENTS[e].get("name") == name:
			elem = ELEMENTS[e]
	
	return elem.get("scene") if elem != null else null

func get_element_name_by_id(id: int) -> String:
	if not id in ELEMENTS: return ""
	for e in ELEMENTS:
		if e == id:
			return ELEMENTS[e].get("name")
	
	return ""

func get_element_frname_by_id(id: int) -> String:
	if not id in ELEMENTS: return ""
	for e in ELEMENTS:
		if e == id:
			return ELEMENTS[e].get("fr_name")
	return ""

func get_element_sdescr_by_id(id : int) -> String:
	if not id in ELEMENTS: return ""
	for e in ELEMENTS:
		if e == id:
			return ELEMENTS[e].get("sdescr")
	return ""

func get_element_ldescr_by_id(id : int) -> String:
	if not id in ELEMENTS: return ""
	for e in ELEMENTS:
		if e == id:
			return ELEMENTS[e].get("ldescr")
	return ""

func get_draggables() -> Array:
	return get_tree().get_nodes_in_group("draggable")

func get_placeholders() -> Array:
	return get_tree().get_nodes_in_group("placeholders")

func unlock_element_by_id(id: int) -> void:
	if not id in ELEMENTS: return
	
	if is_element_unlocked_by_id(id):
		return
	else:
		unlocked[id] = true
		emit_signal("element_unlocked", ELEMENTS[id])

func is_element_unlocked_by_id(id: int) -> bool:
	if unlocked[id]:
		return true
	else:
		return false

func get_element_merge_by_id(id: int) -> String:
	if not id in ELEMENTS: return ""
	for e in ELEMENTS:
		if e == id:
			return ELEMENTS[e].get("merge")
	return ""

### HINTS

func get_hint_name_by_id(id: int) -> String:
	if not id in HINTS: return ""
	for h in HINTS:
		if h == id:
			return HINTS[h].get("name")
	return ""

func get_hint_frname_by_id(id: int) -> String:
	if not id in HINTS: return ""
	for h in HINTS:
		if h == id:
			return HINTS[h].get("frname")
	return ""

func get_hint_hint_by_id(id: int) -> String:
	if not id in HINTS: return ""
	for h in HINTS:
		if h == id:
			return HINTS[h].get("hint")
	return ""

## OBJECTIVES

func get_objective_by_id(id: int) -> Dictionary:
	return OBJECTIVES[id] if (id in OBJECTIVES and OBJECTIVES[id] is Dictionary) else {}

func update_current_objective(objective_id: int) -> void:
	current_objective = objective_id if objective_id in OBJECTIVES else 0
	if current_objective <= 0:
		push_error("Current objective has been updated to a value <= 0")
		return

#NAME
func get_objective_name_by_id(id: int) -> String:
	if not id in OBJECTIVES: return ""
	for o in OBJECTIVES:
		if o == id:
			return OBJECTIVES[o].get("name")
	return ""

#FRNAME
func get_objective_frname_by_id(id: int) -> String:
	if not id in OBJECTIVES: return ""
	for o in OBJECTIVES:
		if o == id:
			return OBJECTIVES[o].get("fr_name")
	return ""

#DESCR
func get_objective_descr_by_id(id: int) -> String:
	if not id in OBJECTIVES: return ""
	for o in OBJECTIVES:
		if o == id:
			return OBJECTIVES[o].get("description")
	return ""

#FRDESCR
func get_objective_frdescr_by_id(id: int) -> String:
	if not id in OBJECTIVES: return ""
	for o in OBJECTIVES:
		if o == id:
			return OBJECTIVES[o].get("fr_description")
	return ""

#SUCCESS DESCR
func get_objective_success_descr_by_id(id: int) -> String:
	if not id in OBJECTIVES: return ""
	for o in OBJECTIVES:
		if o == id:
			return OBJECTIVES[o].get("success_descr")
	return ""

#FR SUCCESS DESCR
func get_objective_fr_success_descr_by_id(id: int) -> String:
	if not id in OBJECTIVES: return ""
	for o in OBJECTIVES:
		if o == id:
			return OBJECTIVES[o].get("fr_success_descr")
	return ""

# OBJECTIVE FINISHED BY ID
func is_objective_finished_by_id(id: int) -> bool:
	if not id in OBJECTIVES: return false
	return objectives_finished[id]

# SET OBJECTIVE FINISHED BY ID
func finish_objective_by_id(id: int) -> void:
	if not id in OBJECTIVES: return
	if OBJECTIVES[id]["key_name"] == "END": return
	for o in OBJECTIVES:
		if o == id:
			OBJECTIVES[o]["finished"] = true
			objectives_finished[o] = OBJECTIVES[o].get("finished")
			
			var next_objective = OBJECTIVES[o + 1] if o < OBJECTIVES.size()-1 else null
			
			if next_objective == null:
				push_warning("Trying to unlock objective with id OUT OF BOUND")
				return
			
			emit_signal("objective_completed", OBJECTIVES[o], next_objective)
			
			if DEBUG:
				var on : String = get_objective_name_by_id(o)
				var oofinished : String = str(OBJECTIVES[o].get("finished"))
				var ofinisheda : String = str(objectives_finished[o])
				print( on + " has been finished ! Objectives[o]['finished']:  " + oofinished + " objectives_finished[o] : " + ofinisheda )
				
			return

# GET OBJECTIVE CURRENT PROGRESS
func get_objective_current_progress_by_id(id : int) -> Array:
	if not id in OBJECTIVES: return []
	for o in OBJECTIVES:
		if o == id:
			var kn = OBJECTIVES[o].get("key_name")
			var current_progress_array : Array = get(kn + current_progress)
			return current_progress_array
	return []

# SET OBJECTIVE CURRENT PROGRESS
func set_objective_current_progress_by_id(id: int, v) -> void:
	if not id in OBJECTIVES: return
	if v is int and v < 0: return
	
	if not v is Array:
		for o in OBJECTIVES:
			if o == id:
				var kn = OBJECTIVES[o].get("key_name")
				var kn_array = get(kn + current_progress)
				kn_array[0] = v
				
				emit_signal("current_progress_changed", o, kn_array) #o for element id, v for progress value in array
				
				return
	else:
		GALAXY_CURRENT_PROGRESS = v
		print(GALAXY_CURRENT_PROGRESS)
		print(GALAXY_TARGET_PROGRESS)
		emit_signal("current_progress_changed", id, GALAXY_CURRENT_PROGRESS)

# GET OBJECTIVE TARGET PROGRESS
func get_objective_target_progress_by_id(id: int) -> Array:
	if not id in OBJECTIVES: return []
	
	var okn : String = OBJECTIVES[id].get("key_name")
	var complete_target_progress : String = okn + target_progress
	
	return get(complete_target_progress) if get(complete_target_progress) is Array else []

# GET OBJECTIVE PROGRESS
func get_objective_progress_by_id(id: int) -> String:
	return OBJECTIVES[id].get("progress") if ( id in OBJECTIVES and OBJECTIVES[id].get("progress") is String ) else ""

func get_objective_progress_dictionary_by_id(id: int) -> Dictionary:
	return OBJECTIVES[id].get("progress") if ( id in OBJECTIVES and OBJECTIVES[id].get("progress") is Dictionary ) else {}

## PAUSED
func set_game_paused(b: bool) -> void:
	game_paused = b

#### BUILT-IN ####

func _ready() -> void:
	var __
	__ = connect("current_progress_changed", self, "_on_current_progress_changed")
	__ = connect("objective_completed", self, "_on_objective_completed")
	__ = connect("progress_objective", self, "_on_progress_objective")
	__ = connect("element_unlocked", self, "_on_element_unlocked")

func _unhandled_key_input(event: InputEventKey) -> void:
	if not DEBUG or not event.pressed or event.echo: return
	
	match( OS.get_scancode_string(event.get_physical_scancode_with_modifiers()).to_upper() ):
		"F1":
			force_spawn_element(0)
		"F2":
			force_spawn_element(1)
		"F3":
			force_spawn_element(2)
		"F4":
			force_spawn_element(3)
		"F5":
			force_spawn_element(4)
		"F6":
			force_spawn_element(5)
		"F7":
			force_spawn_element(6)
		"ALT+F1":
			print("unlocked everything")
			for i in range(unlocked.size()):
				unlock_element_by_id(i)
		"ALT+F2":
			if DEBUG:
				print("finished objective " + get_objective_frname_by_id(current_objective) + " with id " + str(current_objective))
			finish_objective_by_id(current_objective)
		_:
			return

#### VIRTUALS ####



#### LOGIC ####

func is_draggable_already_selected_in_group() -> bool:
	for draggable in get_draggables():
		if draggable.is_selected():
			return true
	return false

func force_spawn_element(element_id : int, position : Vector2 = Vector2.ZERO) -> void:
	if not element_id in get_elements(): return
	var el = get_element_scene_by_id(element_id).instance()
	el.set_global_position(get_tree().get_root().get_node("Level").get_global_mouse_position())
	el.connect("element_dropped", MergeHandler, "_on_element_dropped")
	el.connect("element_spawned", self, "_on_element_spawned")
	if not position == Vector2.ZERO:
		el.set_global_position(position)
	objects_container_nodes[element_id].call_deferred("add_child", el, true)
	yield(el, "ready")
	el.play_appear()

func spawn_random_element(origin_pos : Vector2 = Vector2.ZERO, count: int = -1, elements_array : Array = []) -> void:
	if origin_pos == Vector2.ZERO or count < 0 or elements_array.empty():
		return
		
	randomize()
	for e in elements_array:
		if not e is PackedScene:
			return
		else:
			for _i in range(randi() % count + 1):
				var e_i = e.instance()
				
				# range min range max
				var rx = randi() % 300 + 1
				var ry = randi() % 300 + 1
				
				
				var dx = rand_range(origin_pos.x - rx, origin_pos.x + rx)
				var dy = rand_range(origin_pos.y - ry, origin_pos.y + ry)
				var dv : Vector2 = Vector2(dx, dy)
				
				force_spawn_element(e_i.get_id(), dv)

#### INPUTS ####


func check_for_objective_validation(validation_key : String = "") -> void:
	if validation_key == OBJECTIVES[current_objective].get("validation_key"):
		if get_objective_current_progress_by_id(current_objective) == get_objective_target_progress_by_id(current_objective):
			finish_objective_by_id(current_objective)
		else:
			var a = get_objective_current_progress_by_id(current_objective)[0]
			set_objective_current_progress_by_id(current_objective, a + 1)

func check_for_galaxy_progress() -> void:
	var ea : Array = [0, 0, 0, 0, 0, 0]
	for c in objects_container_nodes:
		if c is Node:
			for e in c.get_children():
				if e is DarkMatter:
					ea[0] += 1
				elif e is CosmicDust:
					ea[1] += 1
				elif e is Meteroid:
					ea[2] += 1
				elif e is Planet:
					ea[3] += 1
				elif e is Star:
					ea[4] += 1
				elif e is BlackHole:
					ea[5] += 1
	set_objective_current_progress_by_id(current_objective, ea)

#### SIGNAL RESPONSES ####
func _on_element_spawned(element) -> void:
	if current_objective == 7: check_for_galaxy_progress()
	if is_objective_finished_by_id(element.get_id()) or not element.get_id() in OBJECTIVES: return
	
	match(element.get_class()):
		"DarkMatter":
			check_for_objective_validation("PLACE_DARKMATTER")
		"CosmicDust":
			check_for_objective_validation("MERGE_DARKMATTER")
		"Galaxy":
			check_for_objective_validation("BUILD_GALAXY")

func _on_element_unlocked(element) -> void:
	var eid : int = element.get("id")
	var fid : int = eid + 1
	var is_objective_finished : bool = is_objective_finished_by_id(fid)
	if is_objective_finished: return
	
	match(element.get("name")):
		"CosmicDust":
			check_for_objective_validation("MERGE_COSMICDUST")
		"Meteroid":
			check_for_objective_validation("MERGE_METEROID")
		"Planet":
			check_for_objective_validation("MERGE_PLANET")
		"Star":
			check_for_objective_validation("MERGE_STAR")
		"BlackHole":
			check_for_objective_validation("MERGE_BLACKHOLE")
		"Galaxy":
			check_for_objective_validation("BUILD_GALAXY")

func _on_current_progress_changed(objective, progress) -> void:
	var c = get_objective_current_progress_by_id(objective)
	var t = get_objective_target_progress_by_id(objective)
	
	var e = get_objective_current_progress_by_id(objective) > get_objective_target_progress_by_id(objective)
	if c == t or e:
		finish_objective_by_id(objective)

func _on_objective_completed(objective, next_objective) -> void:
	if objective.get("id") == 7:
		unlock_element_by_id(6)
	update_current_objective(next_objective.get("id"))
