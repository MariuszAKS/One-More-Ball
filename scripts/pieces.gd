class_name Pieces
extends Node2D

signal correct_choice
signal wrong_choice


var positions: Array[Marker2D]
var cups: Array[Area2D]
var cup_with_ball: int
var ball: Sprite2D


func _ready():
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


func restart_cups():
	for i in range(3):
		cups[i].position = positions[i].position

func mix_cups():
	for i in range(3):
		cups[i].input_pickable = false

	var moves_amount = randi_range(3, 6)

	for i in range(moves_amount):
		var cup_to_move = randi_range(0, 2)
		var new_position = randi_range(0, 2)

		while new_position == cup_to_move:
			new_position = randi_range(0, 2)
		
		# animation of moving (path to follow using markers?)
	
	for i in range(3):
		cups[i].input_pickable = true

func on_cup_pressed(event: InputEvent, id: int):
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		print(id)
		emit_signal("correct_choice" if id == cup_with_ball else "wrong_choice")
