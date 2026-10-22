extends Node2D

## Пример использования
## визуализатора данных

enum {HOUR, MINUTE, SECOND}
const HOUR_HAND_LENGTH: int = 4
const MINUTE_HAND_LENGTH: int = 5
const SECOND_HAND_LENGTH: int = 6

## Сколько секунд сейчас
var project_current_second: float = 0.0
## Сколько минут сейчас
var project_current_minute: float = 0.0
## Который час
var project_current_hour: float = 0.0

func _ready() -> void:
	DebuggerVusializer.visualize_vector(0, 0, Vector2.LEFT.rotated(0), false, 0.100, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 1, Vector2.LEFT.rotated(PI/6), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 2, Vector2.LEFT.rotated(PI/4), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 3, Vector2.LEFT.rotated(PI/3), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 4, Vector2.LEFT.rotated(PI/2), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 5, Vector2.LEFT.rotated(2*PI/3), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 6, Vector2.LEFT.rotated(3*PI/4), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 7, Vector2.LEFT.rotated(5*PI/6), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 8, Vector2.LEFT.rotated(PI), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 9, Vector2.LEFT.rotated(7*PI/6), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 10, Vector2.LEFT.rotated(5*PI/4), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 11, Vector2.LEFT.rotated(4*PI/3), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 12, Vector2.LEFT.rotated(3*PI/2), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 13, Vector2.LEFT.rotated(5*PI/3), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 14, Vector2.LEFT.rotated(7*PI/4), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 15, Vector2.LEFT.rotated(11*PI/6), false, 0.01, Vector2(200, 500))
	DebuggerVusializer.visualize_vector(0, 16, Vector2.LEFT.rotated(2*PI), false, 0.01, Vector2(200, 500))



func _physics_process(delta: float) -> void:
	var time: Dictionary = Time.get_time_dict_from_system()
	project_current_hour = time["hour"]
	project_current_minute = time["minute"]
	project_current_second = time["second"]


	DebuggerVusializer.show_debug_info(["local_pos= ", get_local_mouse_position(),"\n", "global_pos=", get_global_mouse_position()], 0, ["MousePosition"])
	DebuggerVusializer.show_debug_info(["local_pos= ", get_local_mouse_position(),"\n", "global_pos=", get_global_mouse_position()], 1, ["MousePosition"])
	DebuggerVusializer.show_debug_info(["local_pos= ", get_local_mouse_position(),"\n", "global_pos=", get_global_mouse_position()], 2, ["MousePosition"])
	DebuggerVusializer.show_debug_info(["local_pos= ", get_local_mouse_position(),"\n", "global_pos=", get_global_mouse_position()], 3, ["MousePosition"])
	DebuggerVusializer.show_debug_info(["local_pos= ", get_local_mouse_position(),"\n", "global_pos=", get_global_mouse_position()], 4, ["MousePosition"])
	DebuggerVusializer.show_debug_info(["local_pos= ", get_local_mouse_position(),"\n", "global_pos=", get_global_mouse_position()], 5, ["MousePosition"])
	DebuggerVusializer.visualize_vector(1, 1, get_global_mouse_position(), false, sqrt(pow(get_window().size.y, 2)+pow(get_window().size.x, 2))/100, Vector2(600, 700))
	DebuggerVusializer.visualize_vector(2, 0, get_local_mouse_position(), false, sqrt(pow(get_window().size.y, 2)+pow(get_window().size.x, 2))/100, Vector2(200, 500))


	DebuggerVusializer.visualize_vector(3, 6, calculate_hand_tip_location(HOUR), false, 0.05, Vector2(600, 500))
	DebuggerVusializer.visualize_vector(3, 6, calculate_hand_tip_location(HOUR), false, 0.05, Vector2(600, 500))
	DebuggerVusializer.visualize_vector(3, 7, calculate_hand_tip_location(MINUTE), false, 0.05, Vector2(600, 500))
	DebuggerVusializer.visualize_vector(3, 0, calculate_hand_tip_location(SECOND), false, 0.05, Vector2(600, 500))


func calculate_hand_tip_location(hand: int) -> Vector2:
	var length: float
	var angle: float

	match hand:
		SECOND:
			length = SECOND_HAND_LENGTH
			angle = deg_to_rad(project_current_second * 6.0)
		MINUTE:
			length = MINUTE_HAND_LENGTH
			angle = deg_to_rad(project_current_minute * 6.0+project_current_second*0.1)
		HOUR:
			length = HOUR_HAND_LENGTH
			angle = deg_to_rad(project_current_hour * 30.0 + project_current_minute * 0.5)

	var x: float = length * sin(angle)
	var y: float = -length * cos(angle)

	return Vector2(x, y)
