extends CanvasLayer

@export var vector_visualizer: PackedScene = preload("uid://btwcn5l1jih2m")
@export var text_visualizer: PackedScene = preload("uid://bky42siellcoe")


## Здесь панель для векторов
@onready var panel: Panel = $Control/Panel

## Массив существующих визуализаций для векторов
var vector_visualizes_array: Array[VectorVisualizer] = []
## Массив существующих визуализаций для текстовых панелей
var text_visualizes_array: Array[TextVisualizer] = []

## узнаём размер она
var windows_sise: Vector2i
#TODO насколько ресурсоёмка эта процедура,
#стоит ли вызывать в каждом физическом кадре для игры с разным размером окна TODO

func  _ready() -> void:
	windows_sise = get_window().size
	print(windows_sise)
	vector_visualizes_array.resize(10)
	vector_visualizes_array.fill(null)
	text_visualizes_array.resize(10)
	text_visualizes_array.fill(null)
	var temp_iter_id: int = 0
	for child in panel.get_children():
		if child is VectorVisualizer:
			vector_visualizes_array[temp_iter_id] = child
			if temp_iter_id <10:
				temp_iter_id +=1
			else:
				push_warning("Количество элементов превышает размер массива")
				break
		if child is TextVisualizer:
			vector_visualizes_array[temp_iter_id] = child
			if temp_iter_id <10:
				temp_iter_id +=1
			else:
				push_warning("Количество элементов превышает размер массива")
				break


## Показывает нужную информацию прямо на экран [br]
## Пример использования [br]
## [code]
## DebuggerVusializer.show_debug_info([DATA, "DATA"], PANEL_ID, CAPTION_DATA, POSITION)
## [/code] [br]
## [code]
## DebuggerVusializer.show_debug_info([], 2)
## DebuggerVusializer.show_debug_info([global_position, rotation, "data"], 0, ["global rotation"], Vector2(100,200))
## DebuggerVusializer.show_debug_info(["ТЕКСТ"], 5)
## [/code]
func show_debug_info(
	new_data: Array,
	pnl_id: int,
	title_data:Array=[" "],
	pnl_position: Vector2=Vector2.ZERO
	) -> void:

	if (pnl_position.x > windows_sise.x
	or pnl_position.y > windows_sise.y
	or pnl_position.x < 0
	or pnl_position.y > 0):
		push_warning("Панель {0} находится за границей экрана.
		Положение панели: {1}
		Размер окна: {2}
		".format([pnl_id, pnl_position, windows_sise]))
		## Поставив Vector2.ZERO, будет использоваться маркер для координат
		pnl_position = Vector2.ZERO

	if text_visualizes_array[pnl_id] == null:
		_spawn_text_visualizer(pnl_id, pnl_position)
	text_visualizes_array[pnl_id].show_text(_array_to_string(title_data), _array_to_string(new_data))



## функция, позволяющая преобразовать массив в строку
func _array_to_string(arr: Array) -> String:
	var s: String = ""
	for i: Variant in arr:
		var temp: String = "{0}"
		s += temp.format([i], "{0}")
	return s

## Применение
## [code]
## DebuggerVusializer.visualize_vector(PANEL_ID, VECTOR_ID, VECTOR, false, DIVIDER, PANEL_POSITION)
## [/code] [br]
## [code]
## DebuggerVusializer.visualize_vector(6, 7, gravity_vector * force_magnitude, false, gravity_mass, Vector(100, 500)
## [/code]
func visualize_vector(
	pnl_id:int=0, #Номер визуализатора
	vec_id:int=0, #Номер стрелки
	vector:Vector2=Vector2.ZERO,
	log_form:bool=true,
	divider:float =.1,
	pnl_position: Vector2=Vector2.ZERO
	) -> void:

	if (pnl_position.x > windows_sise.x
	or pnl_position.y > windows_sise.y
	or pnl_position.x < 0
	or pnl_position.y > 0):
		push_warning("Панель {0} находится за границей экрана.
		Положение панели: {1}
		Размер окна: {2}
		Вместо указанных координат будут использоваться координаты Marker2D
		".format([pnl_id, pnl_position, windows_sise]))
		## Поставив Vector2.ZERO, будет использоваться маркер для координат
		pnl_position = Vector2.ZERO

	if vector_visualizes_array[pnl_id] == null:
		_spawn_vector_visualizer(pnl_id, pnl_position)
	vector_visualizes_array[pnl_id].show_vector(vec_id, vector, log_form, divider)


## Создает панель в заданной точке
func _spawn_text_visualizer(panel_id:float=0, panel_position: Vector2=Vector2.ZERO) -> void:
	# Создаём экземпляр вектора
	var text_ui: TextVisualizer = text_visualizer.instantiate()
	panel.add_child(text_ui)
	text_ui.visualiser_id = panel_id
	text_visualizes_array[panel_id] = text_ui

	if panel_position==Vector2.ZERO:
		get_marker_pos(panel_id, text_ui)
	else:
		text_ui.position = panel_position


## Помещает позицию узла на место маркера
## Маркер после этого удаляется
## Если нет маркера и координат, узел удаляется
func get_marker_pos(panel_id, placed_node) -> void:
	## Ссылка на удаляемый маркер сохранения координат
	var temp_child_link: Marker2D = null

	if panel_id > panel.get_child_count():
		push_warning("не осталось маркеров для размещения панели {0}, укажите координаты".format([panel_id]))
		placed_node.queue_free()
		return

	if panel.get_child(panel_id) is Marker2D:
		temp_child_link=panel.get_child(panel_id)

	# Удаляем маркер
	temp_child_link.queue_free()
	placed_node.position = temp_child_link.position



## Показать визуализацию вектора в заданной точке
## Использует первый доступный маркер, если не указано местоположение вектора
## Если указано, то создает по указанным координатам
## У каждой панели отладки есть свой id и номер стрелки
## Если id совпадает, а номер стрелки не указан, дописывает следующий номер стрелки
## Если указан id и номер стрелки, то изменяет его
func _spawn_vector_visualizer(panel_id:int=0, panel_position: Vector2=Vector2.ZERO) -> void:
	# Создаём экземпляр вектора
	var vector_ui: VectorVisualizer = vector_visualizer.instantiate()
	panel.add_child(vector_ui)
	vector_ui.visualiser_id = panel_id
	vector_visualizes_array[panel_id] = vector_ui

	if panel_position==Vector2.ZERO:
		get_marker_pos(panel_id, vector_ui)
	else:
		vector_ui.position = panel_position
