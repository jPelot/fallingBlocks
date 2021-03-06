class MapObject {
  int[][] map;
  Vector size;
  Vector sizePx;
  
  Vector blockSize = new Vector(80,80);

  MapObject(int[][] map_input) {
    this.map = map_input;
    size = new Vector(this.map[0].length, this.map.length);
    sizePx = new Vector(size.x*blockSize.x, size.y*blockSize.y);
  }
  
  Vector getBlockLocation(int x, int y) {
    return new Vector(x*this.blockSize.x, y*this.blockSize.y);
  }
}


int[][] map = {{1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1},
               {1,0,0,0,0,0,0,0,0,1}, //32
               {1,1,1,1,1,1,1,1,1,1},
               {1,1,1,1,1,1,1,1,1,1},
               {1,1,1,1,1,1,1,1,1,1},
               {1,1,1,1,1,1,1,1,1,1},
               {1,1,1,1,1,1,1,1,1,1}};



MapObject mapObject = new MapObject(map);
