package mesh;

public class Mesh {
	
	double[][] myVertices;
	int[][] myFaces;

	public Mesh(double[][] vertices, int[][] faces) {
		myVertices = vertices;
		myFaces = faces;
	}
	
	public double[][] getVertices() {
		return myVertices;
	}
	
	public int[][] getFaces() {
		return myFaces;
	}
	
	/**
	 * calculate mean point of the convex hull by integrating over
	 * the surface of each triangle
	 * @return
	 */
	public double meanPointConvexHull() {
		return 0.1;
	}
}
