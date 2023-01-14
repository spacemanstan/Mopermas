Grid mopers;

int posMX = 0, posMY = 0;

/*###############################################
 Setup
 ###############################################*/
void setup() {
  // sketch params
  fullScreen();
  //size(500, 900);
  orientation(PORTRAIT);
  colorMode(HSB, 360, 100, 100, 100);

  mopers = new Grid(5, 11);

  //textSize(12 * displayDensity);

  //displayDensity = 3.5
}

/*###############################################
 Draw
 ###############################################*/
void draw() {
  background(0);

  mopers.display();
}

void touchEnded() {
  mopers.createGrid();
}

void mousePressed() {
  if (mouseButton == RIGHT)
    mopers.bgNoise += 1;

  if (mouseButton == LEFT)
    mopers.createGrid();
}
