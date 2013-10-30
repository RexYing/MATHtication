package mesh.proximity_query;

import java.util.Arrays;

import org.ejml.data.DenseMatrix64F;

import mesh.Mesh;
import utilities.Point3D;
import utilities.Triangle;
import utilities.Vector3D;

public class BoundingBox {
	
	protected Triangle[] myFaces;
	protected Point3D[] myVertices;
	Vector3D[] axes;
	Point3D myMeanPoint;
	double[] boxRadii;

	public BoundingBox(Mesh mesh) {
		DenseMatrix64F[] comps = mesh.getPrinComp();
		axes = new Vector3D[3];
		for (int i = 0; i < 3; i++)
			axes[i] = new Vector3D(comps[i].getData());
		System.out.println(Arrays.toString(axes));
		
		myFaces = mesh.getFaces();
		myVertices = mesh.getVertices();
		myMeanPoint = mesh.meanPoint();
		
		calcBoundingBox();
	}
	
	protected void calcBoundingBox() {
		boxRadii = new double[3];
		for (int i = 0; i < myVertices.length; i++) {
			for (int j = 0; j < 3; j++) {
				boxRadii[j] = Math.max(boxRadii[j], myVertices[i].minusNew(myMeanPoint).dotProduct(axes[j]));
			}
		}
	}
	
	public Vector3D createSubmesh() {
		// splitting axis: passing through mean point; direction indicated by axes[0] if possible otherwise axes[1], or axes[2]
		return null;
	}
}
