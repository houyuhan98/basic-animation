// Snapshot in time of some amount of data
class KeyFrame {
  // Where does this thing occur in the animation?
  public float time;

  float xpos, ypos, zpos;
  float xrot, yrot, zrot;
  float scale;
  float r, g, b, a;

  // Because translation and vertex positions are the same thing, this can
  // be reused for either. An array of one is perfectly viable.
  public ArrayList<PVector> points = new ArrayList<PVector>();

  KeyFrame(float _time) {
    time=_time;
    points=new ArrayList<PVector>();
  }
  
  void addVertex(float xx,float yy,float zz){
    PVector p=new PVector(xx,yy,zz);
    points.add(p);
  }

  void addVertex(String[]pcs) {
    PVector p=new PVector(Float.parseFloat(pcs[0]), 
      Float.parseFloat(pcs[1]), Float.parseFloat(pcs[2]));
    points.add(p);
  }
}

float transTime=0;

class Animation {
  // Animations start at zero, and end... here
  float GetDuration() {
    return keyFrames.get(keyFrames.size()-1).time;
  }
  
  int leftLimit,rightLimit;
  float ratio;
  
  Animation(){
    keyFrames = new ArrayList<KeyFrame>();
  }
  
  void addFrame(KeyFrame kf){
    keyFrames.add(kf);
  }
  
  void updateRatio(float cTime){
    for(int i=0;i<keyFrames.size()-1;i++){
      if(keyFrames.get(i).time<=cTime && cTime<keyFrames.get(i+1).time){
        leftLimit=i;
        rightLimit=i+1;
        ratio=(cTime-keyFrames.get(i).time)/(keyFrames.get(i+1).time-keyFrames.get(i).time);
        return;
      }
    }
    
    if(0<=cTime && cTime<keyFrames.get(0).time){
      leftLimit=frameQty-1;
      rightLimit=0;
      ratio=cTime/ keyFrames.get(0).time;
    }
    
    //if(keyFrames.get(frameQty-1).time<=cTime && cTime < keyFrames.get(frameQty-1).time+transTime){
    //  leftLimit=frameQty-1;
    //    rightLimit=0;
    //    ratio=(cTime-keyFrames.get(frameQty-1).time)/(transTime);
    //    return;
    //}
    
    //if(keyFrames.get(frameQty-1).time-transTime<=cTime && cTime < keyFrames.get(0).time){
    //  leftLimit=frameQty-1;
    //    rightLimit=0;
    //    ratio=(keyFrames.get(0).time-cTime)/(transTime);
    //    return;
    //}
    
  }
  
  ArrayList<PVector>cFrame=new ArrayList<PVector>();
  
  void lerpFrame(){
    cFrame.clear();
    for(int i=0;i<verticesQty;i++){
      PVector p=PVector.lerp(keyFrames.get(leftLimit).points.get(i),keyFrames.get(rightLimit).points.get(i),ratio);
      cFrame.add(p);
    }
  }
  
  void updateQty(){
    frameQty=keyFrames.size();
    verticesQty=keyFrames.get(0).points.size();
  }
  
  ArrayList<PVector> getSnappingFrame(){
    return keyFrames.get(leftLimit).points;
  }
        

  int frameQty;
  int verticesQty;
  int frameIndex=-1;
  ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();


  void loadData(String fileName) {

    BufferedReader reader=createReader(fileName);

    String line;

    int count=0;
    KeyFrame kf;

    boolean finish=false;

    while (!finish) {
      try {
        line=reader.readLine();
        //println(line);
        count++;
      }
      catch(IOException e) {
        e.printStackTrace();
        line=null;
      }

      if (line==null) {
        return;
      } else {
        String[]pieces=split(line, ' ');
        if (count==1) {
          frameQty=Integer.parseInt(pieces[0]);
        } else if (count==2) {
          verticesQty=Integer.parseInt(pieces[0]);
        } else {
          if (pieces.length==1) {
            frameIndex++;
            kf=new KeyFrame(Float.parseFloat(pieces[0]));
            keyFrames.add(kf);
          } else {
            keyFrames.get(frameIndex).addVertex(pieces);
          }
        }
      }
    }
  }
}
