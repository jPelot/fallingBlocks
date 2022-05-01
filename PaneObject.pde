class PaneObject {
  Vector size;
  Vector location;
  
  PaneObject(Vector size, Vector location) {
    this.size = size;
    this.location = location;
  }
  
  Vector pointOnPane(Vector point) {
    return new Vector(point.x - this.location.x, point.y - this.location.y);
  }
  
}
