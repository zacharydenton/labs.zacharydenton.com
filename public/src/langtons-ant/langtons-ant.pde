int[][] grid;
int[] ant;
int cell_width = 8;
int grid_width, grid_height;
float direction = HALF_PI;

void setup() {
    background(0);
    size(952, 392);
    grid_width = width / cell_width;
    grid_height = height / cell_width;
    grid = new int[grid_width][grid_height];
    ant = [round(grid_width / 2), round(grid_height / 2)];
} 

void draw() {
    if (grid[ant[0]][ant[1]] == 0) {
        direction += HALF_PI;
        grid[ant[0]][ant[1]] = 1;    
        fill(random(40), random(255), random(240));
    } else {
        direction -= HALF_PI;
        grid[ant[0]][ant[1]] = 0;
        fill(0);
    }
    rect(ant[0]*cell_width, ant[1]*cell_width, cell_width, cell_width);
    ant[0] += round(cos(direction));
    ant[1] += round(sin(direction));
}

