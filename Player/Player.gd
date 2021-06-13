"""
This script controls the player character.
"""


signal start_dash


extends KinematicBody2D

var JUMP_FORCE = 1550			# Force applied on jumping
var MOVE_SPEED = 500		# Speed to walk with
var GRAVITY = 60			# Gravity applied every second
var MAX_SPEED = 5000		# Maximum speed the player is allowed to move
var FRICTION_AIR = 0.98		# The friction while airborne
var FRICTION_GROUND = 0.85
var CHAIN_PULL = 125
var DASH_TIME = 0.25 * 1000
var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)
var can_jump = false			# Whether the player used their air-jump

var last_shake = OS.get_system_time_msecs()
var dash_dir = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and !event.pressed:
		$Chain.release()

func _should_shoot_at(position):
	if last_shake + DASH_TIME > OS.get_system_time_msecs():
		return # don't shoot if we're dashing
	if !$Chain.flying and !$Chain.hooked and Input.is_mouse_button_pressed(1):
		$Chain.release()
		var look_vec = position - global_position
		$Chain.shoot(look_vec)

# This function is called every physics frame
func _physics_process(delta: float) -> void:
	# Falling
	velocity.y += GRAVITY

	# Hook physics
	if last_shake + DASH_TIME > OS.get_system_time_msecs():
		velocity = dash_dir * CHAIN_PULL * 1.65 * 20
		chain_velocity = Vector2.ZERO
	elif $Chain.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL #* (1+(-position.y/10000))
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65

		if $Chain.len_squared() < 150:
			chain_velocity *= 1.2
		
		if shaking(delta) and last_shake + (2*1000) < OS.get_system_time_msecs():
			last_shake = OS.get_system_time_msecs()
			dash_dir = to_local($Chain.tip).normalized()
			$Chain.release()
			emit_signal("start_dash")
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity

	
	velocity = move_and_slide(velocity, Vector2.UP)	# Actually apply all the forces


	velocity.y = min(velocity.y, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	
	#if $Chain.hooked and $Chain.len_squared() > $Chain.old_len_sq and $Chain.len_squared() < 250*250 \
	#and velocity.length_squared() > 200*200 and OS.get_ticks_msec() - $Chain.hooked_time  > 150:
	#	$Chain.release()

	
	
	if is_on_floor():
		velocity.x *= FRICTION_GROUND
	else:
		velocity *= FRICTION_AIR

func shaking(delta: float) -> bool:
	# todo fix this because get_last_mouse_speed could return the same speed multiple times if the user stops moving the mouse
	return Input.get_last_mouse_speed().length() > GameState.to_res_independant(4000) and Input.is_mouse_button_pressed(1)
	#return Input.is_mouse_button_pressed(2) and Input.is_mouse_button_pressed(1)
