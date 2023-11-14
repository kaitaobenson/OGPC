extends Area2D

@onready var hitbox = get_node("hitbox")
@onready var sprite = get_node("Sprite2D")
@onready var isInLib = (self.get_parent()!=get_node("/root/mainScene/commonObjLibrary"))
@onready var speed#speed is in pixels per sec
@onready var fireNow
@onready var despawnTime#this is in ms. after the projectile has bounced the amount equal to whatever bounceamount is, it will stay still and sit until despawmtime is up.
#pos is a vector2
#the NotSliding variable prevents the bounce efect being initiated multiple times because the projectile doesnt escape the hitbox it hit on the frame in which it happened
@onready var NotSliding = false
func fire(angle,pos,speedIn,despawnTime,bounceAmount):
	#set hitbox size to sprite size
	hitbox.shape.extents = sprite.get_rect().size/2
	self.position.x = pos.x
	self.position.y = pos.y
	self.rotation_degrees = angle
	speed = speedIn
	self.visible = true
	fireNow = true
	
	
func _ready():
	fire(-100,Vector2(0,0),200,999,999)
	if(!isInLib):
		self.visible = false
		self.get_node("hitbox").set_deferred("disabled", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isInLib):
		if (fireNow):
			#this shit had better work
			if(NotSliding):
				if(self.has_overlapping_areas() or self.has_overlapping_bodies()):
					self.rotation_degrees = -self.rotation_degrees
					
					#print(NotSliding)
					NotSliding = false
			self.position.x += speed*delta
			#print(self.rotation_degrees)
			self.position.y += (speed*delta)*tan(self.rotation_degrees)
			if(!self.has_overlapping_areas() or self.has_overlapping_bodies()):
				#print("e")
				NotSliding = true
			#self.hitbox.position.x = self.position.x
			#self.hitbox.position.y = self.position.y
			#print(self.position.x)
			#print(self.hitbox.position.x)
		
