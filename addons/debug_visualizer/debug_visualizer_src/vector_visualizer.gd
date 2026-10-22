extends Sprite2D
class_name VectorVisualizer

## Визуализатор веторов
##
## Показывает в виде настраиваемых стрелок
## направление и величину вектора[br]
## Инструмент отладки [br]
## Не должен загружаться как синглтон,
## т.к. для отладки иногда надо много векторов

## visualiser_id это номер визуализатора
@export_custom(PROPERTY_HINT_NONE, "suffix:id") var visualiser_id: int

## Ограничение количества векторов на одной панели
@export var vector_limit: int = 20

## Работаем с массивом стрелок. [br]
## Ограничение на количество стрелок в одном визуализаторе по умолчанию - 20
@export var array_of_line2d: Array[Line2D]
## Для них также указан ресурсы палитры цветов


@export var line2d_palette: ColorPalette = preload("uid://du4i1o7q42rfi")


const VECTOR_COORDS = preload("uid://b20jth528cofw")


func _ready() -> void:
	array_of_line2d.resize(vector_limit)
	array_of_line2d.fill(null)
	texture = VECTOR_COORDS

	_setup_line2d(0)



## Настраиваем созданный вектор
func _setup_line2d(line_2d_id:int=0) -> void:
	## Пропускаем эту функцию, если вектор уже существует
	if not array_of_line2d[line_2d_id]==null:
		return

	var new_line_2d : Line2D = Line2D.new()

	add_child(new_line_2d)
	new_line_2d.default_color=line2d_palette.colors[line_2d_id]

	new_line_2d.add_point(Vector2(0.5, 0.5))
	new_line_2d.add_point(Vector2(0.5, 0.5))

	# Первая стрелка
	new_line_2d.set_point_position(0, Vector2(0.5, 0.5))
	new_line_2d.set_point_position(1, Vector2(texture.get_width()/2.5, 0.5))
	new_line_2d.set_meta("line_2d_id", line_2d_id)

	## Добавлю в массив по индексу
	array_of_line2d[line_2d_id] = new_line_2d




## Визуализирует направление вектора
## Пример использования [br]
## [code]
## show_vector(0, Vector2.ZERO, false, 6.1)
## [/code]
## vec_id
## Если из нескольких мест пытаются записать значение вектора в один визуализатор,
## то суммировать вектора и показывать результирующий вектор
func show_vector(
	vec_id:int, #Номер стрелки, хранится в метаданных
	vector:Vector2,
	log_form:bool=true,
	divider:float =.1,
	) -> void:

	if vec_id == vector_limit:
		push_warning("vec_id >{0}, vec_id={0}".format([vector_limit-1]))
		vec_id = vector_limit
	_setup_line2d(vec_id)

	if log_form:
		var normal_vec: Vector2 = vector.normalized()
		# Логарифм не переваривает отрицательные значения
		# Поэтому берем модуль
		# который потом домножаем на знак исходного вектора
		vector = Vector2(log(abs(vector.x))*sign(normal_vec.x), log(abs(vector.y))*sign(normal_vec.y))
		array_of_line2d[vec_id].set_point_position(1, vector/divider)
	else:
		array_of_line2d[vec_id].set_point_position(1, vector/divider)
