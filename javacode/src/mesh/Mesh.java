package mesh;

import org.ejml.data.DenseMatrix64F;
import org.ejml.factory.DecompositionFactory;
import org.ejml.factory.EigenDecomposition;
import org.ejml.ops.EigenOps;

import utilities.Geom;
import utilities.Point3D;

public class Mesh {

	private Point3D[] myVertices;
	private int[][] myFaces;
	private double[] myAreas;
	private Point3D myMeanPoint;

	public Mesh(double[][] vertices, int[][] faces) {

		myVertices = new Point3D[vertices.length];
		for (int i = 0; i < vertices.length; i++)
			myVertices[i] = new Point3D(vertices[i]);

		myFaces = faces;
		// change indexing to 0-based
		for (int i = 0; i < myFaces.length; i++)
			for (int j = 0; j < 3; j++)
				myFaces[i][j]--;

		myAreas = null;
	}

	public Point3D[] getVertices() {
		return myVertices;
	}

	public int[][] getFaces() {
		return myFaces;
	}

	/**
	 * calculate mean point of the convex hull by integrating over the surface
	 * of each triangle
	 * 
	 * @return mean point of convex hull
	 */
	public Point3D meanPointConvexHull() {
		if (myMeanPoint != null)
			return myMeanPoint;
		if (myAreas == null)
			calculateAreas();
		myMeanPoint = new Point3D(0, 0, 0);
		for (int i = 0; i < myFaces.length; i++) {
			Point3D sum = myVertices[myFaces[i][0]].add(
					myVertices[myFaces[i][1]], myVertices[myFaces[i][2]]);
			// sum.scaleDown(myAreas[i]);
			myMeanPoint = myMeanPoint.add(sum);
		}
		myMeanPoint.scaleDown(6 * myFaces.length);
		return myMeanPoint;
	}

	private void calculateAreas() {
		myAreas = new double[myFaces.length];
		for (int i = 0; i < myFaces.length; i++) {
			myAreas[i] = Geom.triangleArea(myVertices[myFaces[i][0]],
					myVertices[myFaces[i][1]], myVertices[myFaces[i][2]]);
		}
	}

	/**
	 * The mean point of the mean points of all faces
	 * 
	 * @return mean point
	 */
	public Point3D meanPoint() {
		if (myMeanPoint != null)
			return myMeanPoint;
		myMeanPoint = new Point3D(0, 0, 0);
		for (int i = 0; i < myFaces.length; i++) {
			myMeanPoint = myMeanPoint.add(myVertices[myFaces[i][0]],
					myVertices[myFaces[i][1]], myVertices[myFaces[i][2]]);
		}
		myMeanPoint.scaleDown(3 * myFaces.length);
		return myMeanPoint;
	}

	/**
	 * covariance matrix using meanPoint()
	 * 
	 * @return
	 */
	public DenseMatrix64F getCovMat() {
		meanPoint();
		double[][] cov = new double[3][3];
		Point3D[] normVerts = new Point3D[myVertices.length];
		for (int i = 0; i < normVerts.length; i++) {
			normVerts[i] = myVertices[i].minus(myMeanPoint);
		}
		for (int i = 0; i < 3; i++)
			for (int j = i; j < 3; j++) {
				double value = 0;
				for (int k = 0; k < myFaces.length; k++) {
					for (int v = 0; v < 3; v++)
						value += normVerts[myFaces[k][v]].get(i)
								* normVerts[myFaces[k][v]].get(j);
				}
				value /= (3 * myFaces.length);
				cov[i][j] = value;
				cov[j][i] = value;
			}
		return new DenseMatrix64F(cov);
	}

	/**
	 * Principle components of the mesh
	 * 
	 * @return each column of the returned matrix is a component
	 */
	public DenseMatrix64F getPrinComp() {
		DenseMatrix64F cov = getCovMat();
		EigenDecomposition<DenseMatrix64F> covEig = DecompositionFactory.eig(
				cov.numCols, true);
		covEig.decompose(cov);
		DenseMatrix64F V = EigenOps.createMatrixV(covEig);
		// DenseMatrix64F D = EigenOps.createMatrixD(covEig);
		return V;
	}
}
