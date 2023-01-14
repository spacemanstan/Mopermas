class Grid {
  String[][] grid; // the grid being displayed

  final int dimX, dimY; // grid dimensions

  final float angMax;

  float unit, /* grid square side length */
    padX, /* width padding for centering */
    padY, /* height padding for centering */
    borderNoise, /*  */
    moperNoise, /*  */
    moperAngNoise, /*  */
    bgNoise; /*  */

  PImage[] borders, corners, mopers; // images

  String[] options = {
    "1x1[]", /* [0] single tile [] looks like a square */
    "2x2TL", /* [1] 2x2 top left */
    "2x2TR", /* [2] 2x2 top right */
    "2x2BL", /* [3] 2x2 bottom left */
    "2x2BR", /* [4] 2x2 bottom right */
    "3x3TL", /* [5]. 3x3 top left */
    "3x3TM", /* [6]. 3x3 top middle */
    "3x3TR", /* [7]. 3x3 top right */
    "3x3ML", /* [8]. 3x3 middle left */
    "3x3MM", /* [9]. 3x3 middle middle */
    "3x3MR", /* [10] 3x3 middle right */
    "3x3BL", /* [11] 3x3 bottom left */
    "3x3BM", /* [12] 3x3 bottom middle */
   "3x3BR" /*** [13] 3x3 bottom right */
  };

  Grid() {
    this(5, 11);
  }

  Grid(int dx_, int dy_) {
    // grid x & y dimensions
    dimX = dx_;
    dimY = dy_;

    // initial padding, recalulated later to center everything
    // only one padding needs to be changed to center
    padX = padY = width * 0.075;

    // check x / width and y / height for unit, smaller = best sqaure size
    // assume x is smaller to start
    unit = (width - padX*2) / dimX;

    // check if y is smaller
    if ( ((height - padY*2) / dimY) < unit ) {
      unit = (height - padY*2) / dimY; // update unit to y calc
      padX = (width - dimX * unit) / 2; // update x padding to center
    } else {
      padY = (height - dimY * unit) / 2; // update y to center
    }

    loadImages();

    createGrid();

    borderNoise = 0.0;
    bgNoise = 0.0;
    moperNoise = 0.0;

    angMax = radians(15);
  }

  void display() {
    pushStyle();
    rectMode(CENTER);
    imageMode(CENTER);

    // draw background
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        final String tile = grid[dx][dy];

        if ( !(tile.equals("1x1[]") || tile.equals("2x2TL") || tile.equals("3x3MM")) )
          continue;

        float noiseVal = noise(bgNoise + (dx + dy*dimX));
        float hue = ( (int)(noiseVal * 10) & 1 ) == 1 ? noiseVal * 40 + 100 : noiseVal * 20 + 340;
        float sat = noiseVal * 15 + 60;
        float brt = noiseVal * 30 + 44;

        noStroke();
        fill(hue, sat, brt);
        pushMatrix();

        if (tile.equals("1x1[]")) {
          translate(padX + dx*unit + unit/2, padY + unit*dy + unit/2);
          rect(0, 0, unit, unit);
        }

        if (tile.equals("2x2TL")) {
          translate(padX + dx*unit + unit, padY + unit*dy + unit);
          rect(0, 0, 2*unit, 2*unit);
        }

        if (tile.equals("3x3MM")) {
          translate(padX + dx*unit + unit/2, padY + unit*dy + unit/2);
          rect(0, 0, 3*unit, 3*unit);
        }

        popMatrix();
      }
    }

    // draw borders
    for (int dy = 0; dy < dimY; ++dy)
      for (int dx = 0; dx < dimX; ++dx) {
        // get a random border / corner image based on noise
        // bni = border noise index
        int bni = (int)(noise(borderNoise + (dx + dy * dimX)) * borders.length);
        final String tile = grid[dx][dy];

        pushMatrix();

        translate(padX + dx*unit + unit/2, padY + unit*dy + unit/2);

        float imgUnit = unit;

        if (tile.charAt(0) == '1') {
          image(borders[bni], 0, 0, imgUnit, imgUnit);
          image(corners[bni], 0, 0, imgUnit, imgUnit);

          for (int poop = 0; poop < 3; ++poop) {
            // update index; different color borders
            ++bni;
            bni %= borders.length;
            // rotate piece; change side
            rotate(HALF_PI);
            // draw image and corner after rotation
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
          }
        } else {
          // corners
          if (tile.endsWith("TL")) {
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
          }
          if (tile.endsWith("TR")) {
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
          }
          if (tile.endsWith("BR")) {
            rotate(PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
          }
          if (tile.endsWith("BL")) {
            rotate(PI + HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
          }
          // edges
          if (tile.endsWith("TM")) {
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
          }
          if (tile.endsWith("MR")) {
            rotate(HALF_PI);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
          }
          if (tile.endsWith("BM")) {
            rotate(PI);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
          }
          if (tile.endsWith("ML")) {
            rotate(PI + HALF_PI);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
            rotate(HALF_PI);
            image(borders[bni], 0, 0, imgUnit, imgUnit);
            image(corners[bni], 0, 0, imgUnit, imgUnit);
          }
        }

        popMatrix();
      }

    // draw images
    for (int dy = 0; dy < dimY; ++dy)
      for (int dx = 0; dx < dimX; ++dx) {
        // moper noise index = mni
        int mni = (int)(noise(moperNoise + (dx + dy * dimX)) * mopers.length);
        final String tile = grid[dx][dy];

        float angOffset = noise(moperNoise + (dx + dy * dimX)) * (angMax * 4);

        float ang = (frameCount + angOffset) % (angMax * 4);
        
        boolean rotation = true;

        pushMatrix();

        if (tile.equals("1x1[]")) {
          translate(padX + dx*unit + unit/2, padY + unit*dy + unit/2);
          
          if (rotation) {
            if (ang < 2 * angMax)
              rotate(ang - angMax);
            else
              rotate(3*angMax - ang);
          }
          
          image(mopers[mni], 0, 0, unit, unit);
        }

        if (tile.equals("2x2TL")) {
          translate(padX + dx*unit + unit, padY + unit*dy + unit);
          
          if (rotation) {
            if (ang < 2 * angMax)
              rotate(ang - angMax);
            else
              rotate(3*angMax - ang);
          }
          
          image(mopers[mni], 0, 0, 2*unit, 2*unit);
        }

        if (tile.equals("3x3MM")) {
          translate(padX + dx*unit + unit/2, padY + unit*dy + unit/2);

          if (rotation) {
            if (ang < 2 * angMax)
              rotate(ang - angMax);
            else
              rotate(3*angMax - ang);
          }

          image(mopers[mni], 0, 0, 3*unit, 3*unit);
        }

        popMatrix();
      }

    popStyle();
  }

  void loadImages() {
    /*
      load boarders from data folder
     android hates folders (w/o permissions) so everything goes in data
     all borders are named border_ where _ is an unsigned int
     */
    borders = new PImage[6]; // all border images default to left side
    for (int ii = 0; ii < borders.length; ++ii)
      borders[ii] = loadImage("border" + ii + ".png");

    corners = new PImage[6]; // all corner images default to top left corner
    for (int ii = 0; ii < corners.length; ++ii)
      corners[ii] = loadImage("corner" + ii + ".png");

    mopers = new PImage[1]; // all mopers are centered
    for (int ii = 0; ii < mopers.length; ++ii)
      mopers[ii] = loadImage("moper" + ii + ".png");
  }

  /*
   Grid is created with a pseudo wave function collapse function
   Grid is created by starting with a 2d array of strings
   null indicates if the string has been set yet or not
   randomly choose between 3 options (if valid)
   1. 1x1 tile
   2. 2x2 top left
   3. 3x3 top left
   
   if we go from the top left down each time, then if we randomly
   place a top left grid, and it is always valid, we can just
   assign the respective values corresponding to that top left
   */
  void createGrid() {
    // declare grid;   null = unset state
    grid = new String[dimX][dimY];

    // initialize the grid
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        // only proceed to random selection if unset
        if (grid[dx][dy] != null) continue;

        // if not set, get a string list for all option choices
        StringList choices = new StringList();

        // 1x1 is always an option
        choices.append( options[0] );

        /*
         grid is built from top left down,
         thus we can only check for top left validity
         when choice is decided fill connected grid tiles
         */

        /* [1] --> 2x2 top left */
        if (dx < dimX - 1 && dy < dimY - 1 && check2x2(dx, dy)) choices.append( options[1] );
        /* [5] --> 3x3 top left */
        if (dx < dimX - 2 && dy < dimY - 2 && check3x3(dx, dy)) choices.append( options[5] );

        // randomize choices
        if (choices.size() > 1)
          choices.shuffle();

        final String decision = choices.get(0);

        // set value
        grid[dx][dy] = decision;

        if (decision == options[0]) continue;

        // update other 2x2 vals
        if (decision == options[1]) {
          grid[dx + 1][dy + 0] = options[2]; /* 2x2TR */
          grid[dx + 0][dy + 1] = options[3]; /* 2x2BL */
          grid[dx + 1][dy + 1] = options[4]; /* 2x2BR */
        }

        // update other 3x3 vals
        if (decision == options[5]) {
          // top row
          grid[dx + 1][dy + 0] = options[6]; /** 3x3TM */
          grid[dx + 2][dy + 0] = options[7]; /** 3x3TR */
          // mid row
          grid[dx + 0][dy + 1] = options[8]; /** 3x3ML */
          grid[dx + 1][dy + 1] = options[9]; /** 3x3MM */
          grid[dx + 2][dy + 1] = options[10]; /* 3x3MR */
          // bot row
          grid[dx + 0][dy + 2] = options[11]; /* 3x3BL */
          grid[dx + 1][dy + 2] = options[12]; /* 3x3BM */
          grid[dx + 2][dy + 2] = options[13]; /* 3x3BR */
        }
      }
    }
  }

  boolean check2x2(int dx, int dy) {
    return grid[dx + 1][dy + 0] == null && /* 2x2TR */
      grid[dx + 0][dy + 1] == null && /* 2x2BL */
      grid[dx + 1][dy + 1] == null; /* 2x2BR */
  }

  boolean check3x3(int dx, int dy) {
    return grid[dx + 1][dy + 0] == null && /** 3x3TM */
      grid[dx + 2][dy + 0] == null && /** 3x3TR */
      grid[dx + 0][dy + 1] == null && /** 3x3ML */
      grid[dx + 1][dy + 1] == null && /** 3x3MM */
      grid[dx + 2][dy + 1] == null && /* 3x3MR */
      grid[dx + 0][dy + 2] == null && /* 3x3BL */
      grid[dx + 1][dy + 2] == null && /* 3x3BM */
      grid[dx + 2][dy + 2] == null; /* 3x3BR */
  }

  void printTile(int ix, int iy) {
    // no index out of bounds in this house
    int dx = constrain(ix, 0, dimX - 1);
    int dy = constrain(iy, 0, dimY - 1);

    //String getTile = grid[dx][dy];

    println("\n####################################");
    println(grid[dx][dy] == options[0]);
    //println("x: " + dx + ", y: " + dy + " | size: " + getTile.states.size() );
    //printArray(getTile.states);
  }
}
