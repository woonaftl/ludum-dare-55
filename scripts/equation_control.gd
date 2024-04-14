extends Control


func to_local(p_global: Vector2) -> Vector2:
	return get_global_transform().affine_inverse() * p_global
