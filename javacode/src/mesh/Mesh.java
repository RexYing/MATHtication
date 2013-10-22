package mesh;

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
		
		myAreas = new double[myFaces.length];
	}
	
	public Point3D[] getVertices() {
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
	public Point3D meanPointConvexHull() {
		if (myMeanPoint != null)
			return myMeanPoint;
		myMeanPoint = new Point3D(0, 0, 0);
		for (int i = 0; i < myFaces.length; i++) {
			myAreas[i] = Geom.triangleArea(myVertices[myFaces[i][0]], myVertices[myFaces[i][1]],
					myVertices[myFaces[i][2]]);
			Point3D sum = myVertices[myFaces[i][0]].add(myVertices[myFaces[i][1]],
					myVertices[myFaces[i][2]]);
			//sum.scaleDown(myAreas[i]);
			myMeanPoint = myMeanPoint.add(sum);
		}
		myMeanPoint.scaleDown(6 * myFaces.length);
		return myMeanPoint;
	}
	
	public void setMeanPoint(double[] pt) {
		myMeanPoint = new Point3D(pt);
	}
}
