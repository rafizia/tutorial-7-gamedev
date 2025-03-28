Nama: Muhammad Rafi Zia Ulhaq<br>
NPM: 2206814551

## Sprinting & Crouching
Memungkinkan player untuk melakukan sprinting dan crouching.

#### Penjelasan
```
@export var sprint_speed: float = 20.0
@export var crouch_speed: float = 5.0
@export var speed: float = 10.0
var current_speed = speed

# Sprinting
if Input.is_action_pressed("sprint") and not is_crouching:
	current_speed = sprint_speed

# Crouching
if Input.is_action_pressed("crouch"):
	is_crouching = true
	current_speed = crouch_speed
	camera.position.y = lerp(camera.position.y, 0.5, 10 * delta)
else:
	is_crouching = false
	camera.position.y = lerp(camera.position.y, 1.0, 10 * delta)

movement_vector = movement_vector.normalized()

velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)
```
Jika pemain menekan tombol `shift` maka pemain akan memasuki mode sprint di mana `current_speed` akan diubah menjadi `sprint_speed` sehingga pergerakan pemain menjadi lebih cepat. Kemudian untuk crouching, jika pemain menekan tombol `ctrl` maka pemain akan memasuki mode crouch di mana `current_speed` akan diubah menjadi `crouch_speed` sehingga pergerakan pemain menjadi lebih lambat serta menurunkan kamera sehingga terlihat seperti sedang jongkok.

## Pick Up Item
![alt text](https://github.com/rafizia/tutorial-7-gamedev/blob/main/image/ambil_coin.png?raw=true)<br>
Memungkinkan pemain untuk mengambil dan membawa sebuah item.

#### Penjelasan
Item yang saya buat adalah item berbentuk sebuah koin emas raksasa yang bertipe RigidBody3D. Pemain dapat mengambil item ini dengan menekan tombol E pada keyboard serta meletakannya kembali dengan tombol yang sama.<br>
![alt text](https://github.com/rafizia/tutorial-7-gamedev/blob/main/image/player.png?raw=true)
<br>
![alt text](https://github.com/rafizia/tutorial-7-gamedev/blob/main/image/coin.png?raw=true)<br>
```
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
```
`_process(delta)`: jika pemain menekan tombol `interact` (E) maka pemain dapat mengambil sebuah item jika sedang tidak memegang sebuah item atau meletakkan sebuah item jika sedang memegang suatu item.
`pickup_object(obj)`: mengambil sebuah item dengan cara mengubah item tersebut menjadi child dari `Hand`.
`drop_object()`: meletakkan sebuah item dengan cara mengembalikan item tersebut ke `current_scene`.

## Menambahkan Aset 3D dari Luar
![alt text](https://github.com/rafizia/tutorial-7-gamedev/blob/main/image/aset.png?raw=true)<br>
Saya menambahkan beberapa objek seperti Coin, Bed, Floor, Wall, dan beberapa objek lain. Objek-objek tersebut saya dapatkan dari https://kaylousberg.itch.io/kaykit-dungeon-remastered.

##### Referensi:
https://youtu.be/0TlZ-c2OVEM?si=CF1N02QxiQQ_bgTf
