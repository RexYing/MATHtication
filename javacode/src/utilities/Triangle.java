package utilities;

public class Triangle {

	private Point3D[] points;
	
	public Triangle(Point3D[] pts) {
		points = pts;
	}
	
	public Triangle(double[][] pts) {
		for (int i = 0; i < 3; i++) {
			points[i] = new Point3D(pts[i][0], pts[i][1], pts[i][2]);
		}
	}
	
	public double triangleArea() {
		// heron's formula
		double[] sides = new double[3];
		double p = 0;
		sides[0] = points[0].euclidDist(points[1]);
		sides[1] = points[1].euclidDist(points[2]);
		sides[2] = points[2].euclidDist(points[0]);
		for (int i = 0; i < 3; i++)
			p += sides[i];
		p = p / 2;
		return Math.sqrt(p * (p - sides[0]) * (p - sides[1]) * (p - sides[2]));
	}

	public boolean isIntersect(Triangle tri) {
		Triangle tr1 = clone();
		Triangle tr2 = tri.clone();
		return true;
	}
	
	@Override
	public Triangle clone() {
		Point3D[] newPoints = new Point3D[3];
		for (int i = 0; i < 3; i++)
			newPoints[i] = points[i].clone();
		return new Triangle(newPoints);
	}
	
	public void move(Vector3D v) {
		for (Point3D pt: points) {
			pt.add(v);
		}
	}
}
