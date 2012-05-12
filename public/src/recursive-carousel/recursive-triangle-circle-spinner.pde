// This sketch is a re-creation of a prior work, "Triangle-Circle Recursion", by (Unnamed author): http://studio.sketchpad.cc/sp/pad/view/ro.9QmpG6paz8zzJ/rev.0

int rotation = 0;

void setup() {
    size(400, 400);
    background(230);
    noStroke();
}

void draw() {
    tricircle(width/2, height/2, 19*(width/40), rotation, 200);
    rotation++;
}

void tricircle(x, y, radius, rotation, shade) {
    if (shade > 40) {
        fill(shade);
        ellipse(x, y, 2*radius, 2*radius);
        for (int i=0; i < 3; i++) {
            x_offset = (radius*sin(2*i*(PI/3)+radians(rotation))) * .534;
            y_offset = -(radius*cos(2*i*(PI/3)+radians(rotation))) * .534;
            chord = sqrt(2*(sq(x_offset) + sq(y_offset)) * (1-cos(2*(PI/3))));
            tricircle(x + x_offset, y + y_offset, chord / 2, rotation, shade - 30);
        }
    }
}

