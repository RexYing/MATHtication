package utilities;

public class Triangle {

	private Point3D[] points;
	private Vector3D[] edges;
	private Vector3D normal;
	
	public Triangle(Point3D[] pts) {
		points = pts;
	}
	
	public Triangle(double[][] pts) {
		for (int i = 0; i < 3; i++) {
			points[i] = new Point3D(pts[i][0], pts[i][1], pts[i][2]);
		}
	}
	
	public void initProps() {
		edges = new Vector3D[3];
		edges[0] = points[1].clone();
		edges[0].minus(points[0]);
		edges[1] = points[2].clone();
		edges[1].minus(points[1]);
		edges[2] = points[0].clone();
		edges[2].minus(points[2]);
		normal = edges[0].crossProduct(edges[1]);
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
	
	private boolean project6(Vector3D axis, Triangle tr) {
		 
	}

	public boolean isIntersect(Triangle tri) {
		Triangle tr1 = clone();
		Triangle tr2 = tri.clone();
		// establish a new coords sys so that the first point of the first triangle is at origin
		Vector3D v = tr1.get(0);
		tr1.translate(v);
		tr2.translate(v);
		tr1.initProps();
		tr2.initProps();
		// normal outwards of each edge of each triangle
		Vector3D no1[] = tr1.calcNormalOutwards();
		Vector3D no2[] = tr2.calcNormalOutwards();
		Vector3D ef[][] = new Vector3D[3][3];
		for (int i = 0; i < 3; i++)
			for (int j = 0; j < 3; j++)
				ef[i][j] = no1[i].crossProduct(no2[i]);
		
		
		// begin the series of tests
		
		return true;
	}
	
	public Vector3D[] calcNormalOutwards() {
		Vector3D[] result = new Vector3D[3];
		for (int i = 0; i < 3; i++)
			result[i] = normal.crossProduct(edges[i]);
		return null;
	}

	@Override
	public Triangle clone() {
		Point3D[] newPoints = new Point3D[3];
		for (int i = 0; i < 3; i++)
			newPoints[i] = points[i].clone();
		return new Triangle(newPoints);
	}
	
	/**
	 * Translate the triangle by a translation vector v
	 * @param v translation vector (1 by 3)
	 */
	public void translate(Vector3D v) {
		for (Point3D pt: points) {
			pt.add(v);
		}
	}
	
	public Point3D get(int i) {
		return points[i];
	}
	
	public Vector3D getNormal() {
		return normal;
	}
}
