package utilities;

public class Point3D {
	
	public double x;
	public double y;
	public double z;
	
	public Point3D(double x, double y, double z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public Point3D(double[] pt) {
		x = pt[0];
		y = pt[1];
		z = pt[2];
	}

	public double euclidDist(Point3D pt) {
		double dist = (x - pt.x) * (x - pt.x) + (y - pt.y) * (y - pt.y) + (z - pt.z) * (z - pt.z);
		return Math.sqrt(dist);
	}
	
	public double manhattanDist(Point3D pt) {
		return Math.abs(x - pt.x) + Math.abs(y - pt.y) + Math.abs(z - pt.z);
	}
	
	public Point3D add(Point3D... points) {
		double sumX = x, sumY = y, sumZ = z;
		for (Point3D pt: points) {
			sumX += pt.x;
			sumY += pt.y;
			sumZ += pt.z;
		}
		return new Point3D(sumX, sumY, sumZ);
	}
	
	public Point3D minus(Point3D... points) {
		double sumX = x, sumY = y, sumZ = z;
		for (Point3D pt: points) {
			sumX -= pt.x;
			sumY -= pt.y;
			sumZ -= pt.z;
		}
		return new Point3D(sumX, sumY, sumZ);
	}
	
	public void scale(double scaleVal) {
		x *= scaleVal;
		y *= scaleVal;
		z *= scaleVal;
	}
	
	public void scaleDown(double scaleVal) {
		x /= scaleVal;
		y /= scaleVal;
		z /= scaleVal;
	}
	
	public double getX() {
		return x;
	}
	
	public double getY() {
		return y;
	}
	
	public double getZ() {
		return z;
	}
	
	public double get(int dim) {
		switch (dim) {
		case 0:
			return x;
		case 1:
			return y;
		case 2:
			return z;
		default:
			System.err.println("Dimension " + dim + " should be no more than 2 and no less than 0!");
			return Double.NaN;
		}
	}
	
	@Override
	public String toString() { 
		return String.format("(%f, %f, %f) ", x, y, z);
	}
}
