extends Node2D

onready var dots = get_parent().get_parent().get_node("Dots")
onready var pacs = get_parent()
onready var sim = get_parent().get_parent()
var c_dot
export var color = "4285F4"
var eaten = 0
var starving = null
var flying = false

func _ready():
	$A.self_modulate = Color(color)
	$B.self_modulate = Color(color)
	$AP2.play("big")
	eat(closest_food())

func _process(delta):
	if flying:
		c_dot.position += c_dot.position.direction_to(starving.position) * 8
		if c_dot.position.distance_to(starving.position) < 20:
			flying = false
			eaten += 1
			c_dot.queue_free()

func need_grab():
	starving = null
	if eaten < 1:
		return
	for i in pacs.get_children():
		if i.eaten < 1:
			starving = i
			return

func eat(food):
	if not food:
		$Wait.start()
		return
	food.chased = true
	c_dot = food
	var time = position.distance_to(food.position) / 200
	$Tween.interpolate_property(self, "position", position, food.position,
			time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$Timer.wait_time = clamp(time - 0.5, 0.01, 1000)
	$Timer.start()
	need_grab()

func _on_Timer_timeout():
	look_at(c_dot.position)
	if starving:
		$A.z_index = 0
		$B.z_index = 0
		flying = true
		c_dot.z_index = 0
	else:
		$A.z_index = 2
		$B.z_index = 2
		$AnimationPlayer.play("nom")

func ate():
	c_dot.queue_free()
	eaten += 1
	$Tick.start()

func day_end():
	randomize()
	if eaten < 1 and randi() % 2 == 0:
		$AP2.play("die")
		c_dot.chased = false
	elif eaten > 1 and randi() % 2 == 0:
		sim.new_pac(position, color, self.script)
	eaten = 0

func closest_food():
	var d = 1000000000
	var ans
	for i in dots.get_children():
		var tmp = position.distance_to(i.position)
		if tmp < d and not i.chased:
			d = tmp
			ans = i
	return ans

func _on_Tick_timeout():
	eat(closest_food())

func _on_Wait_timeout():
	eat(closest_food())

func _on_Spit_timeout():
	starving.eaten += 1
	c_dot.queue_free()
