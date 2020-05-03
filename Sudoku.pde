int[][][] grid = new int[9][9][9];
/*
* first - rows
* second - column
* third - type (0 - empty, 1 - little/likely, 2 - sure, 3 - preload)
*/
boolean isMenu = false, isDecies = false;
int[] select;
PVector menuCoord = new PVector(200, 200);
color[] numberColor = {color(255), color(100), color(0), color(101, 67, 33)};
int _height, startY = 20;

void setup(){
  size(600, 600);
  frameRate(60);
  _height = height - startY;
  int[][] preload = new int[][] {{5,0,0,0,7,0,0,0,0},
                                 {6,0,0,1,9,5,0,0,0},
                                 {0,9,8,0,0,0,0,6,0},
                                 {8,0,0,0,6,0,0,0,3},
                                 {4,0,0,8,0,3,0,0,1},
                                 {7,0,0,0,2,0,0,0,6},
                                 {0,6,0,0,0,0,2,8,0},
                                 {0,0,0,4,1,9,0,0,5},
                                 {0,0,0,0,8,0,0,7,9}};
  for(int i = 0; i < 9; i++)
    for(int k = 0; k < 9; k++)
      if(preload[i][k] > 0)
        grid[i][k][preload[i][k] - 1] = 3;
}

void drawGrid(){
  stroke(0);
  fill(0);
  textSize(15);
  strokeWeight(3);
  line(0, startY, width, startY);
  text("generate", 10, startY / 2 + 4);
  strokeWeight(0);
  fill(100);
  rect(90, 0, 50, startY);
  fill(0);
  text(isDecies ? "Stop" : "Start", 100, startY / 2 + 4);

  if(mouseY >= startY && !isMenu){
    fill(200);
    rect(mouseX - mouseX % (width / 9.0) + 1, 1 + startY + (mouseY - startY) - (mouseY - startY) % (_height / 9.0), width / 9.0 - 2, _height / 9.0 - 2);
  }
  
  for(int i = 1; i < 9; i++){
    strokeWeight(i % 3 == 0 ? 3 : 1);
    line(i * width / 9, startY, i * width / 9, startY + _height);
    line(0, startY + i * _height / 9.0, width, startY + i * _height / 9.0);
  }
  
  for(int i = 0; i < 9; i++){
    next: for(int k = 0; k < 9; k++){
      for(int m = 0; m < 9; m++)
        if(grid[i][k][m] == 2 || grid[i][k][m] == 3){
          fill(numberColor[grid[i][k][m]]);
          textSize(32);
          text(str(m + 1), k * width / 9 + width / 25.0, startY + i * _height / 9.0 + _height / 12.0);
          continue next;
        }
      fill(numberColor[1]);
      textSize(20);
      for(int m = 0; m < 9; m++){
        if(grid[i][k][m] > 0)
          text(str(m + 1), k * width / 9 + 25 * (m % 3), startY + i * _height / 9.0 + _height / 32.0 + 22 * (m / 3));
        }
    }
  }
  if(isMenu){
    fill(100);
    rect(menuCoord.x, menuCoord.y, 90, 90);
    
    if(menuCoord.x <= mouseX && mouseX < menuCoord.x + 90 &&
       menuCoord.y <= mouseY && mouseY < menuCoord.y + 90){
      fill(200);
      strokeWeight(1);
      rect(mouseX - (mouseX - menuCoord.x) % 30 + 1, mouseY - (mouseY - menuCoord.y) % 30 + 1, 29, 29);
    }
       
    fill(255);
    textSize(18);
    for(int i = 1; i < 3; i++){
      line(menuCoord.x + i * 30, menuCoord.y, menuCoord.x + i * 30, menuCoord.y + 90);
      line(menuCoord.x, menuCoord.y + i * 30, menuCoord.x + 90, menuCoord.y + i * 30);
    }
    for(int i = 0; i < 9; i++){
      text(str(i + 1), menuCoord.x + (i % 3) * 30 + 7, menuCoord.y + (i / 3) * 30 + 23);
    }
  }
}

void mouseClicked(){
  if(isMenu){
    if(menuCoord.x <= mouseX && mouseX <= menuCoord.x + 90 &&
       menuCoord.y <= mouseY && mouseY <= menuCoord.y + 90){
      int n = int(mouseX - menuCoord.x) / 30 + (int(mouseY - menuCoord.y) / 30) * 3;
      if(keyCode == SHIFT || mouseButton == RIGHT){
        select[n] = select[n] == 1 ? 0 : 1;
      } else {
        select[n] = select[n] == 2 ? 0 : 2;
        for(int m = 0; m < 9; m++)
          if(m != n && (select[m] == 2 || select[m] == 3))
            select[m] = 0;
      }
    }
    isMenu = false;
  } else {
    if(mouseY < startY){
      if(90 <= mouseX && mouseX <= 140 && 0 <= mouseY && mouseY <= startY)
        isDecies = !isDecies;
    } else {
      select = grid[(mouseY - startY) * 9 / (startY + _height)][mouseX * 9 / width];
      for(int m = 0; m < 9; m++){
        if(select[m] == 3)
          return;
      }
      menuCoord = new PVector(max(0, min(width - 90, mouseX - 45)), max(startY, min(startY + _height - 90, mouseY - 45)));
      isMenu = true;
    }  
  }
}

int x = 0, y = 0;
PVector last = new PVector(0, 0);

void draw(){
  background(255);
  fill(numberColor[3], 100);
  rect(y * width / 9, startY + x * _height / 9, width / 9, _height / 9);
  drawGrid();
  if(isDecies){
    println(x, y);
    if(changeCell(grid, x, y))
      last = new PVector(x, y);
    if(isEnd(grid).x == -1)
      isDecies = false;
    y = (y + (x + 1) / 9) % 9;
    x = (x + 1) % 9;
      if(x == last.x && y == last.y){
        isDecies = false;
      }
  }
}
