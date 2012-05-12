int gridWidth;
int gridHeight;
int cellWidth;
int[][] grid;
color alive = color(random(50), random(255), random(255), 150);
color dead = color(240, 110);
int lastTime = 0;
boolean active = true;
 
void setup() {
    background(240);
    size(400, 400);
    smooth();
    noStroke();
    reset();
    
    cellWidth = 15;
    gridWidth = round(width / cellWidth);
    gridHeight = round(height / cellWidth);
    grid = new int[gridHeight][gridWidth];

    // f-pentomino
    int xcenter = round((gridWidth / 2)) - 1;
    int ycenter = round((gridHeight / 2)) - 1;
    grid[ycenter][xcenter] = 1;
    grid[ycenter+1][xcenter] = 1;
    grid[ycenter-1][xcenter] = 1;
    grid[ycenter-1][xcenter+1] = 1;
    grid[ycenter][xcenter-1] = 1;
}
 
void update() {     
    int[][] next_grid = new int[gridHeight][gridWidth];
    for (int y=0; y < gridHeight; y++) {
        for (int x=0; x < gridWidth; x++) {
            next_grid[y][x] = life(x, y); 
        }
    }
    arrayCopy(next_grid, grid);
}
 
void reset() {
    for (y=0; y < gridHeight; y++) {
        for (x=0; x < gridWidth; x++) {
            grid[y][x] = 0;
        }
    }
}
 
void draw() {      
    
    if (mousePressed && mouseButton == LEFT) {
        mousePressed();
    }    
   
    int currentTime = millis();    
    if ((currentTime > lastTime + 10) && active) {
        update();
        lastTime = currentTime;
    }
    
    for (int y=0; y < gridHeight; y++) {
        for (int x=0; x < gridWidth; x++) {
            if (grid[y][x] >= 1) {
                strokeWeight(2);
                fill(alive);
                stroke(alive);            
                ellipse(x * cellWidth + (cellWidth / 2), y * cellWidth + (cellWidth / 2), floor(cellWidth/2)-1, floor(cellWidth/2)-1);
            } else {
                fill(dead);
        stroke(dead);
                rect(x * cellWidth, y * cellWidth, cellWidth, cellWidth);
            }
        }
    }
}
 
int life(x, y) {
    cell = grid[y][x];
    neighbors = get_neighbors(x, y);
    if (cell >= 1) {
        if (neighbors.size() < 2) {
            return 0;
        } else if ((neighbors.size() == 2) || (neighbors.size() == 3)) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (neighbors.size() == 3) {
            return 1;
        } else {
            return 0;
        }
    }    
}
 
ArrayList get_neighbors(x, y) {
    neighbors = new ArrayList();
    for (dx = -1; dx <= 1; dx++) {
        for (dy = -1; dy <= 1; dy++) {
            x_query = x + dx;
            if (x_query < 0) {
                // wrap around to other side
                x_query = gridWidth - 1;
            } else if (x_query >= gridWidth) {
                x_query = 0;
            }
            y_query = y + dy;            
            if (y_query < 0) {
                // wrap around to other side
                y_query = gridHeight - 1;
            } else if (y_query >= gridHeight) {
                y_query = 0;
            }
            
            if (x_query == x && y_query == y) {
                continue;
            }
            
            if (grid[y_query][x_query] >= 1) {
                neighbors.add(grid[y_query][x_query]);
            }
        }
    }
    return neighbors;
}
 
void mousePressed() {
    if (mouseButton == LEFT) {
        x = int(mouseX / cellWidth);
        y = int(mouseY / cellWidth);
        if (grid[y][x] == 0) {            
            grid[y][x] = 1;
        } else {
            grid[y][x] = 0;
        }
    } else if (mouseButton == CENTER) {
        reset();
    } else {
        active = !active;
    }
}

