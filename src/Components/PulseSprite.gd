extends Node2D

onready var parent : Sprite = self.get_parent()

var blip_scale : float = 1
var blip_diff : int = 1

func _process(delta):
	if parent.visible:
		blip_scale = blip_scale + (delta * blip_diff * 1.5)
		if blip_scale < 0.5:
			blip_scale = 0.5
			blip_diff = 1
		elif blip_scale > 1:
			blip_scale = 1
			blip_diff = -1
			
		var sprite = parent
		sprite.scale.x = blip_scale
		sprite.scale.y = blip_scale
	pass
