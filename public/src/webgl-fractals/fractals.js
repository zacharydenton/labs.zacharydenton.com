// set the scene size
var WIDTH = 940,
	HEIGHT = 600;

// get the DOM element to attach to
// - assume we've got jQuery to hand
var $container = $('#container');

// create a WebGL renderer, camera
// and a scene
var renderer = new THREE.WebGLRenderer();
var camera = new THREE.OrthographicCamera(0, 1, 0, 1);
var scene = new THREE.Scene();

// the camera starts at 0,0,0 so pull it back
camera.position.z = 1;

// start the renderer
renderer.setSize(WIDTH, HEIGHT);

// attach the render-supplied DOM element
$container.append(renderer.domElement);

var planeMaterial = new THREE.ShaderMaterial({
fragmentShader: $("#fragmentshader").text()
});

var plane = new THREE.Mesh(
		new THREE.CubeGeometry(1, 1, 1),
		planeMaterial);

plane.position.x = 0.5;
plane.position.y = 0.5;

scene.add(plane);

// and the camera
scene.add(camera);

// draw!
renderer.render(scene, camera);
