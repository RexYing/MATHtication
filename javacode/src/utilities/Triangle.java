package utilities;

public class Triangle {

	private Point3D[] points;
	private double myArea;
	private Vector3D[] edges;
	private Vector3D normal;
	
	public Triangle(Point3D[] pts) {
		if (pts.length != 3) {
			System.err.println("Wrong number of dimensions!");
			throw new RuntimeException("wrong dimension");
		}
			
		points = pts;
		myArea = triangleArea();
	}
	
	public Triangle(double[][] pts) {
		points = new Point3D[3];
		for (int i = 0; i < 3; i++) {
			points[i] = new Point3D(pts[i][0], pts[i][1], pts[i][2]);
		}
	}
	
	public Point3D getVertex(int index) {
		return points[index];
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
	
	/**
	 * calculate the area of triangle
	 * @return
	 */
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
	

	public double getArea() {
		return myArea;
	}
	
	public Vector3D vectorSum() {
		Vector3D sum = points[0].clone();
		sum.add(points[1], points[2]);
		return sum;
	}
	
	/**
	 * Test intersect by using axis (there could be false positive but no false negative)
	 * @param axis separation axis
	 * @param tr the other triangle
	 * @return false if they definitely do not intersect according to axis
	 */
	private boolean project6(Vector3D axis, Triangle tr) {
		double[] projection1 = new double[3];
		double[] projection2 = new double[3];
		for (int i = 0; i < 3; i++) {
			projection1[i] = axis.dotProduct(getVertex(i));
			projection2[i] = axis.dotProduct(tr.getVertex(i));
		}
		double max1 = Math.max(Math.max(projection1[0], projection1[1]), projection1[2]);
		double min1 = Math.min(Math.min(projection1[0], projection1[1]), projection1[2]);
		double max2 = Math.max(Math.max(projection2[0], projection2[1]), projection2[2]);
		double min2 = Math.min(Math.min(projection2[0], projection2[1]), projection2[2]);
		
		if ((min1 > max2) || (min2 > max1))
			return false;
		// might intersect
		return true;
	}

	/**
	 * test if triangles intersect by performing 17 separation axis projection tests
	 * @param tri
	 * @return
	 */
	public boolean isIntersect(Triangle tri) {
		Triangle tr1 = clone();
		Triangle tr2 = tri.clone();
		// establish a new coords sys so that the first point of the first triangle is at origin
		Vector3D v = tr1.getVertex(0);
		tr1.translate(v);
		tr2.translate(v);
		tr1.initProps();
		tr2.initProps();
		// normal outwards of each edge of each triangle
		Vector3D no1[] = tr1.calcNormalOutwards();
		Vector3D no2[] = tr2.calcNormalOutwards();
		Vector3D ef[][] = new Vector3D[3][3];
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++)
				ef[i][j] = no1[i].crossProduct(no2[j]);
		}
		
		//series of tests
		if (!tr1.project6(tr1.getNormal(), tr2)) return false;
		if (!tr1.project6(tr2.getNormal(), tr2)) return false;

		for (int i = 0; i < 3; i++)
			for (int j = 0; j < 3; j++)
				if (!tr1.project6(ef[i][j], tr2))
					return false;
		
		for (int i = 0; i < 3; i++) {
			if (!tr1.project6(no1[i], tr2))
				return false;
			if (!tr1.project6(no2[i], tr2))
				return false;
		}
		// passes all tests, must be intersecting
		return true;
	}
	
	public Vector3D[] calcNormalOutwards() {
		Vector3D[] result = new Vector3D[3];
		for (int i = 0; i < 3; i++)
			result[i] = normal.crossProduct(edges[i]);
		return result;
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
	
	public Vector3D getNormal() {
		return normal;
	}
}
