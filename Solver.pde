// grid[rows][columns][1-9 type]

boolean changeCell(int[][][] grid, int row, int column){
  for(int i = 0; i < 9; i++)
    if(grid[row][column][i] == 2 || grid[row][column][i] == 3)
      return false;

  next: for(int m = 0; m < 9; m++){
    grid[row][column][m] = 0;
    for(int i = 0; i < 9; i++){
      if(i != row && (grid[i][column][m] == 2 || grid[i][column][m] == 3))
        continue next;
      if(i != column && (grid[row][i][m] == 2 || grid[row][i][m] == 3))
        continue next;
      if(i != 0 && (grid[row / 3 * 3 + ((i / 3 + row) % 3)][column / 3 * 3 + ((i % 3 + column) % 3)][m] == 2 ||
                    grid[row / 3 * 3 + ((i / 3 + row) % 3)][column / 3 * 3 + ((i % 3 + column) % 3)][m] == 3))
        continue next;
    }
    grid[row][column][m] = 1;
  }
  int k = -1;
  for(int m = 0; m < 9; m++){
    if(grid[row][column][m] == 1) 
      if(k == -1) {
        k = m;
      }else{
        return false;
      }
  }
  grid[row][column][k] = 2;
  return true;
}

PVector isEnd(int[][][] grid){
  for(int i = 0; i < 9; i++)
    start: for(int k = 0; k < 9; k++)
      for(int m = 0; m < 9; m++){
        if(grid[i][k][m] == 2 || grid[i][k][m] == 3)
          continue start;
      return new PVector(i, k);
      }
  return new PVector(-1, -1);
}
