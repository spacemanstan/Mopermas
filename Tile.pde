class Tile {
  public StringList states;
  public boolean collapsed;
  public int up, down, left, right;

  Tile() {
    states = new StringList(); // init
    collapsed = false; // not collapsed
    up = down = left = right = -1; // -1 = unset
  }

  void set_u(boolean close) {
    if (collapsed && up != -1) return;

    up = close ? 1 : 0; // open or closed edge

    for (int st = states.size() - 1; st >= 0; --st) {
      String checkState = states.get(st);

      // closed top edge
      if (up == 1) {
        // remove all bottom pieces
        if ( checkState.charAt(3) == 'B' ) {
          states.remove(st);
          continue; 
        }
        // remove all edge piece options except top
        if ( checkState.charAt(3) == 'E' && checkState.charAt(4) != 'T' ) {
          states.remove(st);
          continue; 
        }
        // remove center piece option
        if ( checkState.charAt(3) == 'C' ) {
          states.remove(st);
          continue; 
        }
      }

      // open top edge
      if (up == 0) {
        // remove 1x1 option
        if ( checkState.charAt(0) == '1' ) {
          states.remove(st);
          continue; 
        }
        // remove all closed top options
        if ( checkState.charAt(3) == 'T' ) {
          states.remove(st);
          continue; 
        }
        // remove only top edge piece option
        if ( checkState.endsWith("ET") ) {
          states.remove(st);
          continue; 
        }
      }
    }

    if (states.size() == 1) collapsed = true;
  }

  void set_d(boolean close) {
    if (collapsed && down != -1) return;

    down = close ? 1 : 0;  // open or closed edge

    for (int st = states.size() - 1; st >= 0; --st) {
      String checkState = states.get(st);

      // closed bottom edge
      if (down == 1) {
        // remove all open bottom (top) options
        if ( checkState.charAt(3) == 'T' ) {
          states.remove(st);
          continue; 
        }
        // remove all edge piece options except bottom
        if ( checkState.charAt(3) == 'E' && checkState.charAt(4) != 'B' ) {
          states.remove(st);
          continue; 
        }
        // remove center piece option (all empty)
        if ( checkState.charAt(3) == 'C' ) {
          states.remove(st);
          continue; 
        }
      }

      // open bottom edge
      if (down == 0) {
        // remove 1x1 option
        if ( checkState.charAt(0) == '1' ) {
          states.remove(st);
          continue; 
        }
        // remove all closed top options
        if ( checkState.charAt(3) == 'B' ) {
          states.remove(st);
          continue; 
        }
        // remove only top edge piece option
        if ( checkState.endsWith("EB") ) {
          states.remove(st);
          continue; 
        }
      }
    }

    if (states.size() == 1) collapsed = true;
  }

  void set_l(boolean close) {
    if (collapsed && left != -1) return;

    left = close ? 1 : 0;  // open or closed edge

    for (int st = states.size() - 1; st >= 0; --st) {
      String checkState = states.get(st);

      // closed left edge
      if (left == 1) {
        // remove all open left (right) options
        if ( checkState.charAt(4) == 'R' ) {
          states.remove(st);
          continue; 
        }
        // remove all edge piece options except left
        if ( checkState.charAt(3) == 'E' && checkState.charAt(4) != 'L' ) {
          states.remove(st);
          continue; 
        }
        // remove center piece option (all empty)
        if ( checkState.charAt(3) == 'C' ) {
          states.remove(st);
          continue; 
        }
      }


      // open left edge
      if (left == 0) {
        // remove 1x1 option
        if ( checkState.charAt(0) == '1' ) {
          states.remove(st);
          continue; 
        }
        // remove all closed left options
        if ( checkState.charAt(4) == 'L' ) {
          states.remove(st);
          continue; 
        }
        // remove only left edge piece option
        if ( checkState.endsWith("EL") ) {
          states.remove(st);
          continue; 
        }
      }


      if (states.size() == 1) collapsed = true;
    }
  }

  void set_r(boolean close) {
    if (collapsed && right != -1) return;

    right = close ? 1 : 0;  // open or closed edge

    for (int st = states.size() - 1; st >= 0; --st) {
      String checkState = states.get(st);

      // closed right edge
      if (right == 1) {
        // remove all open right (left) options
        if ( checkState.charAt(4) == 'L' ) {
          states.remove(st);
          continue; 
        }
        // remove all edge piece options except right
        if ( checkState.charAt(3) == 'E' && checkState.charAt(4) != 'R' ) {
          states.remove(st);
          continue; 
        }
        // remove center piece option (all empty)
        if ( checkState.charAt(3) == 'C' ) {
          states.remove(st);
          continue; 
        }
      }

      // open right edge
      if (right == 0) {
        // remove 1x1 option
        if ( checkState.charAt(0) == '1' ) {
          states.remove(st);
          continue; 
        }
        // remove all closed right options
        if ( checkState.charAt(4) == 'R' ) {
          states.remove(st);
          continue; 
        }
        // remove only right edge piece option
        if ( checkState.endsWith("ER") ) {
          states.remove(st);
          continue; 
        }
      }
    }

    if (states.size() == 1) collapsed = true;
  }
}
