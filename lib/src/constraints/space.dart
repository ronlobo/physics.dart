part of physics;

/**
 * Keeps the particle locked on the given plane
 */
class PlaneConstraint extends Constraint
{
  static const int AXIS_X = 0;
  static const int AXIS_Y = 1;
  static const int AXIS_Z = 2;
  
  int axis;
  double plane = 0.0;
  
  PlaneConstraint([this.axis=AXIS_Z, this.plane = 0.0]);
  
  apply(Particle p) {
    p.position.storage[axis] = plane;
  }
}



/**
 * Keeps the particle inside the given box shape
 */
class BoxConstraint extends Constraint 
{
  Vector3 min = new Vector3.zero();
  Vector3 max = new Vector3(100.0, 100.0, 100.0);

  apply(Particle particle) {
    var pos = particle.position;

    if(pos.x < min.x) pos.x = min.x;
    if(pos.y < min.y) pos.y = min.y;
    if(pos.z < min.z) pos.z = min.z;

    if(pos.x > max.x) pos.x = max.x;
    if(pos.y > max.y) pos.y = max.y;
    if(pos.z > max.z) pos.z = max.z;
  }
}


/**
 * Wraps the particle inside the given box shape
 */
class BoxWrap extends Constraint 
{
  Vector3 min = new Vector3.zero();
  Vector3 max = new Vector3(100.0, 100.0, 100.0);

  apply(Particle particle) {
    var pos = particle.position;
    var wrapped = false;
    
    if(pos.x < min.x) {
      pos.x = max.x;
      wrapped = true;
    }
    
    if(pos.y < min.y) {
      pos.y = max.y;
      wrapped = true;
    }
    if(pos.z < min.z) {
      pos.z = max.z;
      wrapped = true;
    }

    if(pos.x > max.x) {
      pos.x = min.x;
      wrapped = true;
    }
    if(pos.y > max.y) {
      pos.y = min.y;
      wrapped = true;
    }
    if(pos.z > max.z) {
      pos.z = min.z;
      wrapped = true;
    }
    
    if(wrapped)
      particle.clearVelocity();
  }
}


/**
 * Keeps the particle inside the given sphere
 */
class SphereConstraint extends Constraint
{
  // settings
  Vector3 position = new Vector3.zero();
  double radius;
  bool isBouncy;

  // internal
  double _radiusSq;

  SphereConstraint({this.radius: 100.0, this.isBouncy: true});

  prepare() => _radiusSq = radius * radius;

  apply(Particle particle) {
    Vector3 delta = particle.position - position;
    double distSq = delta.length2;

    if(distSq >= _radiusSq) {
      Vector3 constrained = position + delta.normalize().scale(radius);
      if(isBouncy) {
        particle.position.setFrom(constrained); // bouncy
      } else { 
        particle.setPosition(constrained); // no-bounce
      }
    }
  }
}
