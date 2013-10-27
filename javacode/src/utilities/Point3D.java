package utilities;

public class Point3D extends Vector3D{

	public Point3D(double x, double y, double z) {
		super(x, y, z);
	}

	/**
	 * the modifications on pt will affect coords at the moment
	 * @param pt
	 */
	public Point3D(double[] pt) {
		super(pt);
	}
	
	public Point3D(Vector3D v) {
		super(v.coords);
	}

	public double euclidDist(Point3D pt) {
		double dist = 0;
		for (int i = 0; i < 3; i++) {
			dist += (coords[i] - pt.get(i)) * (coords[i] - pt.get(i));
		}
		return Math.sqrt(dist);
	}

	public double manhattanDist(Point3D pt) {
		double dist = 0;
		for (int i = 0; i < 3; i++) {
			dist += Math.abs(coords[i] - pt.get(i));
		}
		return dist;
	}

	@Override
	public Point3D clone() {
		return (Point3D) super.clone();
	}
}
