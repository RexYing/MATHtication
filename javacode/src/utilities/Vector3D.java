package utilities;

import java.util.Arrays;

public class Vector3D {
	
	protected double[] coords;

	public Vector3D(double x, double y, double z) {
		coords = new double[3];
		coords[0] = x;
		coords[1] = y;
		coords[2] = z;
	}
	
	/**
	 * the modifications on pt will affect coords at the moment
	 * @param pt
	 */
	public Vector3D(double[] pt) {
		coords = pt;
	}

	public void add(Vector3D... vecs) {
		for (Vector3D v : vecs) {
			for (int i = 0; i < 3; i++)
				coords[i] += v.get(i);
		}
	}

	public Point3D minus(Point3D... points) {
		double[] newCoords = Arrays.copyOf(coords, 3);
		for (Point3D pt : points) {
			for (int i = 0; i < 3; i++)
				newCoords[i] -= pt.get(i);
		}
		return new Point3D(newCoords);
	}

	public void scale(double scaleVal) {
		for (int i = 0; i < 3; i++)
			coords[i] *= scaleVal;
	}

	public void scaleDown(double scaleVal) {
		for (int i = 0; i < 3; i++)
			coords[i] /= scaleVal; 
	}

	public double getX() {
		return coords[0];
	}

	public double getY() {
		return coords[1];
	}

	public double getZ() {
		return coords[2];
	}

	public double get(int dim) {
		if ((dim >= 0) && (dim < 3))
			return coords[dim];
		else {
			System.err.println("Dimension " + dim
					+ " should be no more than 2 and no less than 0!");
			return Double.NaN;
		}
	}

	@Override
	public String toString() {
		return String.format("(%f, %f, %f) ", coords[0], coords[1], coords[2]);
	}
	
	/**
	 * new copy of coords
	 */
	@Override
	public Vector3D clone() {
		double[] newCoords = Arrays.copyOf(coords, 3);
		return new Vector3D(newCoords);
	}

}
