class EntityObject {
  // Declare class attributes
  Vector location;
  Vector size;
  
  color objColor;
  
  // Declare and initialize other class attributes
  Vector velocity;
  Vector gravity;
  Vector friction = new Vector(0.4,0);
  Boolean jumpState = false;
  Boolean inBlock = false;
  /*
  float[][] boundPoints = {{-1,-.9,1,0},{-1,0,1,0},{-1,.9,1,0},  // Left
                           {-.7,-1,0,1},{0,-1,0,1},{.7,-1,0,1},  // Top
                           {1,.9,-1,0},{1,0,-1,0},{1,-.9,-1,0},  // Right
                           {.7,1,0,-1},{0,1,0,-1},{-.7,1,0,-1}}; // Bottom
  */
  float[][] boundPoints = {{0,.1,1,0},{0,.5,1,0},{0,.9,1,0},  // Left
                           {.2,0,0,1},{.5,0,0,1},{.7,0,0,1},  // Top
                           {1,.9,-1,0},{1,.5,-1,0},{1,.1,-1,0},  // Right
                           {.2,1,0,-1},{.5,1,0,-1},{.8,1,0,-1}}; // Bottom
  
  EntityObject(Vector location_input, Vector size_input, Vector velocity, Vector gravity, color objColor) {
    // Initialize class attributes with constructor arguments
    this.location = location_input;
    this.size = size_input;
    this.velocity = velocity;
    this.gravity = gravity;
    this.objColor = objColor;
  }
 
}
