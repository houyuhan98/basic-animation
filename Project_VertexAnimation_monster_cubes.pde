// VertexAnimation Project
//Yuhan Hou
import java.io.*;
import java.util.*;

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

// TODO: Create animations for interpolators
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();
float zZoom=300;
void setup() {
  pixelDensity(2);
  size(1200, 800, P3D);

  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");




  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);  
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  initCubes();

  /*====== Create Animations For Spheroid ======*/
  spherePos = new Animation();
  //Create and set keyframes
  createSphereKeyFrames();
  spherePosition.SetAnimation(spherePos);
}




void draw() {
  lights();
  background(0);
  translate(width/2, height/2, zZoom);
  rotateX(map(mouseY,0,height,PI/2,-PI/2));
  rotateY(map(mouseX,0,width,-PI/2,PI/2));
  DrawGrid();

  float playbackSpeed = 0.005f;

  // TODO: Implement your own camera

  /*====== Draw Forward Monster ======*/
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(playbackSpeed);
  shape(monsterForward.currentShape);
  popMatrix();

  /*====== Draw Reverse Monster ======*/
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-playbackSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();

  /*====== Draw Snapped Monster ======*/
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(playbackSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();

  /*====== Draw Spheroid ======*/
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();

  /*====== TODO: Update and draw cubes ======*/
  // For each interpolator, update/draw
  
  for (int i=0; i<cubeNum; i++) {
    
    cubePosition[i].Update(playbackSpeed);
    
     pos = cubePosition[i].currentPosition;
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    if (i%2==0) {
      fill(255, 0, 0);
    } else {
      fill(255, 255, 0);
    }
    noStroke();
    box(12);
    popMatrix();
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zZoom+=e*2;
  zZoom=constrain(zZoom,300,500);
  // Zoom the camera
  // SomeCameraClass.zoom(e);
}


// Create and return an animation object
Animation ReadAnimationFromFile(String fileName) {
  Animation animation = new Animation();

  // The BufferedReader class will let you read in the file data

  //try
  //{
  //BufferedReader reader = createReader(fileName);
  animation.loadData(fileName);

  //}
  //catch (FileNotFoundException ex)
  //{
  //  println("File not found: " + fileName);
  //}
  //catch (IOException ex)
  //{
  //  ex.printStackTrace();
  //}

  return animation;
}

void DrawGrid() {
  // TODO: Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)

  stroke(255);
  for (int i=-100; i<=100; i+=10) {
    line(i, 0, -100, i, 0, 100);
    line(-100, 0, i, 100, 0, i);
  }
  stroke(255,0,0);
  line(-100,0,0,100,0,0);
  stroke(0,0,255);
  line(0,0,-100,0,0,100);
}


void createSphereKeyFrames() {
  KeyFrame one=new KeyFrame(1f);
  one.addVertex(100, 0, 100);
  spherePos.addFrame(one);

  one=new KeyFrame(2f);
  one.addVertex(-100, 0, 100);
  spherePos.addFrame(one);

  one=new KeyFrame(3f);
  one.addVertex(-100, 0, -100);
  spherePos.addFrame(one);

  one=new KeyFrame(4f);
  one.addVertex(100, 0, -100);
  spherePos.addFrame(one);

  spherePos.updateQty();
}