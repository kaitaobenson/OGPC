extends Area2D
#TODO: f
@onready var hitbox = get_node("hitbox")
@onready var sprite = get_node("Sprite2D")
@onready var isInLib = (self.get_parent()!=get_node("/root/mainScene/commonObjLibrary"))
@onready var speed#speed is in pixels per sec
@onready var fireNow
@onready var despawnTime#this is in ms. after the projectile has bounced the amount equal to whatever bounceamount is, it will stay still and sit until despawmtime is up.
#pos is a vector2
@onready var firetime
@onready var despawnCounter = 0
@onready var hitamount = 0
@onready var hitlimit = 0
#the NotSliding variable prevents the bounce efect being initiated multiple times because the projectile doesnt escape the hitbox it hit on the frame in which it happened
@onready var NotSliding = true
func fire(angle,pos,speedIn,despawnpime,bounceAmount):
	#set hitbox size to sprite size
	hitbox.shape.extents = sprite.get_rect().size/2
	self.position.x = pos.x
	self.position.y = pos.y
	self.rotation_degrees = angle
	speed = speedIn
	self.visible = true
	fireNow = true
	hitlimit = bounceAmount
	despawnTime = despawnpime
#func get_collision_angle():
func _ready():
	#despawn time is in seconds, i think?
	fire(40,Vector2(0,0),500,6,1)
	if(!isInLib):
		self.visible = false
		self.get_node("hitbox").set_deferred("disabled", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isInLib):
		if (fireNow):
			if(!hitamount==hitlimit or hitamount==0):
				print("ec")
				if(NotSliding):
					if(self.has_overlapping_areas() or self.has_overlapping_bodies()):
						print(self.position.x)
						print(self.position.y)
						print("thingy got hit!")
						hitamount = hitamount+1
						self.rotation_degrees = -self.rotation_degrees
						#speed = -speed
						NotSliding = false
				print("reached")
				self.position.x += speed*delta
				self.position.y += tan(deg_to_rad(self.rotation_degrees))*speed*delta
				#debug code
				if(!NotSliding):
					print(self.position.x)
					print(self.position.y)
				if(!self.has_overlapping_areas() or self.has_overlapping_bodies()):
					NotSliding = true		
				firetime = Time.get_unix_time_from_system()
			else:
					despawnCounter = Time.get_unix_time_from_system()-firetime
					print(despawnTime)
					print(despawnCounter)
					if(despawnCounter>=despawnTime):
						self.queue_free()
