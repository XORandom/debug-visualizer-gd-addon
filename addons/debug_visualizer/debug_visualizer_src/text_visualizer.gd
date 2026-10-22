extends Panel
class_name TextVisualizer

## visualiser_id.x это номер визуализатора
@export_custom(PROPERTY_HINT_NONE, "suffix:id") var visualiser_id: int


@onready var text_visualizer_title: RichTextLabel = $TextVisualizerTitle
@onready var text_visualizer_text: RichTextLabel = $TextVisualizerText

## Создать массив с текстом, где текст по каждому индексу показывается в своей вкладке с текстом TODO

func show_text(caption_text:String, card_text:String) -> void:
		text_visualizer_title.text = caption_text
		text_visualizer_text.text = card_text
