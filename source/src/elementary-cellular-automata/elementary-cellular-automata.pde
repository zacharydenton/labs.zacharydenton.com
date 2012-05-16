// This sketch builds on a prior work, "Rule 60", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9$MiAZ1nc5KQ4/rev.232



// This sketch builds on a prior work, "Rule 30", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9Nj22284D2KUu/rev.1512



// This sketch builds on a prior work, "Undulating Pixel Grid", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9lU9zD6n-JpSi/rev.366

// See also: http://en.wikipedia.org/wiki/Rule_30

int RULE = 0;
int width = 100;
int height = 100;
int cell_width = 5;
int[][] grid = new int[height][width];
color alive = color(random(50), random(255), random(255), 100);
color dead = color(200);
int lastTime = 0;

void setup() {
    background(dead);
    // size(width * cell_width, height * cell_width); 
    size(500, 500);
    smooth();
    noStroke();
    reset();
    grid[0][(width / 2) - 1] = 1;
    update();
}

void update() {     
    for (int y=0; y < height; y++) {
        for (int x=0; x < width; x++) {
            if (x > 0) {
                left = grid[y][x-1];
                if (left > 1) {
                    left = 1;
                }
            } else {
                left = 0;
            }
            
            if (x < width - 1) {
                right = grid[y][x+1];
                if (right > 1) {
                    right = 1;
                }
            } else {
                right = 0;
            }
            
            center = grid[y][x];
                    
            pattern = str(left) + str(center) + str(right);
            
            next = elementary_cellular_automaton(RULE, pattern);
            
            if (y < height - 1) {
                grid[y+1][x] = next;
            }
        }
    }
}

void reset() {
    for (y=0; y < height; y++) {
        for (x=0; x < width; x++) {
            grid[y][x] = 0;
        }
    }
}

void draw() {          
    if (mousePressed == true) {
        mousePressed();
    }
    
    int currentTime = millis();
    
    if (currentTime > lastTime + 1000) {
        RULE++;
        if (RULE >= 256) {
            RULE = 0;
        }
        reset();
        grid[0][(width / 2) - 1] = 1;
        update();
        lastTime = currentTime;
    }
    
    for (int y=0; y < height; y++) {
        for (int x=0; x < width; x++) {
            if (grid[y][x] >= 1) {
                strokeWeight(2);
                fill(255);
                stroke(alive);            
            } else {
                noStroke();
                fill(dead);
            }
            rect(x * cell_width, y * cell_width, cell_width, cell_width);

        }
    }
}

int elementary_cellular_automaton(rule_number, pattern) {
    rule = binary(rule_number, 8);
    return rule[7 - unbinary("00000" + pattern)];
}

void mousePressed() {
    if (mouseButton == LEFT) {
        x = int(mouseX / cell_width);
        y = int(mouseY / cell_width);
        if (grid[y][x] == 0) {            
            grid[y][x] = 1;
        } else {
            grid[y][x] = 0;
        }
    } else if (mouseButton == CENTER) {
        reset();
    } else {
        update();
    }
}


