"""
This script controls the player character.
"""
extends KinematicBody2D

const JUMP_FORCE = 1550			# Force applied on jumping
const MOVE_SPEED = 500			# Speed to walk with
const GRAVITY = 60				# Gravity applied every second
const MAX_SPEED = 2000			# Maximum speed the player is allowed to move
const FRICTION_AIR = 0.98		# The friction while airborne
const FRICTION_GROUND = 0.85
const CHAIN_PULL = 105

var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)
var can_jump = false			# Whether the player used their air-jump


func _should_shoot_at(position):
	$Chain.release()
	var look_vec = position - global_position
	$Chain.shoot(look_vec)

# This function is called every physics frame
func _physics_process(_delta: float) -> void:
	# Falling
	velocity.y += GRAVITY

	# Hook physics
	if $Chain.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		
		if $Chain.len_squared() < 150:
			chain_velocity *= 1.2
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity

	velocity = move_and_slide(velocity, Vector2.UP)	# Actually apply all the forces

	# Manage friction and refresh jump and stuff
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	
	if $Chain.hooked and $Chain.len_squared() > $Chain.old_len_sq and $Chain.len_squared() < 300*300 and velocity.length_squared() > 100*100:
		$Chain.release()

	
	
	if is_on_floor():
		velocity.x *= FRICTION_GROUND
	else:
		velocity *= FRICTION_AIR
	
