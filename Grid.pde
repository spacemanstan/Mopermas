class Grid {
  String[][] grid; // the grid being displayed

  final int dimX, dimY; // grid dimensions

  float unit, /* grid square side length */
    padX, /* width padding for centering */
    padY, /* height padding for centering */
    borderNoise, /*  */
    moperNoise, /*  */
    bgNoise; /*  */

  PImage[] borders, mopers; // images

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

    //// load christmas borders into array
    //borders = new PImage[6];
    //for (int ii = 0; ii < 3; ++ii) {
    //  borders[ii] = loadImage("candy" + ii + ".png");
    //}
    //for (int ii = 0; ii < 3; ++ii) {
    //  borders[ii + 2] = loadImage("cane" + ii + ".png");
    //}

    //// load images for tiles
    //mopers = new PImage[1];
    //mopers[0] = loadImage("moper.png");

    createGrid();
  }

  void display() {
    pushStyle();
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        stroke(360);
        fill(69);
        rect(padX + dx*unit, padY + unit*dy, unit, unit);

        fill(120, 42, 69);
        textAlign(CENTER, CENTER);
        text( grid[dx][dy], padX + dx*unit + unit/2, padY + unit*dy + unit/2);
        //text( "[" + dx + "][" + dy + "]", padX + dx*unit + unit/2, padY + unit*dy + unit/2);
        //text( (dx + dy * dimX), padX + dx*unit + unit/2, padY + unit*dy + unit/2);
      }
    }
    popStyle();
  }

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
        if (dx < dimX - 1 && dy < dimY - 1) choices.append( options[1] );
        /* [5] --> 3x3 top left */
        if (dx < dimX - 2 && dy < dimY - 2) choices.append( options[5] );

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
