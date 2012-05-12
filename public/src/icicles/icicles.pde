// Pressing Control-R will render this sketch.
float gravity = 0.8;
float keyX = 0.5;
float keyY = 0.5;
float damping = 5;
float friction = 0.2;
float maxVelocity = 20.0;
float icicleIncidence;
int lastTime = 0;
int score = 0;
Player player;
ArrayList icicles;
PFont font = loadFont("Tahoma");
int SPACE = 32; // spacebar

void setup() {
  size(640, 480);
  background(255); 
  stroke(0);
  smooth();

  score = 0;
  player = new Player(new PVector(width/2, height - 20), 30);
  icicles = new ArrayList();
  icicleIncidence = 0.02;
}
void draw() { 
  background(255);
  if (player.alive) {
    player.draw();
  } 
  else {
    playerDied();
  }
  for (int i = 0; i < icicles.size(); i++) {
    Icicle icicle = (Icicle) icicles.get(i);  
    icicle.draw();
  }
  int currentTime = millis();
  if (currentTime > lastTime + 30) {
    update();
    lastTime = currentTime;
  }
}

void update() {
  if (random(1) <= icicleIncidence) {
    icicles.add(new Icicle(new PVector(int(random(20, width-20)), -30)));
  }
  player.update();
  for (int i = 0; i < icicles.size(); i++) {
    Icicle icicle = (Icicle) icicles.get(i);  
    if (icicle.alive) {
        icicle.update();
    } else {
      icicles.remove(i);
      incrementScore();
    }
  }
}

void keyPressed() {
  if (keyCode == SPACE) {
    setup();
  }
  player.keyPressed();
}

void incrementScore() {
  if (player.alive) {
    score++;
    if (score % 10 == 0) {
      icicleIncidence += 0.01;
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

  textAlign(CENTER);
  textFont(font, 24);
  text(notice, width/2, height/2);
  textFont(font, 18);
  text("Press the Spacebar to restart.", width/2, height/2 + 24);
  noFill();
}

void keyReleased() {
  player.keyReleased();
}

class Player {
  PVector position, velocity, acceleration;
  int radius;
  boolean jumping = false;
  boolean alive = true;

  Player(PVector p, int r) {
    position = p;
    velocity = new PVector(0, 0);
    radius = r;
    acceleration = new PVector(0, 0);
  }

  void update() {     
    if (!jumping) {
      velocity.y += gravity;
    }
    velocity.add(acceleration);

    velocity.x = constrain(velocity.x, -maxVelocity, maxVelocity);
    velocity.y = constrain(velocity.y, -maxVelocity, maxVelocity);

    position.add(velocity);

    if ((position.x - radius/2) <= 0) {
      position.x = 0 + radius/2;
      velocity.x = -velocity.x;
    }
    if ((position.x + radius/2) >= width) {
      position.x = width - radius/2;
      velocity.x = -velocity.x;
    }
    if ((position.y - radius/2) <= 0) {
      position.y = 0 + radius/2;
      velocity.y = -velocity.y;
    }
    if ((position.y + radius/2) >= height) {
      position.y = height - radius/2;
      if (jumping) {
        velocity.y = -velocity.y;
      } 
      else {
        velocity.y = -abs(velocity.y) + damping;
      }
      if (velocity.x > 0) {
        velocity.x -= friction;
        if (velocity.x < 0) {
          velocity.x = 0;
        }
      } 
      else {
        velocity.x += friction;
        if (velocity.x > 0) {
          velocity.x = 0;
        }
      }
    }
  }

  void keyPressed() {
    if (keyCode == LEFT || key == 'a') {
      acceleration.x = -keyX;
    }
    if (keyCode == RIGHT || key == 'd') {
      acceleration.x = keyX;
    }
    if (keyCode == UP || key == 'w') {
      jumping = true;
      acceleration.y = -keyY;
    } 
    if (keyCode == DOWN || key == 's') {
      acceleration.y = keyY;
    }
  }

  void keyReleased() {
    if (keyCode == RIGHT || keyCode == LEFT || key == 'a' || key == 'd') {
      acceleration.x = 0;
    }
    if (keyCode == UP || keyCode == DOWN || key == 'w' || key == 's') {
      if (keyCode == UP || key == 'w') {
        jumping = false;
      }
      acceleration.y = 0;
    }
  }

  void draw() {
    if (alive) {
      ellipse(position.x, position.y, radius, radius);
    }
  }
}

class Icicle {
  PVector position, velocity, v1, v2, v3;
  int w = 8;
  int h = 38;
  boolean alive = true;

  Icicle(PVector p) {
    position = p;
    velocity = new PVector(0, 3 + random(-icicleIncidence, icicleIncidence));
    v1 = new PVector(position.x - w/2, position.y - h/2);
    v2 = new PVector(position.x + w/2, position.y - h/2);
    v3 = new PVector(position.x, position.y + h/2);
  }

  void update() {     
    position.add(velocity);
    v1.set(position.x - w/2, position.y - h/2, 0);
    v2.set(position.x + w/2, position.y - h/2, 0);
    v3.set(position.x, position.y + h/2, 0);  
    if ((position.y - h/2) >= height) {
      alive = false;
    }
    collide();
  }

  void collide() {
    if (player.alive && 
      ((position.dist(player.position) < player.radius/2) ||
      (v1.dist(player.position) < player.radius/2) ||
      (v2.dist(player.position) < player.radius/2) ||
      (v3.dist(player.position) < player.radius/2))) {
      player.alive = false;
    }
  }

  void draw() {
    if (alive) {
      triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
    }
  }
}

