int offset;
float seconds_rotation, minutes_rotation, hours_rotation, days_rotation;

void setup() {
    size(800, 400);
    background(255);
    update();
    int start = second();
    while (second() == start) {
        offset = millis();
    }
}

void draw() {
    background(255);
    
    fill(20, 100, 250, 150);
    ellipse(width / 4, height / 2, width / 3, width / 3);
    fill(0);
    ellipse(width / 4 + ((width / 6) * cos(seconds_rotation)),
            height / 2 + ((width / 6) * sin(seconds_rotation)), 10, 10);

    fill(40, 80, 250, 150);
    ellipse(2 * width / 4, height / 2, width / 3, width / 3);
    fill(0);
    ellipse(2 * width / 4 + ((width / 6) * cos(minutes_rotation)),
            height / 2 + ((width / 6) * sin(minutes_rotation)), 10, 10);
            
    fill(60, 60, 250, 150);
    ellipse(3 * width / 4, height / 2, width / 3, width / 3);
    fill(0);
    ellipse(3 * width / 4 + ((width / 6) * cos(hours_rotation)),
            height / 2 + ((width / 6) * sin(hours_rotation)), 10, 10);

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

