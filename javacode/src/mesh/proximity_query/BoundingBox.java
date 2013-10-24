package mesh.proximity_query;

import org.ejml.data.DenseMatrix64F;

import mesh.Mesh;
import utilities.Point3D;
import utilities.Triangle;

public class BoundingBox {
	
	protected Triangle[] myFaces;
	protected Point3D[] myVertices;
	DenseMatrix64F[] axes;
	Point3D myMeanPoint;
	double[] boxRadii;

	public BoundingBox(Mesh mesh) {
		DenseMatrix64F[] axes = mesh.getPrinComp();
		myFaces = mesh.getFaces();
		myVertices = mesh.getVertices();
		myMeanPoint = mesh.meanPoint();
	}
	
	protected void calcBoundingBox() {
		boxRadii = new double[3];
		for (int i = 0; i < myVertices.length; i++) {
			//myVertices[i].minus(myMeanPoint).dotProduct(pt);
		}
	}
}
