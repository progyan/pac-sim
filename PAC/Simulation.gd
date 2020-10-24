extends Node2D

onready var dot = preload("res://Dot.tscn")
onready var pac = preload("res://Pac.tscn")
var seeds = []

func _on_Timer_timeout():
	randomize()
	var d = dot.instance()
	d.position = Vector2(randi() % 1920, randi() % 1080)
	$Dots.add_child(d)

func _on_Day_timeout():
	get_tree().call_group("Pacs", "day_end")

func new_pac(pos, color, script):
	var p = pac.instance()
	p.position = pos
	p.color = color
	p.script = script
	$Pacs.add_child(p)
 
func sim():
	pass
