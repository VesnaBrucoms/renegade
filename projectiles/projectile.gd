class_name Projectile extends Area2D

@export var damage: int
@export var speed: int
@export var is_player_weapon: bool

var initial_velocity

func _process(delta):
	var velocity = initial_velocity.normalized() * speed
	position += velocity * delta


func _visibility_notifier_screen_exited() -> void:
	queue_free()


## Queue the projectile for removal.
func destroy_projectile() -> void:
	queue_free()
