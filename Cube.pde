Animation[]cubePos;
PositionInterpolator[]cubePosition;
int cubeNum=11;

void initCubes() {
  cubePos=new Animation[cubeNum];
  cubePosition=new PositionInterpolator[cubeNum];
  for (int i=0; i<cubeNum; i++) {
    cubePosition[i]=new PositionInterpolator();
    cubePosition[i].currentTime=i*0.1;
    cubePos[i]=new Animation();
    createCubeKeyFrames(cubePos[i],-100+20*i);
    
    cubePosition[i].SetAnimation(cubePos[i]);
    if(i%2==1){
      cubePosition[i].SetFrameSnapping(true);
    }
  }
}


void createCubeKeyFrames(Animation animBase,float xx) {
  KeyFrame one=new KeyFrame(0.5);
  one.addVertex(xx, 0, 0);
  animBase.addFrame(one);

  one=new KeyFrame(1f);
  one.addVertex(xx, 0, -100);
  animBase.addFrame(one);

  one=new KeyFrame(1.5f);
  one.addVertex(xx, 0, 0);
  animBase.addFrame(one);

  one=new KeyFrame(2f);
  one.addVertex(xx, 0, 100);
  animBase.addFrame(one);

  animBase.updateQty();
}
