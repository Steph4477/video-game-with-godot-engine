extends Node2D

func _ready():
	print_tree_pretty()
	print("🖼️ Debug parallax :")
	var paralaxe_fond = $ParalaxeFond
	if paralaxe_fond:
		var pb = paralaxe_fond.get_node("ParallaxBackground")
		if pb:
			var layer = pb.get_node("ParallaxLayer_fond")
			if layer:
				layer.motion_scale = Vector2(0.5, 0.5)
				print("✅ Parallax configuré :", layer)
			else:
				print("❌ ParallaxLayer_fond introuvable")
		else:
			print("❌ ParallaxBackground introuvable")
	else:
		print("❌ ParalaxeFond introuvable")
