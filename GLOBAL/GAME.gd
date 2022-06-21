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

## PAUSED
func set_game_paused(b: bool) -> void:
	game_paused = b

#### BUILT-IN ####

func _ready() -> void:
	pass
	
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



#### SIGNAL RESPONSES ####
