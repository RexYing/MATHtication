package mesh;

import org.ejml.data.DenseMatrix64F;
import org.ejml.factory.DecompositionFactory;
import org.ejml.factory.EigenDecomposition;
import org.ejml.ops.CommonOps;
import org.ejml.ops.EigenOps;

import utilities.Point3D;
import utilities.Triangle;

public class Mesh {

	private Point3D[] myVertices;
	private Triangle[] myFaces;
	private Point3D myMeanPoint;
	private DenseMatrix64F myCovMat;

	public Mesh(double[][] vertices, int[][] faces) {

		myVertices = new Point3D[vertices.length];
		for (int i = 0; i < vertices.length; i++)
			myVertices[i] = new Point3D(vertices[i]);

		myFaces = new Triangle[faces.length];
		// change indexing to 0-based
		for (int i = 0; i < myFaces.length; i++)
			myFaces[i] = new Triangle(new Point3D[] { myVertices[faces[i][0] - 1], myVertices[faces[i][1] - 1],
					myVertices[faces[i][2] - 1] });
	}
	
	public Mesh(Point3D[] vertices, Triangle[] faces) {
		myVertices = vertices;
		myFaces = faces;
	}

	public Point3D[] getVertices() {
		return myVertices;
	}

	public Triangle[] getFaces() {
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
		myMeanPoint = new Point3D(0, 0, 0);
		for (int i = 0; i < myFaces.length; i++) {
			Point3D sum = myFaces[i].vectorSum();
			// sum.scaleDown(myFaces[i].getArea());
			myMeanPoint = myMeanPoint.add(sum);
		}
		myMeanPoint.scaleDown(6 * myFaces.length);
		return myMeanPoint;
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
			myMeanPoint = myMeanPoint.add(myFaces[i].vectorSum());
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
		if (myCovMat != null)
			return myCovMat;
		meanPoint();
		double[][] normVerts = new double[myVertices.length][3];
		for (int i = 0; i < normVerts.length; i++) {
			normVerts[i] = myVertices[i].minus(myMeanPoint).coords;
		}
		/*
		for (int i = 0; i < 3; i++)
			for (int j = i; j < 3; j++) {
				double value = 0;
				for (int k = 0; k < myFaces.length; k++) {
					for (int v = 0; v < 3; v++) {
						value += (myFaces[k].getVertex(v).get(i) - myMeanPoint.get(i))
								* (myFaces[k].getVertex(v).get(j) - myMeanPoint.get(j));
					}
				}
				value /= (3 * myFaces.length);
				cov[i][j] = value;
				cov[j][i] = value;
			}
		*/
		DenseMatrix64F v = new DenseMatrix64F(normVerts);
		myCovMat = new DenseMatrix64F(3, 3);
		CommonOps.multTransA(v, v, myCovMat);
		return myCovMat;
	}

	/**
	 * Principle components of the mesh
	 * The first column is the most significant 
	 * 
	 * @return each column of the returned matrix is a component
	 */
	public DenseMatrix64F[] getPrinComp() {
		DenseMatrix64F cov = getCovMat();
		EigenDecomposition<DenseMatrix64F> covEig = DecompositionFactory.eig(cov.numCols, true);
		covEig.decompose(cov);
		DenseMatrix64F V = EigenOps.createMatrixV(covEig);
		// DenseMatrix64F D = EigenOps.createMatrixD(covEig);
		DenseMatrix64F[] eigVectors = new DenseMatrix64F[3];
		CommonOps.columnsToVector(V, eigVectors);
		// sort 3 elements for efficiency (descending)
		if (covEig.getEigenvalue(0).real < covEig.getEigenvalue(1).real) 
			swap(eigVectors, 0, 1);
		if (covEig.getEigenvalue(1).real < covEig.getEigenvalue(2).real) {
			swap(eigVectors, 1, 2);
		   if (covEig.getEigenvalue(0).real < covEig.getEigenvalue(1).real) 
			   swap(eigVectors, 0, 1);
		}
		return eigVectors;
	}
	
	private void swap(DenseMatrix64F[] vec, int ind1, int ind2) {
		DenseMatrix64F temp = vec[ind1];
		vec[ind1] = vec[ind2];
		vec[ind2] = temp;
	}
}
