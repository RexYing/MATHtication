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
	// full binary tree stored in array
	BoundingBox[] tree;

	public OBBTree(double[][] vertices, int[][] faces) {
		myMesh = new Mesh(vertices, faces);
		tree = new BoundingBox[vertices.length * 2];
	}
	
	private void constructTree() {
		
	}
	
	private BoundingBox getPosChild(int index) {
		return tree[index * 2];
	}

	private BoundingBox getNegChild(int index) {
		return tree[index * 2 + 1];
	}
}
