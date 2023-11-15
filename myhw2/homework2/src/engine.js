let precomputeLT = [];
let precomputeL = [];
var cameraPosition = [50, 0, 100];

var envmap = [
	'assets/cubemap/GraceCathedral',
	'assets/cubemap/Indoor',
	'assets/cubemap/Skybox',
];

var guiParams = {
	envmapId: 0
}

var cubeMaps = [];

//生成的纹理的分辨率，纹理必须是标准的尺寸 256*256 1024*1024  2048*2048
var resolution = 2048;

let envMapPass = null;

GAMES202Main();

async function GAMES202Main() {
	// Init canvas and gl
	const canvas = document.querySelector('#glcanvas');
	canvas.width = window.screen.width;
	canvas.height = window.screen.height;
	const gl = canvas.getContext('webgl');
	if (!gl) {
		alert('Unable to initialize WebGL. Your browser or machine may not support it.');
		return;
	}

	// Add camera
	const camera = new THREE.PerspectiveCamera(75, gl.canvas.clientWidth / gl.canvas.clientHeight, 1e-2, 1000);
	camera.position.set(cameraPosition[0], cameraPosition[1], cameraPosition[2]);

	// Add resize listener
	function setSize(width, height) {
		camera.aspect = width / height;
		camera.updateProjectionMatrix();
	}
	setSize(canvas.clientWidth, canvas.clientHeight);
	window.addEventListener('resize', () => setSize(canvas.clientWidth, canvas.clientHeight));

	// Add camera control
	const cameraControls = new THREE.OrbitControls(camera, canvas);
	cameraControls.enableZoom = true;
	cameraControls.enableRotate = true;
	cameraControls.enablePan = true;
	cameraControls.rotateSpeed = 0.3;
	cameraControls.zoomSpeed = 1.0;
	cameraControls.panSpeed = 0.8;
	cameraControls.target.set(0, 0, 0);

	// Add renderer
	const renderer = new WebGLRenderer(gl, camera);

	// Add lights
	// light - is open shadow map == false
	let lightPos = [0, 10000, 0];
	let lightRadiance = [1, 0, 0];
	const pointLight = new PointLight(lightRadiance, lightPos, false, renderer.gl);
	renderer.addLight(pointLight);

	// Add shapes
	let skyBoxTransform = setTransform(0, 50, 50, 150, 150, 150);
	let boxTransform = setTransform(0, 0, 0, 200, 200, 200);
	let box2Transform = setTransform(0, -10, 0, 20, 20, 20);

	for (let i = 0; i < envmap.length; i++) {
		let urls = [
			envmap[i] + '/posx.jpg',
			envmap[i] + '/negx.jpg',
			envmap[i] + '/posy.jpg',
			envmap[i] + '/negy.jpg',
			envmap[i] + '/posz.jpg',
			envmap[i] + '/negz.jpg',
		];
		cubeMaps.push(new CubeTexture(gl, urls))
		await cubeMaps[i].init();
	}
	// load skybox
	loadOBJ(renderer, 'assets/testObj/', 'testObj', 'SkyBoxMaterial', skyBoxTransform);

	// file parsing
	for (let i = 0; i < envmap.length; i++) {
		let val = '';
		await this.loadShaderFile(envmap[i] + "/transport.txt").then(result => {
			console.log("transport");
			console.log(result);
			val = result;
		});
		//按照行划分
		let preArray = val.split(/[(\r\n)\r\n' ']+/);
		let lineArray = [];
		precomputeLT[i] = []
		//因为第一行放的是顶点个数，所以从第二行开始
		//j是遍历顶点数
		//precomputeLT[i]是一个顶点数*9的矩阵
		for (let j = 1; j <= Number(preArray.length) - 2; j++) {
			precomputeLT[i][j - 1] = Number(preArray[j])
		}
		await this.loadShaderFile(envmap[i] + "/light.txt").then(result => {
			val = result;
		});
		//precomputeL
		//\r回车\n换行
		//按照行换分得到数组
		precomputeL[i] = val.split(/[(\r\n)\r\n]+/);
		//删除第一行
		precomputeL[i].pop();
		for (let j = 0; j < 9; j++) {
			//第i种环境光下的第j行
			lineArray = precomputeL[i][j].split(' ');
			for (let k = 0; k < 3; k++) {
				//字符串转为整数
				lineArray[k] = Number(lineArray[k]);
			}
			//每行有三个SH系数
			precomputeL[i][j] = lineArray;
		}
		//precomputeL[i]是一个9*3的矩阵
	}

	// TODO: load model - Add your Material here
	// loadOBJ(renderer, 'assets/bunny/', 'bunny', 'addYourPRTMaterial', boxTransform);
	// loadOBJ(renderer, 'assets/bunny/', 'bunny', 'SkyBoxMaterial', box2Transform);
	loadOBJ(renderer, 'assets/mary/', 'mary', 'PRTMaterial', box2Transform);

	function createGUI() {
		const gui = new dat.gui.GUI();
		const panelModel = gui.addFolder('Switch Environemtn Map');
		panelModel.add(guiParams, 'envmapId', { 'GraceGathedral': 0, 'Indoor': 1, 'Skybox': 2 }).name('Envmap Name');
		panelModel.open();
	}

	createGUI();

	function mainLoop(now) {
		//就硬塞 但是卡
		// loadOBJ(renderer, 'assets/mary/', 'mary', 'PRTMaterial', box2Transform);

		cameraControls.update();

		renderer.render();

		requestAnimationFrame(mainLoop);
	}
	requestAnimationFrame(mainLoop);
}

function setTransform(t_x, t_y, t_z, s_x, s_y, s_z) {
	return {
		modelTransX: t_x,
		modelTransY: t_y,
		modelTransZ: t_z,
		modelScaleX: s_x,
		modelScaleY: s_y,
		modelScaleZ: s_z,
	};
}