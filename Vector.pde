class Vector {
  float x;
  float y;
  Vector(float x_in, float y_in) {
    x = x_in;
    y = y_in;
  }
  
  void add(Vector vec) {
    this.x = this.x + vec.x;
    this.y = this.y + vec.y;
  }
  
  void addFloats(float x, float y) {
    this.x = this.x + x;
    this.y = this.y + y;
  }
  
  void copy(Vector vec) {
    this.x = vec.x;
    this.y = vec.y;
  }
  
  void reset() {
    this.x = 0.0;
    this.y = 0.0;
  }
}
