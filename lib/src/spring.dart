part of physics;

/** 
 * Verlet Spring 
 */
class Spring<P extends Particle>
{
	P a;
	P b;
	double strength = 1.0;
	double restLength = 0.0;
	
	Spring() {}
	
	Spring.betweenParticles(P a, P b) { setParticles(a, b); }
	
	setParticles(P a, P b) {
    this.a = a;
    this.b = b;
    reset();
	}
	
	reset() {
	  restLength = a.position.distanceTo(b.position);
	}

	update() {
		Vector3 delta = b.position - a.position;
		double dist = delta.length + double.MIN_POSITIVE;
		double normDistStrength = (dist - restLength) / dist * strength;

		if(normDistStrength == 0) return;

		delta.scale(normDistStrength);

		if(!a.isLocked) 
			a.position.add(delta);

		if(!b.isLocked) 
			b.position.sub(delta);
	}
}