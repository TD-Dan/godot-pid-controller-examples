extends Node2D


var pid_controller_x = PIDController.new()
var pid_controller_y = PIDController.new()

var drag_target = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%SpinBox_P.value = pid_controller_x.Kp
	%SpinBox_I.value = pid_controller_x.Ki
	%SpinBox_D.value = pid_controller_x.Kd


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pid_controller_x.setpoint = %Target.position.x
	pid_controller_y.setpoint = %Target.position.y
	%Follower.position.x += (pid_controller_x.step(%Follower.position.x, delta))/100
	%Follower.position.y += (pid_controller_y.step(%Follower.position.y, delta))/100
	
	if drag_target:
		%Target.position = get_global_mouse_position()


func _on_spin_box_p_value_changed(value):
	pid_controller_x.Kp = value
	pid_controller_y.Kp = value
	%SpinBox_P.value = pid_controller_x.Kp


func _on_spin_box_i_value_changed(value):
	pid_controller_x.Ki = value
	pid_controller_y.Ki = value
	%SpinBox_I.value = pid_controller_x.Ki


func _on_spin_box_d_value_changed(value):
	pid_controller_x.Kd = value
	pid_controller_y.Kd = value
	%SpinBox_D.value = pid_controller_x.Kd


func _on_target_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_target = true
			%Target/AnimatedSprite2D.play("crabbed")


func _input(event):
	if event is InputEventMouseButton:
		if not event.pressed:
			drag_target = false
			%Target/AnimatedSprite2D.play("standing")
	


func _on_button_pressed():
	pid_controller_x.reset()
	pid_controller_y.reset()
	%Follower.position=Vector2i(100,100)
