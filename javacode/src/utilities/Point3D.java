package utilities;

import java.util.Arrays;

import org.ejml.data.DenseMatrix64F;

public class Point3D extends DenseMatrix64F{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5928156031910094416L;
	public double[] coords;

	public Point3D(double x, double y, double z) {
		super(new double[][]{{x, y, z}});
		coords = new double[3];
		coords[0] = x;
		coords[1] = y;
		coords[2] = z;
		
	}

	/**
	 * the modifications on pt will affect coords at the moment
	 * @param pt
	 */
	public Point3D(double[] pt) {
		super(new double[][]{pt});
		coords = pt;
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

	public Point3D add(Point3D... points) {
		double[] newCoords = Arrays.copyOf(coords, 3);
		for (Point3D pt : points) {
			for (int i = 0; i < 3; i++)
				newCoords[i] += pt.get(i);
		}
		return new Point3D(newCoords);
	}

	public Point3D minus(Point3D... points) {
		double[] newCoords = Arrays.copyOf(coords, 3);
		for (Point3D pt : points) {
			for (int i = 0; i < 3; i++)
				newCoords[i] -= pt.get(i);
		}
		return new Point3D(newCoords);
	}
	
	public double dotProduct(Point3D pt) {
		return coords[0] * pt.get(0) + coords[1] * pt.get(1) + coords[2] * pt.get(2);
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
	
	public double[] getCoords() {
		return coords;
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
}
