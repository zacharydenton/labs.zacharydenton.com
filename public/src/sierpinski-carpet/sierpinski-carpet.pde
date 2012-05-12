void setup() {
    size(500, 500);
    background(0);
    noLoop();
    sierpinski_carpet(0, 0, width, height, 5);
}

void sierpinski_carpet(float x0, float y0, float x1, float y1, int iterations) {
    if (iterations == 0) {
        return;
    }
    float w = (x1 - x0) / 3.0f;
    float h = (y1 - y0) / 3.0f;
    
    fill(255);
    stroke(255);
    rect(x0 + w, y0 + h, w, h);
    for (int i = 0; i < 9; i++) {    
        sierpinski_carpet(x0 + ((i%3) * w), y0 + (int(i/3) * h),
            x0 + ((i%3 + 1) * w), y0 + ((int(i/3) + 1) * h),
            iterations-1);
    }
}

