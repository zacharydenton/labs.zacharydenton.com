// This sketch builds on a prior work, "Life", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9$ub3on2LVdKw/rev.386

int[][] grid;
color alive = color(random(50), random(255), random(255));
color dead = color(0);
int lastTime = 0;
boolean active = true;

void setup() {
    size(300, 300);
    background(dead);
    smooth();
    noStroke();
    
    grid = new int[height][width];
    reset();

    int xcenter = (width / 2) - 1;
    int ycenter = (height / 2) - 1;
    grid[xcenter][ycenter] = 1;
}

void update() {     
    int[][] next_grid = new int[height][width];
    for (int x=0; x < width; x++) {
        for (int y=0; y < height; y++) {
            next_grid[x][y] = b1s12(x, y); 
        }
    }
    arrayCopy(next_grid, grid);
}

void reset() {
    for (int x=0; x < width; x++) {
        for (int y=0; y < height; y++) {
            grid[x][y] = 0;
        }
    }
}

void draw() {     
    loadPixels();     
    for (int x=0; x < width; x++) {
        for (int y=0; y < width; y++) {
            if (grid[x][y] >= 1) {
                pixels[y*width+x] = alive;
            } else {
                pixels[y*width+x] = dead;
            }
        }
    }
    updatePixels();
    update();
}

int b1s12(int x, int y) {
    int cell = grid[x][y];
    ArrayList neighbors = get_neighbors(x, y);
    if (cell >= 1) {
        if ((neighbors.size() == 1) || (neighbors.size() == 2)) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (neighbors.size() == 1) {
            return 1;
        } else {
            return 0;
        }
    }    
}

ArrayList get_neighbors(int x, int y) {
    ArrayList neighbors = new ArrayList();
    for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
            int x_query = x + dx;
            if (x_query < 0) {
                // wrap around to other side
                x_query = width - 1;
            } else if (x_query >= width) {
                x_query = 0;
            }
            int y_query = y + dy;            
            if (y_query < 0) {
                // wrap around to other side
                y_query = height - 1;
            } else if (y_query >= height) {
                y_query = 0;
            }
            
            if (x_query == x && y_query == y) {
                continue;
            }
            
            if (grid[x_query][y_query] >= 1) {
                neighbors.add(grid[x_query][y_query]);
            }
        }
    }
    return neighbors;
}

