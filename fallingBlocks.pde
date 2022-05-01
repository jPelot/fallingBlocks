/*
    __       _ _ _             ____  _            _        _
   / _| __ _| | (_)_ __   __ _| __ )| | ___   ___| | _____| |
  | |_ / _` | | | | '_ \ / _` |  _ \| |/ _ \ / __| |/ / __| |
  |  _| (_| | | | | | | | (_| | |_) | | (_) | (__|   <\__ \_|
  |_|  \__,_|_|_|_|_| |_|\__, |____/|_|\___/ \___|_|\_\___(_) 
                         |___/     Jackson Pelot, 2022
                         
    A game about falling blocks. 
   
    This code is the bastard child between a poor platforming 
    demo and naive confidence, raised on no regard for best 
    practices. Bon appetit.
   
   
    "Do you think god stays up in heaven becasue he too lives 
      in fear of what he's created here on earth?"
                                
                                 - Steve Buscemi, Spy Kids 2


    Notes for next time:
    
    - translate() exists; way easier way to implement scrolling
    - Write readable code
      - Don't write 1 line formulas that span across the entire 
        IDE and are literally impossible to understand much less 
        hunt for bugs
      - Split complicated operations into as many small steps as
        possible.
      - Comment as you go
    - You don't need your own vector class.
    - '=' operater copies arrays by REFRENCE NOT VALUE!!!
    - Listen to Chris
      - If an image needs resizing, do it once at the begining,
        not every frame (that shit takes JUICE)
      - In a pinch, Chris's mere presence will force sketch to 
        compile with 0 errors and run perfectly.
    - You are not clever
      - Spy Kids refrences are not funny
      - Self referential humor is not funny
      - Neither is recursive humor
      - Neither is recursive humor
      
*/



import processing.sound.*;

// Declare SoundFile vars
SoundFile whompSound;
SoundFile tetris;
SoundFile pain;

// Declare Timer for block timing
int lastSpawned = 0;


// Declare/initialize color vars for entitys (not used but still required to compile)
color bg_color = #93CAE3;
color fg_color = #827C9D;
color pl_color = #895465;


// Declare pane and player objects
EntityObject player;
PaneObject pane;

// Arraylist contains all falling block entities
ArrayList<EntityObject> blockList = new ArrayList<EntityObject>();
// array stores how many blocks have fallen per column
int[] blocksFallen;

// Timer for millis() timer
int timer;

// Declare score var for game end
int score;


// Declare image vars
PImage block;
PImage background;
PImage playerImg;

int gameState = 0;

boolean playerFacingRight = true;

void setup() {
  size(800, 800);
  stroke(255);
  player = new EntityObject(new Vector(width/2,2500), new Vector(30,50), new Vector(0,0), new Vector(0,0.6), pl_color);
  pane = new PaneObject(new Vector(width,height), new Vector(0,0));
  blocksFallen = new int[int(mapObject.size.x)-2];
  
  block = loadImage("cobblestone.jpg");
  whompSound = new SoundFile(this, "gravel.wav");
  tetris = new SoundFile(this, "tetris.mp3");
  tetris.amp(.5);
  pain = new SoundFile(this, "pain.wav");
  block.resize(int(mapObject.blockSize.x+1), int(mapObject.blockSize.y));
  
  background = loadImage("background.PNG");
  background.resize(width, height);
  
  playerImg = loadImage("steve.png");
  playerImg.resize(30, 50);
}


