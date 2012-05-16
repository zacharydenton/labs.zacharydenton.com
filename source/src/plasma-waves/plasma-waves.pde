float scale=0.002;
int t = 0;
int period = 2000;
float[][] noise_table;

void setup() {
    size(300, 300);
    noise_table = new float[width][height];
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            noise_table[x][y] = noise(x*scale, y*scale);
        }
    }
}

void draw() {
    int f = t % period;
    loadPixels();
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            pixels[y*width+x]=color(0, 255*abs(sin(noise_table[x][y]*f)), random(255));
        }
    }
    updatePixels();
    t++;
}

