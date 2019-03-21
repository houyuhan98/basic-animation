abstract class Interpolator {
  Animation animation;

  // Where we at in the animation?
  float currentTime = 0;

  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;

  void SetAnimation(Animation anim) {
    animation = anim;
  }

  void SetFrameSnapping(boolean snap) {
    snapping = snap;
  }

  void UpdateTime(float time) {
    // TODO: Update the current time
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly


    currentTime+=time;

    if (currentTime>animation.GetDuration()) {
      currentTime=0;
    }

    if (currentTime<0) {
      currentTime=animation.GetDuration();
    }
    //if(currentTime>animation.GetDuration() || currentTime<0){
    //  revert*=-1;
    //}
  }

  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator {
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;

  // Changing mesh colors
  color fillColor;

  PShape GetShape() {
    return currentShape;
  }

  void Update(float time) {
    // TODO: Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
    UpdateTime(time);    



    animation.updateRatio(currentTime);

    if (!snapping) {
      animation.lerpFrame();
      generateShape(animation.cFrame);
    } else {
      generateShape(animation.getSnappingFrame());
    }
  }


  void generateShape(ArrayList<PVector>fr) {
    currentShape=createShape(GROUP);
    for (int n=0; n<fr.size(); n+=3) {
      PShape tri=createShape();
      tri.setFill(fillColor);
      //tri.setStroke(fillColor);

      tri.setStroke(false);
      tri.beginShape();
      for (int i=n; i<n+3; i++) {
        tri.vertex(fr.get(i).x, fr.get(i).y, fr.get(i).z);
      }
      tri.endShape();
      currentShape.addChild(tri);
    }
  }
}

class PositionInterpolator extends Interpolator {
  PVector currentPosition;


  void Update(float time) {
    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point

    UpdateTime(time);    
    animation.updateRatio(currentTime);
    if (!snapping) {
      animation.lerpFrame();
      currentPosition=animation.cFrame.get(0).copy();
    }else{
      currentPosition=animation.getSnappingFrame().get(0);
    }
  }
}
