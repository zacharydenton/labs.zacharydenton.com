int t = 0;
int f = 100;
float scale=0.002;
int[] plasma;
color palette[];
void setup() {
    size(952, 392);
    smooth();
    
    colorMode(HSB);
    palette = new color[256];
    for (int i = 0; i < 256; i++) {
        palette[i] = color(i, 255, 255);
    }
    
    plasma = new int[width*height];
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            plasma[y*width+x] = int(255*abs(sin(noise(x*scale, y*scale)*f)));
        }
    }
}
void draw() {
    loadPixels();
    for (int i = 0; i < plasma.length; i++) {
        pixels[i] = palette[(plasma[i] + t) % 256];
    }
    updatePixels();
    t++;
}

