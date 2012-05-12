Ship player;
ArrayList boxes;
ArrayList walls;      
float boxIncidence;
int lastTime = 0;
int lastWall = 0;
int lastScore = 0;
int wallWidth;
int wallSize = 50;
float speed;
float keyX = 0.8;
float keyZ = 0.9;
float friction = 0.3;
float cameraRotation;
float boxStart = -1000;
float nearClipping = 500;
int score;
PFont font = loadFont("Tahoma");
int SPACE = 32; // spacebar
                
void setup() {
    size(640, 480, OPENGL);    
        
    background(0);
    fill(200);
    pushMatrix();
    translate(-2*width, 3*(height/4)+25, boxStart);
    rotateX(radians(90));
    rect(0, 0, 5*width, -2*boxStart);
    popMatrix();
    
    lights();
    
    reset();
}

void reset() {
    player = new Ship(new PVector(width/2, 3*(height/4)+25, 200));
    boxes = new ArrayList();
    walls = new ArrayList();
    wallWidth = width;
    score = 0;
    boxIncidence = 0.05;
    speed = 10;
    cameraRotation = 0;
}

void draw() {
    background(0);
    
    cameraZ = (height/2.0) / tan(PI*60.0 / 360.0);
    beginCamera();
    camera(width/2.0, height/2.0, cameraZ, width/2.0, 3*(height/4.0), 0, 0, 1, 0);
    rotateZ(radians(cameraRotation));
    endCamera();
    perspective(PI/3, width/height, cameraZ/10.0, cameraZ*10.0);
    
    fill(200);
    pushMatrix();
    translate(-2*width, 3*(height/4)+25, boxStart);
    rotateX(radians(90));
    rect(0, 0, 5*width, -2*boxStart);
    popMatrix();
    
    lights();

    if (player.alive) {
        player.draw();
    } else {
        playerDied();
    }

    for (int i = 0; i < boxes.size(); i++) {
        Box box = (Box) boxes.get(i);  
        if (box.alive) {
            box.draw();
        }
    }
    for (int i = 0; i < walls.size(); i++) {
        Box box = (Box) walls.get(i);  
        if (box.alive) {
            box.draw();
        }
    }
    
    int currentTime = millis();
    if (currentTime > lastTime + 30) {
        update();
        lastTime = currentTime;
    }
    
    makeWalls();    

}

void makeWalls() {
    int currentWall = millis();
    if (currentWall > lastWall + 200) {
        walls.add(new Box(new PVector((width/2)-(wallWidth/2) - (wallSize/2), 3 * (height / 4) + 10, boxStart)));
        walls.add(new Box(new PVector((width/2) + (wallWidth/2) + (wallSize/2), 3 * (height / 4) + 10, boxStart)));
        lastWall = currentWall;
    }    
}

void update() {
    if (player.alive) {
        player.update();
        incrementScore();
    } 
    
    
    
    if (keyPressed) {
    if (keyCode == LEFT || key == 'a') {
        cameraRotation = constrain(cameraRotation += 0.2, 0, 10);
    }
    if (keyCode == RIGHT || key == 'd') {
        cameraRotation = constrain(cameraRotation -= 0.2, -10, 0);
    }
    } else {
        if (cameraRotation > 0) {
            cameraRotation -= 1.5;
            if (cameraRotation < 0) {
                cameraRotation = 0;
            }
        } else {
            cameraRotation += 1.5;
            if (cameraRotation > 0) {
                cameraRotation = 0;
            }
        }
    }
    
    if (random(1) < boxIncidence) {
        boxes.add(new Box(new PVector(random(0, width), 3 * (height / 4) + 10, boxStart)));
    }
    for (int i = 0; i < boxes.size(); i++) {
        Box box = (Box) boxes.get(i);  
        if (box.alive) {
            box.update();
        } else {
            boxes.remove(i);
        }
    }
    for (int i = 0; i < walls.size(); i++) {
        Box box = (Box) walls.get(i);  
        if (box.alive) {
            box.update();
        } else {
            walls.remove(i);
        }
    }
}

void playerDied() {
  fill(255, 20, 0);
  String notice;
  if (score == 1) {
    notice = "You scored " + score + " point.";
  } 
  else {
    notice = "You scored " + score + " points.";
  }
 
  pushMatrix();
  translate(0, 0, 200);
  textAlign(CENTER);
  textFont(font, 24);
  text(notice, width/2, 3*(height/4)-48);
  textFont(font, 18);
  text("Press the Spacebar to restart.", width/2, 3*(height/4)-24);
  popMatrix();
  noFill();
}

void incrementScore() {
    int currentScore = millis();
    if (currentScore > lastScore + 1000) {
        score++;
        lastScore = currentScore;
        if (score % 10 == 0) {
            boxIncidence += 0.01;
            speed += 1.0;
        }
    }
}

void keyPressed() {
  if (keyCode == SPACE) {
    reset();
  }
    player.keyPressed();
}

void keyReleased() {
    player.keyReleased();
}

class Ship {
    PVector position, velocity, acceleration;
    boolean alive;
    
    Ship(PVector p) {
        position = p;
        velocity = new PVector();
        acceleration = new PVector();
        alive = true;
    }
    
    void draw() {        
        stroke(0);
        beginShape(TRIANGLES);
            vertex(position.x - 10, position.y, position.z + 10);
            vertex(position.x + 10, position.y, position.z + 10);
            vertex(position.x,  position.y - 10, position.z);
            
            vertex(position.x, position.y, position.z - 20);
            vertex(position.x,  position.y - 10, position.z);
            vertex(position.x - 10, position.y, position.z + 10);

            vertex(position.x + 10, position.y, position.z + 10);
            vertex(position.x,  position.y - 10, position.z);
            vertex(position.x, position.y, position.z - 20);
        endShape();
    }
    
    void update() {
        velocity.add(acceleration);
        position.add(velocity);
        if (outOfBounds()) {
            alive = false;
        }
        if (velocity.x > 0) {
            velocity.x -= friction;
            if (velocity.x < 0) {
                velocity.x = 0;
            }
        }
        if (velocity.x < 0) {
            velocity.x += friction;
            if (velocity.x > 0) {
                velocity.x = 0;
            }
        }
    }
    
    boolean outOfBounds() {
        if (position.x > (width/2) + (wallWidth/2) + (wallSize/2) ||
            position.x < (width/2) - (wallWidth/2) - (wallSize/2)) {
                return true;
        }
        return false;
    }
    
    void keyPressed() {
    if (keyCode == LEFT || key == 'a') {
      acceleration.x = -keyX;
    }
    if (keyCode == RIGHT || key == 'd') {
      acceleration.x = keyX;
    }
  }
 
  void keyReleased() {
    if (keyCode == RIGHT || keyCode == LEFT || key == 'a' || key == 'd') {
      acceleration.x = 0;
    }
  }
}

class Box {
    PVector position, velocity;
    int size = 40;
    boolean alive = true;
    color boxColor = color(random(50), random(200), random(255));
    
    Box(PVector p) {
        position = p;
        velocity = new PVector(0, 0, speed);
    }
    
    void draw() {
        noStroke();
        fill(boxColor);
        pushMatrix();
        translate(position.x, position.y, position.z);
        sphere(size);
        popMatrix();
    }
    
    boolean collision() {
        if (position.dist(player.position) <= size) { 
            return true;
        }
        return false;
    }
    
    void update() {
        velocity.z = speed;
        position.add(velocity);
        if (collision()) {
            player.alive = false;
        }
        if (position.z > nearClipping) {
            alive = false;
        }
    }
}

