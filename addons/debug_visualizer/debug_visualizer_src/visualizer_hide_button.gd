extends CheckButton


## Ссылка на элемент, который надо скрыть с некоторыми дочерними элементами
@export var hideable_parent: CanvasItem

func _toggled(toggled_on: bool) -> void:
	if hideable_parent == null:
		hideable_parent = get_parent() if (get_parent() != null and get_parent() is CanvasItem) else self
		print(hideable_parent)

	if toggled_on:

		for child in hideable_parent.find_children("*", "CanvasItem", true, false):
			if child.has_meta("debug_visualizer_always_visible") and child.get_meta("debug_visualizer_always_visible") == true:
				child.self_modulate.a = 0.5
			else:
				child.self_modulate.a = 0

		if hideable_parent is CanvasItem:
			hideable_parent.self_modulate.a = 0
		else:
			push_warning("родительский элемент {0} не является дочерним к CanvasItem".format([hideable_parent]))

	else:
		for child in hideable_parent.find_children("*", "CanvasItem", true, false):
			child.self_modulate.a = 1
		if hideable_parent is CanvasItem:
			hideable_parent.self_modulate.a = 1
		else:
			push_warning("родительский элемент {0} не является дочерним к CanvasItem".format([hideable_parent]))
