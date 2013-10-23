package test;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import utilities.Point3D;
import mesh.Mesh;

public class MeshTest {

	Mesh mesh;

	public void createMesh() {
		double[][] vertices = new double[3][3];
		vertices[0] = new double[] { 0, 0, 0 };
		vertices[1] = new double[] { 0, 2, 0 };
		vertices[2] = new double[] { 0, 0, 1 };

		int[][] faces = new int[1][3];
		for (int i = 0; i < 3; i++)
			faces[0][i] = i + 1;
		mesh = new Mesh(vertices, faces);
	}

	@Test
	public void testMeanPoint() {
		createMesh();
		Point3D pt = mesh.meanPointConvexHull();
		System.out.println(pt.x + " " + pt.y + " " + pt.z);
	}

	@Test
	public void testPoint() {
		double epsilon = 0.00000001;
		Point3D pt1 = new Point3D(0, 0, 0);
		Point3D pt2 = new Point3D(0, 2, 0);
		assertEquals(2.0, pt1.euclidDist(pt2), epsilon);
	}
}
