package utilities;

public class Geom {
	

	
	/**
	 * calculate area of triangle
	 * @param pt1 point 1
	 * @param pt2 point 2
	 * @param pt3 point 3
	 * @return area
	 */
	public static double triangleArea(Point3D pt1, Point3D pt2, Point3D pt3) {
	    // heron's formula
		double[] sides = new double[3];
		double p = 0;
		sides[0] = pt1.euclidDist(pt2);
		sides[1] = pt1.euclidDist(pt3);
		sides[2] = pt2.euclidDist(pt3);
		for (int i = 0; i < 3; i++)
			p += sides[i];
		p = p / 2;
		return Math.sqrt(p * (p - sides[0]) * (p - sides[1]) * (p - sides[2]));
	}
}
