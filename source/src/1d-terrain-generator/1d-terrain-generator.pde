// This sketch builds on a prior work, "1D Terrain Generator", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9h-trdKTEvmpK/rev.908

float offset = 0;

void setup() {
    size(600, 300); 
    background(255);
    smooth();
}
void draw() {
    colorMode(HSB);
    // gradient background
    for (int i = 0; i < height; i++) {
        stroke(65, 40, ((i * 100) / height));
        line(0, i, width, i);
    }
    
    colorMode(RGB);
    stroke(0, 255, 0);
    fill(0, 255, 0);
    
    float[] terrain = generate_terrain(width, 0.007, width / 4, offset);
    offset += 0.01;
    
    beginShape();
    vertex(0, height);
    for (int i = 0; i < terrain.length; i++) {
        vertex(i * (width / terrain.length), (height / 2) + terrain[i]);
    }
    vertex(width, height);
    endShape();
    
}

float[] generate_terrain(int resolution, float scale, float multiplier, float offset) {
    terrain = new float[resolution];
    for (int i = 0; i < resolution; i++) {
        terrain[i] = multiplier * noise(i * scale + offset);
    }
    return terrain;
}

