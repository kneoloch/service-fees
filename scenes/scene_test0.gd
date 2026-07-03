extends Scene
class_name SceneTest0

var script_array: Array[Array] = [
	[cam(Vector3(0, 0, 3.5), 3, Vector3.ZERO), light(0)],
	#n("The princess's idea of a joke.", Vector3(-1.5, 1.3, 0.5), 32, Color.BLACK, false)]
	[cam(Vector3(-5, -6.5, 6.5), 1, Vector3.ZERO), light(1)], 
	#n("Chaeyeon eyes the ring over her bowl of noodles, slurping loudly. Maybe if she stares at it for long enough, it would spontaneously combust and spare her from making a decision at all.", Vector3(-5, -6, 0.5), 49, Color.BLACK, false),
	[cam_switch(1)],
	[cam_switch(2)],
	#[cam(Vector3(-2.3, -5.5, 8.3), 0, Vector3(-63, 43.5, 51.5))], 
	#cam(Vector3(-2.3, -5.5, 8.3), 0, Vector3.ZERO), 
]
