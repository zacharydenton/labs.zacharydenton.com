/* @pjs transparent="true"; */
// This sketch builds on a prior work, "Rainbow Spirograph", created by Zach Denton
// http://studio.sketchpad.cc/sp/pad/view/ro.9yHZDeii8N38l/rev.29


int num_particles = 30;
int max_velocity = 3;
Particle[] particles = new Particle[num_particles];
Planet planet;

void setup() {
  size(940, 700);
  background(0, 0);
  smooth();
  strokeWeight(2);
  for (int i=0; i< num_particles; i++) {
    particles[i] = new Particle(new PVector(int(width / 2) + int(random(-50, 50)), int(height / 2) + int(random(-50, 50))), 
                                new PVector(random(-.1, .1), random(-.1, .1)));
  }
  planet = new Planet(new PVector(width/2, height/2), 60, 0.03);
}

void draw() {
  planet.update();
  for (Particle p : particles) {
    p.update();
  }
}

class Particle {
  PVector position, velocity, acceleration;  
  int r = int(random(0, 255));
  int g = int(random(0, 255));
  int b = int(random(0, 255));
  
  Particle(PVector pos, PVector vel) {
    position = pos;
    velocity = vel;
  }
  
  void update() {
    PVector direction = PVector.sub(planet.get_position(), position);
    direction.normalize();
    acceleration = PVector.mult(direction, planet.get_gravity());
    velocity.add(acceleration);
    if (velocity.x > max_velocity) {
        velocity.x = max_velocity;
    }
    if (velocity.y > max_velocity) {
        velocity.y = max_velocity;
    }
    position.add(velocity);
    stroke(r, g, b, 100);
    point(position.x, position.y);
  }
}

class Planet {
  PVector position;
  int radius;
  float gravity;
  
  Planet(PVector pos, int r, float g) {
    position = pos;
    radius = r;
    gravity = g;
  }
  
  void update() {
    noStroke();
    noFill();
    position.x = mouseX;
    position.y = mouseY;
    ellipse(position.x, position.y, radius, radius);
  }
  
  PVector get_position(){
    return position;
  }
  
  float get_gravity() {
    return gravity;
  }
}
    
    
  

