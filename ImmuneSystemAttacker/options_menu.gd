class_name OptionsMenu
extends Control


@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button as Button
@onready var settings_tab_container: SettingsTabContainer = $MarginContainer/VBoxContainer/Settings_Tab_Container

signal exit_options_menu

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	settings_tab_container.Exit_Options_Menu.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
