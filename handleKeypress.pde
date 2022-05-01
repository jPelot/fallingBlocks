Boolean[] isKeyPressed = {false,false,false};
void keyPressed() {
  if (key == 'w') {
    isKeyPressed[0] = true;
    player.gravity.y = 0.6;
    if (gameState == 0) {
      gameState = 1;
      timer = millis();
    }
}
  if (key == 'a') {
    isKeyPressed[1] = true;
    if (playerFacingRight == true) {
      //playerImg = getReversePImage(playerImg);
      //-30 50
      playerFacingRight = false;
    }
  }
  if (key == 'd') {
    isKeyPressed[2] = true;
    if (playerFacingRight == false) {
      //playerImg = getReversePImage(playerImg);
      playerFacingRight = true;
    }
  }
  
  if (key == 'r' & gameState == 3) {
    reInit();
    gameState = 0;
  }
    
}
void keyReleased() {
  if (key == 'w') {isKeyPressed[0] = false; player.gravity.y = 1.2;}
  if (key == 'a') {isKeyPressed[1] = false;}
  if (key == 'd') {isKeyPressed[2] = false;}  
}

void handleKeypress() {
  if (isKeyPressed[0] & player.jumpState == true) {player.velocity.y = -15;} //player.jumpState = false;}
  if (isKeyPressed[1]) {player.velocity.x = -5;}
  if (isKeyPressed[2]) {player.velocity.x = 5;}
}
