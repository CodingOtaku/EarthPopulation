float rotx = PI/4; //variables for rotation
float roty = PI/4;
float rotz = PI/4;

float maxH=1500000000; //approximate china population.

PShape globe; //Earth shape.
PImage earthTexture;

float r = 200; //Radious of earth (I know earth is not a 'perfect' sphere, just ignore it for now).

String[] country;
int[] population;
int[] longitude;
int[] latitude;
int total;

void setup() {
  size(600, 600, P3D);
  sphereDetail(50);
  noStroke();


  String values[]=loadStrings("worldcities.txt");
  int i = 0;
  total=values.length;

  country = new String[total]; //Initialize array with total content from doc.
  population = new int [total];
  longitude = new int [total];
  latitude = new int[total];

  for (String value : values) {
    String[] pieces = split(value, ",");
    country[i]=pieces[0];
    population[i] = int(pieces[1]);
    latitude[i] = int(pieces[2]);
    longitude[i] = int(pieces[3]);
    i++;
  }


  earthTexture = loadImage("Tierra.jpg"); //Earth texture
  globe = createShape(SPHERE, r);
  globe.setTexture(earthTexture);
}

void draw() {
  background(0);
  translate(width/2, width/2);

  rotateX(rotx);
  rotateY(roty);

  noLights();
  shape(globe);

  for (int i=0; i<total; i++) {
    //Calculate co-ordinates

    float theta = radians(latitude[i]) + PI/2; //reference: Coding Challenge #58 3D mapping
    float phi = radians (-longitude[i]) + PI;

    float x = r * sin(theta) * cos(phi);
    float y = r * cos(theta);
    float z = r * sin(theta) * sin(phi);

    PVector pos = new PVector(x, y, z);

    float h= map(population[i], 0, maxH, 0, 255);

    PVector xAxis = new PVector(1, 0, 0); 
    float angle = PVector.angleBetween(xAxis, pos);
    PVector rotate = xAxis.cross(pos);

    pushMatrix();
    translate (x, y, z);
    rotate(angle, rotate.x, rotate.y, rotate.z);

    fill(h, (255 - h), 0);
    box(h, 5, 5);
    popMatrix();
  }
}

void mouseDragged() {
  float velocidad = 0.005;
  rotx += (pmouseY-mouseY) * velocidad;
  roty += (mouseX-pmouseX) * velocidad;
}
