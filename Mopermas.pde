Grid mopers;

int posMX = 0, posMY = 0;

/*###############################################
 Setup
 ###############################################*/
void setup() {
  // sketch params
  //fullScreen();
  size(500, 900);
  //orientation(PORTRAIT);
  colorMode(HSB, 360, 100, 100, 100);

  mopers = new Grid(5, 11);
  
  //textSize(24 * displayDensity);
  
  // displayDensity = 3.5
}

/*###############################################
 Draw
 ###############################################*/
void draw() {
  background(0);

  mopers.display();

  //fill(120, 90, 90);

  //textAlign(CENTER, CENTER);
  //posMX = (int)((mouseX - mopers.padX) / mopers.unit);
  //if (posMX < 0 || posMX >= mopers.dimX) posMX = posMX < 0 ? 0 : mopers.dimX - 1;
  //posMY = (int)((mouseY - mopers.padY) / mopers.unit);
  //if (posMY < 0 || posMY >= mopers.dimY) posMY = posMY < 0 ? 0 : mopers.dimY - 1;
  //text("[" + posMX + ", " + posMY + "]", mouseX, mouseY);

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
  if (mouseButton == LEFT)
    mopers.borderNoise += 0.01;

  if (mouseButton == RIGHT)
    mopers.createGrid();
}
