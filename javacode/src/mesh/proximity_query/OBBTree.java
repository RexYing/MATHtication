package mesh.proximity_query;

import mesh.Mesh;

/**
 * Oriented Bounding Box Tree
 * 
 * @author Rex
 * 
 */
public class OBBTree {

	Mesh myMesh;

	public OBBTree(double[][] vertices, int[][] faces) {
		myMesh = new Mesh(vertices, faces);
	}

}
