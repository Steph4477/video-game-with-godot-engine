extends Area2D

@export var next_scene_path: String

func _on_body_entered(body):
	if body.name == "Player": 
		if body.has_node("anim"):
			var anim_player = body.get_node("anim")
			if anim_player is AnimationPlayer and anim_player.has_animation("door"):

				# 🔒 Verrouille mouvement + anim
				body.animation_locked = true
				body.set_physics_process(false)

				# ❌ Empêche tir ou autres interactions
				body.input_locked = true  # si tu veux l’utiliser plus tard

				anim_player.play("door")
				await anim_player.animation_finished

				# ✅ Optionnel : fondu noir ici (si tu veux)
				# await _start_fade_out()

				_changer_scene()
				return
	_changer_scene()


func _changer_scene():
	await get_tree().create_timer(0.2).timeout
	var game_state = get_node_or_null("/root/GameManagement/SceneContainer/GameState")
	if game_state:
		game_state.load_level(next_scene_path)
