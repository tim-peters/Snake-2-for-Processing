// Snake by TiPE
int fieldSize = 40;
int scale = 15;
int maxLength = 100;

color bgColor;
int snakeLength;
int snakePositions[][] = new int[maxLength][2]; // [][X,Y]
int cookiePosition[] = {(int)random(fieldSize),(int)random(fieldSize)}; // [X,Y]
int direction; // 0=up, 1=down, 2=left, 3=right
int negativeSpeed; // as higher as slower the snake
int speedStep = negativeSpeed;
boolean pause;

void reset() {
  bgColor = color(#BFAA84);
  snakeLength = 3;
  direction = 2;
  negativeSpeed = 10;
  pause = false;
  for(int n = 0;n<snakeLength;n++) {
    snakePositions[n][0] = fieldSize/2+(n*1);
    snakePositions[n][1] = fieldSize/2;
  }
}

void setup() {
  reset();
  size(scale*fieldSize,scale*fieldSize);
}

void draw() {
  if(pause) background(200); else background(bgColor);
  if(speedStep >= negativeSpeed && direction >= 0)
  {
    moveSnake();
    speedStep = 0;
  }
  else if(!pause)
    speedStep++;
  drawCookie();
  drawSnake();
  showInfos();
}

void showInfos() {
  fill(255);
  text("Snake Length: "+snakeLength,10,10,150,20);
  if(direction < 0)
    text("Game Over (press BACKSPACE to restart)",10,23,250,20);
  else if(pause) 
    text("Paused (press 'p' to continue) ",10,23,250,20);
  else
    text("Speed: "+(30-negativeSpeed),10,23,150,20);
}

void drawSnake() {
  stroke(#FEFB4C);
  fill(#EEC72E);
  for(int n = 0;n<snakeLength;n++)
  {
    rect(snakePositions[n][0]*scale,snakePositions[n][1]*scale,scale,scale);
  }
}

void drawCookie() {
  ellipseMode(CORNER);
  stroke(#8C0303);
  fill(#8C0303);
  ellipse(cookiePosition[0]*scale,cookiePosition[1]*scale,scale,scale);
}

void moveSnake() {
    // move tail
    for(int n = snakeLength-1;n>=1;n--)
    {
      arrayCopy(snakePositions[n-1],snakePositions[n],2);
    }
    
    // move snake's head
    switch(direction) {
      case 0: // up
        snakePositions[0][1]--;
      break;
      case 1: // down
        snakePositions[0][1]++;
      break;
      case 2: // left
        snakePositions[0][0]--;
      break;
      case 3: // right
        snakePositions[0][0]++;
      break;
    }
    
    if(snakePositions[0][0] >= fieldSize)
      snakePositions[0][0] = 0;
    else if(snakePositions[0][0] < 0)
      snakePositions[0][0] = fieldSize-1;
    else if(snakePositions[0][1] >= fieldSize)
      snakePositions[0][1] = 0;
    else if(snakePositions[0][1] < 0)
      snakePositions[0][1] = fieldSize-1;

    
    if(checkCollision(snakePositions[0]))
      gameOver();
      
    if(foundCookie()) {
      //negativeSpeed--;
      if(snakeLength<maxLength) {
        arrayCopy(snakePositions[snakeLength-1],snakePositions[snakeLength]);
        snakeLength++;
      }
    }
}

boolean checkCollision(int[] pos) {  
  for(int n = 1;n<snakeLength;n++)
      if(snakePositions[n][0] == pos[0] && snakePositions[n][1] == pos[1]) // Check for tail collisions
        return true;
  
  return false;
}

boolean foundCookie() {
  if(snakePositions[0][0] == cookiePosition[0] && snakePositions[0][1] == cookiePosition[1])
  {
    do {
      cookiePosition[0] = (int)random(fieldSize);
      cookiePosition[1] = (int)random(fieldSize);
      println(snakeLength-2+": new cookie at "+cookiePosition[0]+", "+cookiePosition[1]);
    } while(checkCollision(cookiePosition));
    return true;
  }
  return false; 
}

void gameOver() {
  bgColor = color(#D92211);
  direction = -1;
}

void keyPressed()
{
  if(key == CODED && direction >= 0)
  {
    switch(keyCode) {
      case UP:
        direction = 0;
      break;
      case DOWN:
        direction = 1;
      break;
      case LEFT:
        direction = 2;
      break;
      case RIGHT:
        direction = 3;
      break;
    }
  }
  else
  {
    switch(key) {
     case '+':
        negativeSpeed--;
     break;
     case '-':
       negativeSpeed++;
     break;
     case 'p':
       pause = !pause;
     break;
     case ENTER:
     case RETURN:
     case BACKSPACE:
       reset();
     break; 
    }
  }
}
