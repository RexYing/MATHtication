package mesh.proximity_query;

import mesh.Mesh;
import utilities.Point3D;
import utilities.Triangle;

/**
 * Basic bounding box that only contains 1 triangle
 * @author Rex
 *
 */
public class BaseBoundingBox extends BoundingBox {

	private Triangle myFace;
	
	public BaseBoundingBox(Mesh mesh) {
		super(mesh);
		myFace = mesh.getFaces()[0];
	}
	

}
