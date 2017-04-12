/********* VARIABLES *********/

// We control which screen is active by settings / updating
// gameScreen variable. We display the correct screen according
// to the value of this variable.
//
// 0: Initial Screen
// 1: Game Screen
// 2: Game-over Screen

int gameScreen = 0;

/********* SETUP BLOCK *********/

float ballX, ballY;
int ballSize = 20;
int ballColor = color(0);
int bounce = 20;

color racketColor = color(23);
float racketWidth = 100;
float racketHeight = 10;

float airfriction = 0.001;
float friction = 0.1;
float gravity = 1;
float ballSpeedVert = 0;

int points = 0;
int health = 5;

void setup() {
  size(500, 500);
  ballX = width/4;
  ballY = height/5;
}


/********* DRAW BLOCK *********/

void draw() {
  // Display the contents of the current screen
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}


/********* SCREEN CONTENTS *********/

void initScreen() {
  background(0);
  drawHealth();
  textAlign(CENTER);
  text("Click to start", height/2, width/2);
}
void gameScreen() {
  background(255);
  drawHealth();
  drawPoints();
  //Game Over?
  if (health < 1) {
    gameOver();
  } else {
    drawRacket();
    watchRacketBounce();
    drawBall();
    applyGravity();
    applyHorizontalSpeed();
    keepInScreen();
  }
}

void gameOverScreen() {
  background(0);
  drawHealth();
  drawPoints();  
  textAlign(CENTER);
  text("Game Over\n Click to restart", width/2, height/2);
  text("You Scored: " +points+ " points", width/2, height/2 - 60);
}

void drawRacket() {
  fill(racketColor);
  rectMode(CENTER);
  float x = mouseX;
  if (x < racketWidth/2)
    x = racketWidth/2;
  else if ( x > (width - racketWidth/2)) {
    x = width - racketWidth/2;
  }

  rect(x, mouseY, racketWidth, racketHeight, 5);
}

void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))) {
    if (dist(ballX, ballY, ballX, mouseY)<=(ballSize/2)+abs(overhead)) {
      ballY = mouseY-(ballSize/2);
      ballSpeedVert*=-1;
      ballSpeedVert -= (ballSpeedVert * friction);
      ballSpeedHorizon = (ballX - mouseX)/10;
      points++;
      // racket moving up
      if (overhead<0) {
        ballY+=(overhead/2);
        ballSpeedVert+=(overhead/2);
      }
    }
  }
}

void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airfriction);
}

void makeBounceBottom(float surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert=-25; //Bounce backup (reset speed)
}
void makeBounceTop(float surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

float ballSpeedHorizon = 0;
void applyHorizontalSpeed() {
  ballX += ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon * airfriction);
}
void makeBounceLeft(float surface) {
  ballX = surface+(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}
void makeBounceRight(float surface) {
  ballX = surface-(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}

// keep ball in the screen
void keepInScreen() {
  // ball hits floor
  if (ballY+(ballSize/2) > height) { 
    makeBounceBottom(height);
    //Whenever we hit the bottom of the screen, loose health
    loseHealth();
  }
  // ball hits ceiling
  if (ballY-(ballSize/2) < 0) {
    makeBounceTop(0);
  }
  if (ballX-(ballSize/2) < 0) {
    makeBounceLeft(0);
  }
  if (ballX+(ballSize/2) > width) {
    makeBounceRight(width);
  }
}

void loseHealth() {
  health -= 1;
}

void drawHealth() {
  fill(0, 102, 153);
  textSize(32);
  text(health, 20, width - 20);
}

void drawPoints() {
  fill(0, 102, 153);
  textSize(32);
  text(points, width - 20, 50);
}

void gameOver() {
  gameScreen = 2;
}

/********* INPUTS *********/

public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0 || gameScreen == 2) {
    startGame();
  }
}


/********* OTHER FUNCTIONS *********/

// This method sets the necessery variables to start the game  
void startGame() {
  gameScreen=1;
  health = 5;
  points = 0;
  ballX = width/4;
  ballY = height/5;
}