"""
This script controls the player character.
"""
extends KinematicBody2D

const JUMP_FORCE = 1550			# Force applied on jumping
const MOVE_SPEED = 500			# Speed to walk with
const GRAVITY = 60				# Gravity applied every second
const MAX_SPEED = 1000			# Maximum speed the player is allowed to move
const FRICTION_AIR = 0.95		# The friction while airborne
const FRICTION_GROUND = 0.85	# The friction while on the ground
const CHAIN_PULL = 105

var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)
var can_jump = false			# Whether the player used their air-jump

func _should_shoot_at(position):
	$Chain.release()
	print("hello")
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
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity

	velocity = move_and_slide(velocity, Vector2.UP)	# Actually apply all the forces
	# ^ This is done so we don't build up walk speed over time

	# Manage friction and refresh jump and stuff
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	var grounded = is_on_floor()
	if grounded:
		velocity.x *= FRICTION_GROUND	# Apply friction only on x (we are not moving on y anyway)
		can_jump = true 				# We refresh our air-jump
		if velocity.y >= 5:		# Keep the y-velocity small such that
			velocity.y = 5		# gravity doesn't make this number huge
	elif is_on_ceiling() and velocity.y <= -5:	# Same on ceilings
		velocity.y = -5

	# Apply air friction
	if !grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR

	# Jumping
	if Input.is_action_just_pressed("jump"):
		if grounded:
			velocity.y = -JUMP_FORCE	# Apply the jump-force
		elif can_jump:
			can_jump = false	# Used air-jump
			velocity.y = -JUMP_FORCE