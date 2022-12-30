int dimX, dimY; /* # of rows & cols in grid */
Grid mopers;

/*###############################################
 Setup
 ###############################################*/
void setup() {
  // sketch params
  //fullScreen();
  size(500, 900);
  orientation(PORTRAIT);
  colorMode(HSB, 360, 100, 100, 100);

  mopers = new Grid(5, 11);
}

/*###############################################
 Draw
 ###############################################*/
void draw() {
  background(0);

  mopers.display();

  //float hueNoise = 69;
  //float satNouse = -420;

  //for (int iy = 0; iy < dimY; ++iy)
  //  for (int ix = 0; ix < dimX; ++ix) {
  //    //float hue = noise(hueNoise += 0.1) * 20 + 340;
  //    //print
  //    float hue = noise(hueNoise += 0.1) * 40 + 100;
  //    float sat = noise(satNouse += 0.1) * 80 + 20;
  //    float brt = sat * sat / 2;
  //    fill(hue, sat, brt);
  //    rect(padX + ix*unit, padY + unit*iy, unit, unit);
  //  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    Tile check = mopers.getMouseTile();

    if (check != null)
      printArray(check.state);
  }

  if (mouseButton == RIGHT)
    mopers.mouseCollapse();
}
