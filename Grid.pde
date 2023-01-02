class Grid {
  Tile[][] grid; // the grid being displayed
  //Tile[] tiles; // all possible tiles
  int gridEntropy; // for generation
  final int dimX, dimY; // grid dimensions

  float unit, /* grid square side length */
    padX, /* width padding for centering */
    padY; /* height padding for centering */

  PImage[] borders, mopers; // images

  String[] options = {
    "1x1[]", /* single tile [] looks like a square */
    "2x2TL", /* 2x2 top left */
    "2x2TR", /* 2x2 top right */
    "2x2BR", /* 2x2 bottom right */
    "2x2BL", /* 2x2 bottom left */
    "3x3TL", /* top left */
    "3x3TR", /* top right */
    "3x3BR", /* bottom right */
    "3x3BL", /* bottom left */
    "3x3ET", /* 3x3 top edge */
    "3x3EB", /* 3x3 bottom edge */
    "3x3ER", /* 3x3 right edge */
    "3x3EL", /* 3x3 left edge */
   "3x3CC" /* 3x3 center piece */
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

    // load christmas borders into array
    borders = new PImage[6];
    for (int ii = 0; ii < 3; ++ii) {
      borders[ii] = loadImage("candy" + ii + ".png");
    }
    for (int ii = 0; ii < 3; ++ii) {
      borders[ii + 2] = loadImage("cane" + ii + ".png");
    }

    // load images for tiles
    mopers = new PImage[1];
    mopers[0] = loadImage("moper.png");

    // initialize grid
    grid = new Tile[dimX][dimY];

    // initialize grid entropy for collapsing later
    gridEntropy = 0;

    // initialize grid
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        // create the empty tile
        grid[dx][dy] = new Tile();
        Tile current = grid[dx][dy];

        // all states initially
        for (String option : options)
          current.states.append(option);

        // top row
        if (dy == 0) current.set_u(true); 
        
        // bottom row
        if (dy == dimY - 1) current.set_d(true); 
        
        // left column
        if (dx == 0) current.set_l(true); 
        
        // right column
        if (dx == dimX - 1) current.set_r(true); 
      }
    }
  }
  
  void updateAdjacent(int xxx, int yyy) {
    // no index out of bounds in this house
    int ix = constrain(xxx, 0, dimX - 1);
    int iy = constrain(yyy, 0, dimY - 1);
  }

  void display() {
    pushStyle();
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        stroke(360);
        fill(69);
        rect(padX + dx*unit, padY + unit*dy, unit, unit);

        if (grid[dx][dy].states.size() == 1)
          fill(120, 42, 69);
        else
          fill(0, 69, 90);
        textAlign(CENTER, CENTER);
        text( grid[dx][dy].states.size(), padX + dx*unit + unit/2, padY + unit*dy + unit/2);
      }
    }
    popStyle();
  }

  void collapseTile(int ix, int iy) {
    // no index out of bounds in this house
    int dx = constrain(ix, 0, dimX - 1);
    int dy = constrain(iy, 0, dimY - 1);

    // tile being collapsed = tbc
    Tile tbc = grid[dx][dy];

    // first half of entropy update
    gridEntropy -= tbc.states.size();

    // randomly pick collapsed state
    final String collapsedState = tbc.states.get( (int)random(tbc.states.size()) );
    // remove all states
    tbc.states.clear();
    // add in chosen state
    tbc.states.append( collapsedState );

    // second half of entropy update
    gridEntropy += 1;

    // update entropies of nearby tiles based on entropy of current tile
    //updateSurroundingTiles(collapsedState, dx, dy);

    // set collapse flag
    //tbc.collapsed = true;
  }
  
  void printTile(int ix, int iy) {
    // no index out of bounds in this house
    int dx = constrain(ix, 0, dimX - 1);
    int dy = constrain(iy, 0, dimY - 1);
    
    Tile getTile = grid[dx][dy];
    
    println("\n####################################");
    println("x: " + dx + ", y: " + dy + " | size: " + getTile.states.size() );
    printArray(getTile.states);
  }
}
