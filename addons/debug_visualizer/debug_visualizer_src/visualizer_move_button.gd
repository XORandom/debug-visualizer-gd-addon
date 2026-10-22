extends TextureButton

#TODO просто присоединяешь и этот элемент позволяет перемещать родительские узлы

## Ссылка на родительский элемент, который надо перемещать
@export var movable_parent: CanvasItem

## Перетаскивается ли панель сейчас
var dragging: bool = false
## Смещение, чтобы панель не была привязана центром к позиции мышки
var dragging_offset: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if dragging:
		movable_parent.position = get_global_mouse_position() - dragging_offset

func _ready() -> void:
	if movable_parent == null:
		movable_parent = get_parent() if get_parent() != null else self


func _toggled(toggled_on: bool) -> void:
	print(toggled_on)

func _on_visualizer_move_button_button_up() -> void:
	dragging = false


func _on_visualizer_move_button_button_down() -> void:

	dragging = true
	dragging_offset = get_global_mouse_position() - movable_parent.global_position
