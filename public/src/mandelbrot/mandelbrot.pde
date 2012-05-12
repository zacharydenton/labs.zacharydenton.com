double min_real, max_real, min_imag, max_imag, real_factor, imag_factor;
int iterations = 50;
double zoom_factor = 2;
color bg = color(0);
void setup() {
	size(952, 392);
	noLoop();
	set_bounds(-3.5, 2.1, -1.15);
	colorMode(HSB, 1.0);
}
void draw() {
	background(bg);
	loadPixels();
	for (int x=0; x < width; x++) {
		double c_real = min_real + x * real_factor;
		for (int y=0; y < height; y++) {
			double c_imag = max_imag - y * imag_factor;
			double z_real = c_real, z_imag = c_imag;
			boolean inside = false;
			for (int i = 0; i < iterations; i++) {
				double z_real2 = z_real * z_real;
				double z_imag2 = z_imag * z_imag;
				if (z_real2 + z_imag2 >= 4) {
					inside = true;
					break;
				}
				z_imag = 2 * z_real * z_imag + c_imag;
				z_real = z_real2 - z_imag2 + c_real;
			}
			if (inside) {
				pixels[y*width+x] = color(float(i) / iterations, 1.0, 1.0);
			} else {
				pixels[y*width+x] = bg;
			}
		}
	}
	updatePixels();
}
void set_bounds(double min_r, double max_r, double min_i) {
	min_real = min_r;
	max_real = max_r;
	min_imag = min_i;
	max_imag = min_imag + (max_real - min_real) * (height / width);
	real_factor = (max_real - min_real) / (width - 1);
	imag_factor = (max_imag - min_imag) / (height - 1);
}
void mousePressed() {   
	double c_real = min_real + mouseX * real_factor;
	double c_imag = max_imag - mouseY * imag_factor;
	double span_real = max_real - min_real;
	double span_imag = max_imag - min_imag;
	if (mouseButton == LEFT) {
		set_bounds(c_real - 0.5 * span_real / zoom_factor, 
				c_real + 0.5 * span_real / zoom_factor, 
				c_imag - 0.5 * span_imag / zoom_factor);
		iterations += 5;
	} 
	else if (mouseButton == RIGHT) {
		set_bounds(c_real - 0.5 * span_real * zoom_factor, 
				c_real + 0.5 * span_real * zoom_factor, 
				c_imag - 0.5 * span_imag * zoom_factor);
		iterations -= 5;
	} 
	else {
		set_bounds(-2.1, 0.8, -1.45);
		iterations = 50;
	}
	draw();
}

