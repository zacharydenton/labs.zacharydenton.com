ArrayList things, beams;
Blaster blaster;
int lastTime = 0;
float thingIncidence;

void setup() {
    size(600, 400);
    smooth();
    
    things = new ArrayList();
    thingIncidence = 1;
    
    beams = new ArrayList();
    
    blaster = new Blaster(new PVector(width / 2, 3 * height / 4), 30);
}

void draw() {
    background(0);
    blaster.draw();
    for (int i = 0; i < things.size(); i++) {
        Thing thing = (Thing) things.get(i);  
        thing.draw();
    }
    for (int i = 0; i < beams.size(); i++) {
        ParticleBeam beam = (ParticleBeam) beams.get(i);  
        beam.draw();
    }
    int currentTime = millis();
    if (currentTime > lastTime + 30) {
        update();
        lastTime = currentTime;
    }
}
 
void update() {
    blaster.update();
    if (random(1) <= thingIncidence) {
        things.add(new Thing(new PVector(int(random(20, width-20)), -30)));
    }
    for (int i = 0; i < things.size(); i++) {
        Thing thing = (Thing) things.get(i);
        if (!thing.targeted) {
            blaster.shoot(thing);
        }
        if (thing.alive) {
            thing.update();
        } else {
            things.remove(i);
        }
    }
    
    for (int i = 0; i < beams.size(); i++) {
        ParticleBeam beam = (ParticleBeam) beams.get(i);
        if (beam.alive) {
            beam.update();
        } else {
            beams.remove(i);
        }
    }
}

class Thing {
  PVector position, velocity, v1, v2, v3;
  int w = 8;
  int h = 38;
  boolean alive = true;
  boolean targeted = false;
 
  Thing(PVector p) {
    position = p;
    velocity = new PVector(0, 3 + random(-thingIncidence, thingIncidence));
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
}
 
  void draw() {
    if (alive) {
      triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
    }
  }
}

class Blaster {
    PVector position;
    boolean canFire = true;
    int lastFired = 0;
    int reloadTime;
    
    Blaster(PVector p, int reload) {
        position = p;
        reloadTime = reload;
    }
    
    void draw() {
        strokeWeight(1);
        fill(0, 255, 0);
        ellipse(position.x, position.y, width / 20, width / 20);
        fill(0, 200, 255);
        ellipse(position.x, position.y, width / 40, width / 40);
    }
    
    void update() {
        if (millis() - lastFired > reloadTime) {
            canFire = true;
        }
    }
    
    void shoot(Thing thing) {
        if (canFire) {
            beams.add(new ParticleBeam(position, thing));
            thing.targeted = true;
            canFire = false;
            lastFired = millis();
        }
    }
}

class ParticleBeam {
    PVector start, velocity, end;
    Thing target;
    float speed = height / 40;
    boolean alive = true;
    
    ParticleBeam(PVector s, Thing t) {
        start = s;
        target = t;
        velocity = PVector.sub(t.position, s);
        velocity.normalize();
        velocity.mult(speed);
        end = new PVector(start.x, start.y);
    }
    
    void update() {
        if (end.dist(target.position) < 2 * velocity.mag()) {
            alive = false;
            target.alive = false;
        }
        velocity = PVector.sub(target.position, end);
        velocity.normalize();
        velocity.mult(speed);
        end.add(velocity);
    }
    
    void draw() {
        stroke(lerpColor(color(254, 254, 34), color(255, 0, 0), 1 -  end.dist(target.position) / start.dist(target.position)));
        strokeWeight(15);
        point(end.x, end.y);
    }
}

