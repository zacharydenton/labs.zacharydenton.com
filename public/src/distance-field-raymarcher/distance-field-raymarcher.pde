// WASD to move. Spacebar to cycle fractal type.

RayMarcher raymarcher;
float moveX = 0.3;
float moveZ = 0.4;
int t = 0;

void setup() {
  size(952, 392);
  raymarcher = new RayMarcher(new PVector(0, 0, -4.0), 0.0001, 8.0, 200);
  colorMode(HSB);
}

void draw() {
  background(0);
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    float intensity = raymarcher.structure[i];
    if (intensity > 0)
      pixels[i] = color(130 + (sin(t * PI/50) * intensity * 10), 255, intensity * 255);
  }
  updatePixels();
  t++;
}

void keyPressed() {
  switch (key) {
    case 'w':
      raymarcher.pos.add(new PVector(0, 0, moveZ));
      break;
    case 'a':
      raymarcher.pos.add(new PVector(-moveX, 0, 0));
      break;
    case 's':
      raymarcher.pos.add(new PVector(0, 0, -moveZ));
      break;
    case 'd':
      raymarcher.pos.add(new PVector(moveX, 0, 0));
      break;
    case ' ':
      raymarcher.function++;
      break;
  }
  raymarcher.recalculate();
}

class RayMarcher {
  private float minThreshold, maxDepth;
  private int maxSteps;
  public PVector pos;
  public float[] structure;
  public int function = 0;

  public RayMarcher(PVector cameraPos, float threshold, float depth, int steps) {
    pos = cameraPos;
    minThreshold = threshold;
    maxDepth = depth;
    maxSteps = steps;
    recalculate();
  }

  public void recalculate() {
    structure = new float[width * height];
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        PVector direction = new PVector((float) i / width - 0.5, (float) j / width - ((float) height / width) * 0.5, 1.0);
        direction.normalize();

        float totalDistance = 0.0;
        int steps;
        for (steps = 0; steps < maxSteps; steps++) {
          PVector ray = PVector.add(pos, PVector.mult(direction, totalDistance));
          float distance = distance_estimation(ray);
          totalDistance += distance;
          if (distance < minThreshold || totalDistance > maxDepth) break;
        }
        if (totalDistance < maxDepth) {
          structure[i + j*width] = 1.0 - (float) steps / maxSteps;
        } 
        else {
          structure[i + j*width] = 0;
        }
      }
    }
  }

  private float distance_estimation(PVector pos) {
    if (function % 2 == 0) {
      return menger2(pos.x, pos.y, pos.z);
    } 
    else {
      return menger_sponge(pos.x, pos.y, pos.z);
    }
  }

  private float menger_sponge(float x, float y, float z) {
    int iters=6;
    float t;
    for (int n=0;n<iters;n++) {
      x=abs(x); 
      y=abs(y); 
      z=abs(z);
      if (x<y) {
        t=x;
        x=y;
        y=t;
      }
      if (y<z) {
        t=y;
        y=z;
        z=t;
      }
      if (x<y) {
        t=x;
        x=y;
        y=t;
      }
      x=x*3.0-2.0;
      y=y*3.0-2.0;
      z=z*3.0-2.0;
      if (z<-1.0)z+=2.0;
    }
    return (sqrt(x*x+y*y+z*z)-1.5)*pow(3.0, -iters);
  }

  float menger2(float x, float y, float z) {
    int n, iters=12;
    float xx, yy, zz, DEfactor, r2, mr, scaleb;
    float fr, fr2, mr2;
    scaleb=3.2;
    mr2=0.5;
    fr2=1.2;
    xx=0.;
    yy=0.;
    zz=0.;
    r2=x*x+y*y+z*z;
    DEfactor=1.;

    for (n=0;n<iters;n++) {
      if (x>1) x=2-x;
      else if (x<-1) x=-2-x;
      if (y>1) y=2-y;
      else if (y<-1) y=-2-y;
      if (z>1) z=2-z;
      else if (z<-1) z=-2-z;

      r2=x*x+y*y+z*z;
      if (r2<mr2) {
        x=x*fr2/mr2;
        y=y*fr2/mr2;
        z=z*fr2/mr2;
        DEfactor=DEfactor*fr2/mr2;
      } 
      else if (r2<fr2) {
        x=x*fr2/r2;
        y=y*fr2/r2;
        z=z*fr2/r2;
        DEfactor=DEfactor*fr2/r2;
      }
      x=x*scaleb+xx;
      y=y*scaleb+yy;
      z=z*scaleb+zz;
      DEfactor=DEfactor*abs(scaleb)+1;
      r2=x*x+y*y+z*z;
    }
    return sqrt(r2)/DEfactor;
  }
}


