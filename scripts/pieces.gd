class_name Pieces
extends Node2D

signal correct_choice
signal wrong_choice


var game: Game


var positions: Array[Marker2D]
var cups: Array[Area2D]
var cup_with_ball: int
var ball: Sprite2D

var paths: Array[Path2D]
var path_followers: Array[PathFollow2D]

var cups_mixed_count: int
var cups_mixed_max_count = 6

var cups_moving = false


func _ready():
	Global.start_round.connect(on_round_start)

	positions = []
	cups = []

	for i in range(3):
		positions.append(get_node("Position" + str(i+1)))
		cups.append(get_node("Cup" + str(i+1)))
		cups[i].position = positions[i].position
		cups[i].input_pickable = true
		cups[i].input_event.connect(func(_viewport, event, _shape_idx): on_cup_pressed(event, i))

	cup_with_ball = 1
	ball = get_node("Ball")
	ball.position = positions[cup_with_ball].position

	paths = []
	path_followers = []

	for i in range(2):
		var new_path: Path2D = Path2D.new()
		new_path.curve = Curve2D.new()
		new_path.z_index = 10

		paths.append(new_path)
		add_child(new_path)

		var new_path_follower: PathFollow2D = PathFollow2D.new()
		new_path_follower.loop = false

		path_followers.append(new_path_follower)
		new_path.add_child(new_path_follower)


func _process(delta: float):
	if cups_moving:
		move_cups(delta)

		if path_followers[0].progress_ratio >= 1.0:
			stop_moving_cups()

			if cups_mixed_count < cups_mixed_max_count:
				cups_mixed_count += 1
				start_moving_cups()
			else:
				set_cups_interactable(true)


func start_moving_cups():
	var cup_ids: Array[int] = get_random_cup_ids()

	set_cups_on_paths(cup_ids)

	ball.visible = false
	cups_moving = true

func move_cups(delta: float):
	for i in range(2):
		path_followers[i].progress_ratio += 1.0 * game.speed_multiplier * delta

func stop_moving_cups():
	for i in range(2):
		path_followers[i].progress_ratio = 1.0
		path_followers[i].get_child(0).reparent(self)

		ball.visible = true
		cups_moving = false


func set_cups_interactable(value: bool):
	for i in range(3):
		cups[i].input_pickable = value

func get_random_cup_ids() -> Array[int]:
	var cup1_id = randi_range(0, 2)
	var cup2_id = randi_range(0, 2)

	while cup2_id == cup1_id:
		cup2_id = randi_range(0, 2)
	
	return [cup1_id, cup2_id]

func set_cups_on_paths(cup_ids: Array[int]):
	for i in range(2):
		paths[i].curve.clear_points()
		paths[i].curve.add_point(cups[cup_ids[i]].position)
		paths[i].curve.add_point(cups[cup_ids[(i+1)%2]].position)
	
	for i in range(2):
		path_followers[i].progress_ratio = 0
		cups[cup_ids[i]].reparent(path_followers[i])


func on_round_start():
	cups_mixed_count = 0

	set_cups_interactable(false)
	start_moving_cups()

func on_cup_pressed(event: InputEvent, id: int):
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		print(id)
		emit_signal("correct_choice" if id == cup_with_ball else "wrong_choice")