void draw() {
  if (tetris.isPlaying() == false) {
    tetris = new SoundFile(this, "tetris.mp3");
    tetris.amp(.5);
    tetris.play();
  }
    
  switch(gameState) {
  case 0:
    background(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Falling Blocks!", width/2, width/3);
    text("Press W to start!", width/2, height/2);
    break;
  case 1:
    background(0);
    text("Don't touch the falling blocks!", width/2, height/2);
    if (millis() - timer > 2000) {
      gameState = 2;
      timer = millis();
    }
    break;
  case 2:
    // # Main game loop
    
    // Game processing
    purgeLayers();               // Remove full layers and shift all entities down by block height to make operation seamless to player
    handleKeypress();            // Handles the keypresses
    stepObject(player);          // Advance the player object 1 step in "physics simulation"
    correctForCollision(player); // Adjust player position according to collisions
    checkForDeath();             // Check if player should die
    handleBlockEntities();       // Advance block object in simulation and destroy them if they are are on the ground
    movePane();                  // Adjust the location of the pane around the location of the player object
  
    // Render Game
    image(background,0,0);       // Draw background image to screen
    drawMap(mapObject);          // Draw the map stored in the mapObject array
    drawPlayer(player);          // Draw the player
    stroke(0);            
    for (int i = 0; i < blockList.size(); i++) {   // Draw all falling blocks
      drawEntity(blockList.get(i));
    }
    textAlign(LEFT, TOP);
    fill(0);
    text((int(millis() - timer)/1000), 10,10);     // Draw score
    break;
    
  case 3:
    background(0);
    textAlign(CENTER, CENTER);
    fill(255);
    text("You have died...", width/2, height/3);
    text("Your score was " + score + " points.", width/2, height/2);
    text("Press R to restart", width/2, height*2/3);
    
  }
}

void reInit() {
  player = new EntityObject(new Vector(width/2,2500), new Vector(30,50), new Vector(0,0), new Vector(0,0.6), pl_color);
  pane = new PaneObject(new Vector(width,height), new Vector(0,0));
  blocksFallen = new int[int(mapObject.size.x)-2];
  blockList = new ArrayList<EntityObject>();
  
  for (int i = 32; i > 1; i--) {
    arrayCopy(mapObject.map[0], mapObject.map[i]);
  }
}


// Draws entity to the screen
void drawEntity(EntityObject entity) {
  fill(entity.objColor);
  //stroke(pl_color);
  noStroke();
  Vector entityLocation = pane.pointOnPane(new Vector(entity.location.x, entity.location.y));
  //rect(entityLocation.x, entityLocation.y, entity.size.x, entity.size.y);
  image(block, entityLocation.x, entityLocation.y);
}

void drawPlayer(EntityObject entity) {
  fill(entity.objColor);
  //stroke(pl_color);
  noStroke();
  Vector entityLocation = pane.pointOnPane(new Vector(entity.location.x, entity.location.y));
  //rect(entityLocation.x, entityLocation.y, entity.size.x, entity.size.y);
  image(playerImg, entityLocation.x, entityLocation.y);
}

// Draws the map to the screen
void drawMap(MapObject mapObj) {
  fill(#6B6781);
  //stroke(#6B6781);
  stroke(0);
  Vector blockLocation;
  for (int y = 0; y < mapObj.size.y; y++) {
    for (int x = 0; x < mapObj.size.x; x++) {
      blockLocation = mapObj.getBlockLocation(x,y);
      blockLocation = pane.pointOnPane(blockLocation);
      if ((0 - mapObject.blockSize.y < blockLocation.x & blockLocation.x < pane.size.x) || (0 - mapObject.blockSize.y < blockLocation.y & blockLocation.y < pane.size.y)) {
        if (mapObj.map[y][x] == 1) {
          //rect(blockLocation.x, blockLocation.y, mapObj.blockSize.x, mapObj.blockSize.y);
          image(block, blockLocation.x, blockLocation.y);
        }
      }
    }
  }
}


void movePane() {
  pane.location.x = constrain(player.location.x - pane.size.x/2 + player.size.x/2, 0, mapObject.sizePx.x - pane.size.x);
  pane.location.y = constrain(player.location.y - pane.size.y/1.5 + player.size.y/2, 0, mapObject.sizePx.y - pane.size.y - mapObject.blockSize.y);
}


void updateSize() {
  //pane.size = new Vector(width,height);
}


// Apply gravity and velocity to entity, as well as friction.
void stepObject(EntityObject entity) {
  entity.velocity.add(entity.gravity);
  // Apply friction to entity's velocity if over abs(0)
  if (abs(entity.velocity.x) > 0) {entity.velocity.x = entity.velocity.x - abs(entity.velocity.x)/entity.velocity.x*entity.friction.x;}
  // Set velocity to 0 if velocity is 'really small'. Prevents slight sliding after entity has stopped
  if (abs(entity.velocity.x) < 0.001) {entity.velocity.x = 0.0;}
  entity.location.add(entity.velocity);
}


//     CORRECTING FOR COLLISION "IT'S MAGIC" -JACKSON PELOT
void correctForCollision(EntityObject entity) {
  entity.jumpState = false;
  int counter = 300;
  do {
    entity.inBlock = false;
    counter--;
    for(int i = 0; i < entity.boundPoints.length; i++) {
        Vector boundPoint = new Vector(entity.location.x + entity.boundPoints[i][0]*entity.size.x, entity.location.y + entity.boundPoints[i][1]*entity.size.y);
        if (map[(int)(boundPoint.y*mapObject.size.y/mapObject.sizePx.y)][(int)(boundPoint.x*mapObject.size.x/mapObject.sizePx.x)] == 1) {
          entity.location.addFloats(entity.boundPoints[i][2]/20,entity.boundPoints[i][3]/20);
          if (abs(entity.boundPoints[i][2]) == 1) {entity.velocity.x = 0;}
          if (abs(entity.boundPoints[i][3]) == 1) {entity.velocity.y = 0;}
          if (entity.boundPoints[i][1] == 1) {entity.jumpState = true;}
          entity.inBlock = true;
        }
    }
  } while (counter > 0);
}

void handleBlockEntities() {
  if (frameCount - lastSpawned > 30) {spawnRandomBlock();}
  for (int i = blockList.size()-1; i >= 0; i--) {
    
    // If block is on the ground, destroy it and put a block on the map in the same place
    if (blockList.get(i).jumpState) {
      println((int)((blockList.get(i).location.y+mapObject.blockSize.y/2)*mapObject.size.y/mapObject.sizePx.y));
      
      // The magical line that converts coordinates to their corresponding map array indexes
      map[(int)((blockList.get(i).location.y+mapObject.blockSize.y/2)*mapObject.size.y/mapObject.sizePx.y)][(int)((blockList.get(i).location.x+mapObject.blockSize.x/2)*mapObject.size.x/mapObject.sizePx.x)] = 1;
      blockList.remove(blockList.get(i));
      whompSound.play();
    }
    
    stepObject(blockList.get(i));
    correctForCollision(blockList.get(i));
  }
}
void spawnRandomBlock() {
  lastSpawned = frameCount;
  float x = int(random(0, mapObject.size.x -2));
  
  
  for (int i = 0; i < blocksFallen.length; i++) {
    
    if (blocksFallen[i] <= blocksFallen[int(x)]-6) {
      x = i;
    }
  }
  x = x +1;
  
  blocksFallen[int(x-1)] = blocksFallen[int(x-1)] + 1;
  x = x  * mapObject.blockSize.x;
  blockList.add(new EntityObject(new Vector(x, 1000), mapObject.blockSize, new Vector(0,5), new Vector(0,0.03), fg_color));
}


void checkForDeath() {
  float[][] corners = {{0,0},{1,0},{0,.8},{1,.8}};
  float x;
  float y;
  for (int i = blockList.size()-1; i >= 0; i--) {
    for (int j = 0; j < corners.length; j++) {
      x = player.location.x + corners[j][0]*player.size.x;
      y = player.location.y + corners[j][1]*player.size.y;
      if ((x > blockList.get(i).location.x & x < blockList.get(i).location.x + blockList.get(i).size.x) & (y > blockList.get(i).location.y & y < blockList.get(i).location.y + blockList.get(i).size.y)) {
        endGame();
      }
    }
  }
}


void endGame() {
  pain.play();
  score = int((millis() - timer)/1000);
  gameState = 3;
  //stop();
}

void purgeLayers() {
  boolean isEmpty = false;
  for (int block : mapObject.map[mapObject.map.length - 6]) {
    if (block == 0) {isEmpty = true;}
  }
  
  if (isEmpty == false) {
    for (int i = mapObject.map.length - 1; i > 0; i--) {
      arrayCopy(mapObject.map[i-1], mapObject.map[i]);
    }
    
    for (int i = blockList.size()-1; i >= 0; i--) {
      blockList.get(i).location.y = blockList.get(i).location.y + mapObject.blockSize.y;
    }
    player.location.y = player.location.y + mapObject.blockSize.y;
    
  }
}

public PImage getReversePImage( PImage image ) {
 PImage reverse = new PImage( image.width, image.height, 0);
 for( int i=0; i < image.width; i++ ){
   for(int j=0; j < image.height; j++){
     reverse.set( image.width - 1 - i, j, image.get(i, j) );
   }   
 }
 return reverse;
}
