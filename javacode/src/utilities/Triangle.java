package utilities;

public class Triangle {

	private Point3D[] points;
	private double myArea;
	
	public Triangle(Point3D[] pts) {
		points = pts;
		myArea = calcArea();
	}
	
	public Triangle(double[][] pts) {
		for (int i = 0; i < 3; i++) {
			points[i] = new Point3D(pts[i][0], pts[i][1], pts[i][2]);
		}
	}
	
	public Point3D getVertex(int index) {
		return points[index];
	}
	
	/**
	 * calculate the area of triangle
	 * @return
	 */
	private double calcArea() {
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
	
	public double getArea() {
		return myArea;
	}
	
	public Point3D vectorSum() {
		return points[0].add(points[1], points[2]);
	}

}
