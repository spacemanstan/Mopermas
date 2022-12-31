class Grid {
  Tile[][] grid;
  int gridEntropy;
  final int dimX, dimY;

  float unit, /* grid square side length */
    padX, /* width padding for centering */
    padY; /* height padding for centering */

  PImage[] borders, mopers;

  String[] options = {
    "1x1", /* single tile */
    "2x2TL", /* 2x2 top left */
    "2x2TR", /* 2x2 top right */
    "2x2BR", /* 2x2 bottom right */
    "2x2BL", /* 2x2 bottom left */
    "3x3TL", /* top left */
    "3x3TR", /* top right */
    "3x3BR", /* bottom right */
    "3x3BL", /* bottom left */
    "3x3TE", /* 3x3 top edge */
    "3x3BE", /* 3x3 bottom edge */
    "3x3RE", /* 3x3 right edge */
    "3x3LE", /* 3x3 left edge */
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

    mopers = new PImage[1];
    mopers[0] = loadImage("moper.png");

    // initialize grid
    grid = new Tile[dimX][dimY];

    // initialize grid entropy for collapsing later
    gridEntropy = 0;

    // initialize all tiles
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        // create the empty tile
        grid[dx][dy] = new Tile();
        Tile tile = grid[dx][dy];

        // all states initially
        for (String option : options)
          tile.state.append(option);

        // prune or collapse edge states
        // top row
        if (dy == 0) {
          tile.state.removeValue("2x2BL");
          tile.state.removeValue("2x2BR");
          tile.state.removeValue("3x3BL");
          tile.state.removeValue("3x3BR");
          tile.state.removeValue("3x3BE");
          tile.state.removeValue("3x3RE");
          tile.state.removeValue("3x3LE");
          tile.state.removeValue("3x3CC");
        }
        // 2nd row from top
        if (dy == 1) {
          tile.state.removeValue("3x3BL");
          tile.state.removeValue("3x3BE");
          tile.state.removeValue("3x3BR");
        }

        // bottom row
        if (dy == dimY - 1) {
          tile.state.removeValue("2x2TL");
          tile.state.removeValue("2x2TR");
          tile.state.removeValue("3x3TL");
          tile.state.removeValue("3x3TR");
          tile.state.removeValue("3x3TE");
          tile.state.removeValue("3x3RE");
          tile.state.removeValue("3x3LE");
          tile.state.removeValue("3x3CC");
        }
        // 2nd row from bottom
        if (dy == dimY - 2) {
          tile.state.removeValue("3x3TL");
          tile.state.removeValue("3x3TE");
          tile.state.removeValue("3x3TR");
        }

        // left column
        if (dx == 0) {
          tile.state.removeValue("2x2TR");
          tile.state.removeValue("2x2BR");
          tile.state.removeValue("3x3TR");
          tile.state.removeValue("3x3BR");
          tile.state.removeValue("3x3TE");
          tile.state.removeValue("3x3BE");
          tile.state.removeValue("3x3RE");
          tile.state.removeValue("3x3CC");
        }
        // 2nd column from left
        if (dx == 1) {
          tile.state.removeValue("3x3TR");
          tile.state.removeValue("3x3RE");
          tile.state.removeValue("3x3BR");
        }

        // right column
        if (dx == dimX - 1) {
          tile.state.removeValue("2x2TR");
          tile.state.removeValue("2x2BR");
          tile.state.removeValue("3x3TR");
          tile.state.removeValue("3x3BR");
          tile.state.removeValue("3x3TE");
          tile.state.removeValue("3x3BE");
          tile.state.removeValue("3x3RE");
          tile.state.removeValue("3x3CC");
        }
        // 2nd column from right
        if (dx == dimX - 2) {
          tile.state.removeValue("3x3TL");
          tile.state.removeValue("3x3LE");
          tile.state.removeValue("3x3BL");
        }

        // update entropy of grid
        gridEntropy += tile.state.size();
        println("Entropy = " + gridEntropy);
      }
    }
  }

  void display() {
    pushStyle();
    for (int dy = 0; dy < dimY; ++dy) {
      for (int dx = 0; dx < dimX; ++dx) {
        stroke(360);
        fill(69);
        rect(padX + dx*unit, padY + unit*dy, unit, unit);

        if (grid[dx][dy].collapsed )
          fill(120, 42, 69);
        else
          fill(0, 69, 90);
        textAlign(CENTER, CENTER);
        text( grid[dx][dy].state.size(), padX + dx*unit + unit/2, padY + unit*dy + unit/2);
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
    gridEntropy -= tbc.state.size();
    
    // randomly pick collapsed state 
    final String collapsedState = tbc.state.get( (int)random(tbc.state.size()) );
    // remove all states
    tbc.state.clear();
    // add in chosen state
    tbc.state.append( collapsedState );
    
    // second half of entropy update
    gridEntropy += 1;
    
    // update entropies of nearby tiles based on entropy of current tile
    updateSurroundingTiles(dx, dy, collapsedState);

    // set collapse flag
    tbc.collapsed = true;
  }
  
  void updateSurroundingTiles(int gx, int gy, String cState) {
    // adjacent up
    if(gy > 0) {

    }
    // adjacent down
    if(gy < dimY - 1) {
      
    }
    // adjacent left
    if(gx > 0) {
      
    }
    // adjacent right
    if(gx < dimY - 1) {
      
    }
  }
  
  void collapeGrid() {
    /*
      1. IntList of all grid indices (GI)
      2. shuffle GI (grid indices)
      3. while gridEntropy > dimX*dimY
      4. iterate backwards through GI
      5. if collpased remove from GI
      6. else collapse & update neighbours
    */
  }

  void mouseCollapse() {
    if (mouseX < padX || mouseX > padX + dimX*unit) return;
    if (mouseY < padX || mouseY > padY + dimY*unit) return;

    int mx = (int)map(mouseX, padX, width - padX*2, 0, dimX);
    if (mx >= dimX) mx = dimX - 1;

    int my = (int)map(mouseY, padY, height - padY*2, 0, dimY);
    if (my >= dimY) my = dimY - 1;

    println("##################");
    println("collapsing tile [" + mx + ", " + my + "]");

    collapseTile(mx, my);
  }

  Tile getMouseTile() {
    if (mouseX < padX || mouseX > padX + dimX*unit) return null;
    if (mouseY < padX || mouseY > padY + dimY*unit) return null;

    int mx = (int)map(mouseX, padX, width - padX*2, 0, dimX);
    if (mx >= dimX) mx = dimX - 1;

    int my = (int)map(mouseY, padY, height - padY*2, 0, dimY);
    if (my >= dimY) my = dimY - 1;

    println("##################");
    println("x: " + mx + ", y: " + my);

    return grid[mx][my];
  }
}
