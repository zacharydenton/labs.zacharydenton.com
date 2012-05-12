float modifier = 0;
void setup() {
    size(500, 500);
}

void draw() {
    background(0);
    modifier += (mouseX - (width / 2)) / width * TWO_PI;

    for (int i = 0; i < 30; i++) {
        float angle = float(i) * TWO_PI / 30 + modifier / 20;
        float velocity = width / 20;
        float radius = width / 50;
        for (int j = 0; j <= 20; j++) {
            float x = width / 2 + cos(angle) * velocity * j;
            float y = height / 2 + sin(angle) * velocity * j;
            fill(lerpColor(color(0), color(255), 1 - (i/31)*j));
            ellipse(x, y, radius, radius);
        }
    }
}

