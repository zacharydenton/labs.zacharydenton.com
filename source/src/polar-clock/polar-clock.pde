// This sketch builds on a prior work, "Circle Clock", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9ycIBH2Dnam3l/rev.942
int offset;
float seconds, minutes, hours;
float seconds_rotation, minutes_rotation, hours_rotation;
PFont font;

void setup() {
    size(600, 600);
    smooth();
    background(0);
    fill(0);
    update();
    
    int start = second();
    while (second() == start) {
        offset = millis();
    }
    font = loadFont("Arial");
    textSize(height / 16);
}
void draw() {
    background(0);
    
    noFill();
    stroke(lerpColor(color(0, 255, 0), color(0, 0, 255), (seconds / 60)));
    strokeWeight(width / 64);
    arc(width / 2, height / 2,
        15 * (width / 16), 15 * (width / 16),
        -HALF_PI, seconds_rotation);
        
    stroke(lerpColor(color(0, 0, 255), color(255, 0, 0), (minutes / 60)));
    strokeWeight(width / 32);
    arc(width / 2, height / 2,
        27 * (width / 32), 27 * (width / 32),
        -HALF_PI, minutes_rotation);
        
    stroke(lerpColor(color(255, 0, 0), color(0, 255, 0), (minutes / 60)));
    strokeWeight(width / 16);
    arc(width / 2, height / 2,
        11 * (width / 16), 11 * (width / 16),
        -HALF_PI, hours_rotation);
        
    fill(255);
    textFont(font); 
    String s = join([int(hours), nf(int(minutes), 2), nf(int(seconds), 2)], ":");
    text(s, width / 2, (height / 2) - (height / 32), width / 4, width / 8);
    update();
}

void update() {
    seconds = second() + ((millis() - offset) % 1000 / 1000);
    seconds_rotation = (seconds / 60) * TWO_PI - HALF_PI;
    
    minutes = minute();
    if (seconds < 60) minutes += (seconds / 60);
    minutes_rotation = (minutes / 60) * TWO_PI - HALF_PI;
    
    hours = (hour() % 12) + (minutes / 60);
    hours_rotation = (hours / 12) * TWO_PI - HALF_PI;
}

