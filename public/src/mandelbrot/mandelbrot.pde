double min_real, max_real, min_imag, max_imag, real_factor, imag_factor;
int iterations = 200;
int current_max;
double zoom_factor = 2;
double bailout = 32;
color bg = color(0);
int t = 0;

color[] palette;
int[] mandelbrot;
int[] ranks;
float[] fractal;
int N;

void setup() {
  size(952, 392);
  noLoop();
  set_bounds(-3.5, 2.1, -1.15);
  
  // build palette
  palette = new color[1000];
  /*
  for (int i = 0; i < 250; i++)
    palette[i] = lerpColor(color(255), color(0, 0, 255), float(i) / 250.0);
  for (int i = 0; i < 250; i++)
    palette[250+i] = lerpColor(color(0, 0, 255), color(0, 255, 0), float(i) / 250.0);
  for (int i = 0; i < 250; i++)
    palette[500+i] = lerpColor(color(0, 255, 0), color(0, 0, 255), float(i) / 250.0);
  for (int i = 0; i < 250; i++)
    palette[750+i] = lerpColor(color(0, 0, 255), color(255), float(i) / 250.0);
    */
  for (int i = 0; i < 500; i++)
    palette[i] = lerpColor(color(0), color(0, 0, 255), float(i) / 500.0);
  for (int i = 0; i < 450; i++)
    palette[500+i] = lerpColor(color(0, 0, 255), color(0, 255, 255), float(i) / 450);
  for (int i = 0; i < 50; i++)
    palette[950+i] = lerpColor(color(0, 255, 255), color(255), float(i) / 50);

  mandelbrot = new int[width*height];
  recalc();
}

void draw() {
  background(bg);
  loadPixels();

  for (int i = 0; i < mandelbrot.length; i++) {
    if (mandelbrot[i] > 0)
      pixels[i] = palette[int(fractal[mandelbrot[i]] * 1000)];
  }

  updatePixels();
  t++;
}

void recalc() {
  current_max = 1;
  N = 0;
  for (int x=0; x < width; x++) {
    double c_real = min_real + x * real_factor;
    for (int y=0; y < height; y++) {
      mandelbrot[y*width+x] = 0;
      double c_imag = max_imag - y * imag_factor;
      double z_real = c_real, z_imag = c_imag;
      boolean escaped = false;
      for (int i = 0; i < iterations; i++) {
        double z_real2 = z_real * z_real;
        double z_imag2 = z_imag * z_imag;
        if (z_real2 + z_imag2 >= bailout) {
          escaped = true;
          break;
        }
        z_imag = 2 * z_real * z_imag + c_imag;
        z_real = z_real2 - z_imag2 + c_real;
      }
      if (escaped) {
        N++;
        mandelbrot[y*width+x] = i;
        if (i > current_max)
          current_max = i;
      }
    }
  }
  ranks = new int[N];
  for (int i = 0; i < mandelbrot.length; i++)
    if (mandelbrot[i] > 0)
      ranks[i] = mandelbrot[i];
  ranks = sort(ranks);
  fractal = new float[current_max];
  for (int i = 0; i < ranks.length; i++) {
    int iters = ranks[i];
    float u = float(i) / float(ranks.length);
    fractal[iters] = u;

    // skip ahead
    while (i < ranks.length - 1 && ranks[i+1] == iters)
      i++;
  }
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
  recalc();
  redraw();
}

void keyPressed() {
  if (key == ' ') {
    iterations *= 2;
    bailout *= 2;
    recalc();
    redraw();
  }
}
