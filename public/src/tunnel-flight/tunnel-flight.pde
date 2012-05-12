// This sketch builds on a prior work, "Improved 1D Terrain Generator", created by Zach Denton & [unnamed author]
// http://studio.sketchpad.cc/sp/pad/view/ro.9jhhBxbQyXS3v/rev.318



// This sketch builds on a prior work, "1D Terrain Generator", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9h-trdKTEvmpK/rev.908

float offset = 0;
float player_x, player_y, player_vy, player_ay, player_size, terminal_velocity, difficulty;

void setup() {
    size(600, 300); 
    background(255);
    smooth();
    restart();
    terminal_velocity = height / 100;
}

void restart() {
    player_x = width / 16;
    player_y = height / 2;
    player_vy = 0;
    player_ay = 0;
    player_size = width / 32;
    offset = 0;
    difficulty = 0;
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
    if (offset % 0.5 == 0) {
        difficulty += height / 64;
    }
    
    beginShape();
    vertex(0, height);
    for (int i = 0; i < terrain.length; i++) {
        vertex(i * (width / terrain.length), (height / 2) + terrain[i] - difficulty);
    }
    vertex(width, height);
    endShape();
    
    beginShape();
    vertex(0, 0);
    for (int i = 0; i < terrain.length; i++) {
        vertex(i * (width / terrain.length), terrain[i] + difficulty);
    }
    vertex(width, 0);
    endShape();
    
    if (mousePressed) {
        player_ay = -height / 1500;
    } else {
       player_ay = height / 1500;
    }
    player_vy += player_ay;
    player_vy = constrain(player_vy, -terminal_velocity, terminal_velocity);
    player_y += player_vy;
    
    if (player_y - (player_size / 2) < terrain[int(player_x)] || player_y + (player_size / 2) > height / 2 + terrain[int(player_x)]) {
        restart();
    }
    
    fill(255);
    stroke(255);
    ellipse(player_x, player_y, player_size, player_size);
}

float[] generate_terrain(int resolution, float scale, float multiplier, float offset) {
    terrain = new float[resolution];
    for (int i = 0; i < resolution; i++) {
        terrain[i] = multiplier * noise(i * scale + offset);
    }
    return terrain;
}

