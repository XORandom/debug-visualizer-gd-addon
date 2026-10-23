extends CheckButton


signal modulate_changed

@export_range(0., 1., 0.1) var modulate_index: float = 0.5:
	set(value):
		modulate_index = value
		modulate_changed.emit(hideable_parent)


## Ссылка на элемент, который надо скрыть с некоторыми дочерними элементами
@export var hideable_parent: CanvasItem


func _ready() -> void:
	modulate_changed.connect(set_original_modulate)
	set_original_modulate(hideable_parent)

func _toggled(toggled_on: bool) -> void:

	if toggled_on:
		hide_hideable_elements(hideable_parent)

	else:
		set_original_modulate(hideable_parent)


func check_hideable_parent(hideable_parent) -> CanvasItem:
	if hideable_parent == null:
		return get_parent() if (get_parent() != null and get_parent() is CanvasItem) else self
	else:
		return hideable_parent


func set_original_modulate(hideable_parent) -> void:
	hideable_parent = check_hideable_parent(hideable_parent)
	for child in hideable_parent.find_children("*", "CanvasItem", true, false):
		child.self_modulate.a = modulate_index
	if hideable_parent is CanvasItem:
		hideable_parent.self_modulate.a = modulate_index
	else:
		push_warning("родительский элемент {0} не является дочерним к CanvasItem".format([hideable_parent]))


func hide_hideable_elements(hideable_parent) -> void:
	hideable_parent = check_hideable_parent(hideable_parent)
	for child in hideable_parent.find_children("*", "CanvasItem", true, false):
		if child.has_meta("debug_visualizer_always_visible") and child.get_meta("debug_visualizer_always_visible") == true:
			child.self_modulate.a = 0.4
		else:
			child.self_modulate.a = 0

	if hideable_parent is CanvasItem:
		hideable_parent.self_modulate.a = 0
	else:
		push_warning("родительский элемент {0} не является дочерним к CanvasItem".format([hideable_parent]))
