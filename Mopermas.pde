float unit, /* grid square side length */
  padX, /* width padding for centering */
  padY; /* height padding for centering */

int dimX, dimY; /* # of rows & cols in grid */

PImage[] borders;

/*###############################################
 ################################################
 
 Setup
 
 ################################################
 ###############################################*/
void setup() {
  // sketch params
  fullScreen();
  orientation(PORTRAIT);
  colorMode(HSB, 360, 100, 100, 100);

  // initial padding, recalulated later to center everything
  // only one padding needs to be changed to center
  padX = padY = width * 0.075;

  // grid x & y dimensions
  dimX = 5;
  dimY = 11;

  // check x / width and y / height for unit, smaller = best sqaure size
  // assume x is smaller to start
  unit = (width - padX*2) / dimX;

  // check if y is smaller
  if ( ((height - padY*2) / dimY) < unit ) {
    unit = (height - padY*2) / dimY; // update unit to y calc

    padX = (width - dimX * unit) / 2; // update x padding to center
    println("h " + unit);
  } else {
    padY = (height - dimY * unit) / 2;
    println("w " + unit);
  }

  /*
  instead of somethign dynamic like new File( path ).list().length
   images gotta be handled manually with magic #s b/c folders in android are dumb
   */
  borders = new PImage[6];

  for (int ii = 0; ii < 3; ++ii) {
    borders[ii] = loadImage("candy" + ii + ".png");
  }

  for (int ii = 0; ii < 3; ++ii) {
    borders[ii + 2] = loadImage("cane" + ii + ".png");
  }
}

/*###############################################
 ################################################
 
 Draw
 
 ################################################
 ###############################################*/
void draw() {
  background(0);

  float hueNoise = 69;
  float satNouse = -420;

  for (int iy = 0; iy < dimY; ++iy)
    for (int ix = 0; ix < dimX; ++ix) {
      //float hue = noise(hueNoise += 0.1) * 20 + 340;
      print
      float hue = noise(hueNoise += 0.1) * 40 + 100;
      float sat = noise(satNouse += 0.1) * 80 + 20;
      float brt = sat * sat / 2;
      fill(hue, sat, brt);
      rect(padX + ix*unit, padY + unit*iy, unit, unit);
    }
}
