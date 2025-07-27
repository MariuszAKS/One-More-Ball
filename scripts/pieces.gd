class_name Pieces
extends Node2D


signal correct_choice
signal wrong_choice

var game: Game

@onready var timer: Timer = get_node("Timer")
@onready var ball: Sprite2D = get_node("Ball")
@onready var markers: Array[Marker2D] = [
	get_node("Position1"),
	get_node("Position2"),
	get_node("Position3")
]
@onready var cups: Array[Area2D] = [
	get_node("Cup1"),
	get_node("Cup2"),
	get_node("Cup3")
]
@onready var paths: Array[Path2D] = [
	get_node("Path1"),
	get_node("Path2")
]
@onready var path_followers: Array[PathFollow2D] = [
	get_node("Path1/PathFollower"),
	get_node("Path2/PathFollower")
]

var cup_with_ball: int

var cups_mixed_count: int
var cups_mixed_max_count = 10

var cups_moving = false


func setup(_game: Game):
	game = _game
	game.begin_round.connect(on_begin_round)
	timer.timeout.connect(on_timer_timeout)

	for i in range(3):
		cups[i].input_event.connect(func(_viewport, event, _shape_idx): on_cup_pressed(event, i))

	set_cups_interactable(false)
	reset_cup_positions()
	randomize_ball_position()


func _process(delta: float):
	if cups_moving:
		move_cups(delta)

		if path_followers[0].progress_ratio >= 1.0:
			stop_moving_cups()
			cups_mixed_count += 1

			if cups_mixed_count < cups_mixed_max_count:
				start_moving_cups()
			else:
				ball.reparent(self)
				set_cups_interactable(true)


func start_moving_cups():
	set_cups_on_paths(get_random_cup_ids())
	cups_moving = true

func move_cups(delta: float):
	for i in range(2):
		path_followers[i].progress_ratio += 1.0 * game.speed_multiplier * delta

func stop_moving_cups():
	for i in range(2):
		path_followers[i].progress_ratio = 1.0
		path_followers[i].get_child(0).reparent(self)
	cups_moving = false


func randomize_ball_position():
	cup_with_ball = randi_range(0, 2)
	ball.position = cups[cup_with_ball].position

func reset_cup_positions():
	for i in range(3):
		cups[i].position = markers[i].position

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


func on_begin_round():
	reset_cup_positions()
	randomize_ball_position()

	cups_mixed_count = 0
	cups[cup_with_ball].position.y -= 48
	timer.start()

func on_timer_timeout():
	reset_cup_positions()
	ball.reparent(cups[cup_with_ball])

	start_moving_cups()

func on_cup_pressed(event: InputEvent, id: int):
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		set_cups_interactable(false)
		cups[cup_with_ball].position.y -= 48
		emit_signal("correct_choice" if id == cup_with_ball else "wrong_choice")
