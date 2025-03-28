extends RayCast3D

@onready var hand: Node3D = $"../../Hand"
var current_collider
var held_object = null
var is_holding = false

func _ready():
	pass

func _process(delta):
	var collider = get_collider()

	if is_colliding() and collider is Interactable:
		if Input.is_action_just_pressed("interact"):
			collider.interact()
			
	if is_colliding() and collider.is_in_group("pickable"):
		if Input.is_action_just_pressed("interact"):
			if is_holding:
				drop_object()
			else:
				pickup_object(collider)
				
	if is_holding and held_object:
		held_object.global_position = hand.global_position
		held_object.global_rotation = hand.global_rotation
			
# Fungsi untuk mengambil objek
func pickup_object(obj):
	held_object = obj
	is_holding = true
	obj.global_position = hand.global_position
	obj.global_rotation = hand.global_rotation
	obj.reparent(hand)  # Menjadikan objek sebagai anak dari tangan
	obj.collision_layer = 2
	obj.linear_velocity = Vector3.ZERO

# Fungsi untuk menjatuhkan objek
func drop_object():
	if held_object:
		held_object.reparent(get_tree().current_scene)  # Kembalikan ke scene utama
		held_object.collision_layer = 2
		held_object.linear_velocity = Vector3(0, 3, 0)  # Memberi efek jatuh
		held_object = null
		is_holding = false
