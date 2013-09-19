// This is a MATLAB interface to PQP, this file wraps around the code needed to build a PQP hierarcy of a model (vertices and faces)

using namespace std;
#include "mex.h"
#include "matrix.h"
#include "PQP.h"
#include "object_handle.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  //Check arguments
  if(nrhs !=4 || nlhs != 1 )
    mexErrMsgTxt("Requires 4 inputs and one output\n");
  
  if ( mxIsComplex(prhs[0])|| mxIsClass(prhs[0], "sparse") || mxIsChar(prhs[0]) )    
    mexErrMsgTxt("Input must be real, full, and nonstring");
  if ( mxIsComplex(prhs[1])|| mxIsClass(prhs[1], "sparse") || mxIsChar(prhs[1]) )    
    mexErrMsgTxt("Input must be real, full, and nonstring");
  if ( mxIsComplex(prhs[2])|| mxIsClass(prhs[2], "sparse") || mxIsChar(prhs[2]) )    
    mexErrMsgTxt("Input must be real, full, and nonstring");
  if ( mxIsComplex(prhs[3])|| mxIsClass(prhs[3], "sparse") || mxIsChar(prhs[3]) )    
    mexErrMsgTxt("Input must be real, full, and nonstring");

  
  //Get dimensions of R, T and the type of collision
  mwSize nrR, ncR, nrT, ncT, nrtype;
  nrR = mxGetM(prhs[2]);
  ncR = mxGetN(prhs[2]);
  nrT = mxGetM(prhs[3]);
  ncT = mxGetN(prhs[3]);

  //Check that arguments make sense
  if( nrR != 3 || ncR != 3) 
    mexErrMsgTxt("R must be a 3x3 matrix\n");
  if( nrT != 3 || ncT != 1)
    mexErrMsgTxt("T must be a 3x1 vector\n");
    
  //Get the C++ points to PQP_Model objects
  PQP_Model *b1= get_object<PQP_Model>(prhs[0]);
  PQP_Model *b2= get_object<PQP_Model>(prhs[1]);

  //Get pointers to R, T and type
  double *R   =mxGetPr(prhs[2]);
  double *T   =mxGetPr(prhs[3]);

  //Create dummy rotation and translation matrix for b2
  PQP_REAL R1[3][3];
  PQP_REAL T1[3];

  R1[0][0]=(PQP_REAL)R[3*0+0];
  R1[0][1]=(PQP_REAL)R[3*1+0];
  R1[0][2]=(PQP_REAL)R[3*2+0];
  R1[1][0]=(PQP_REAL)R[3*0+1];
  R1[1][1]=(PQP_REAL)R[3*1+1];
  R1[1][2]=(PQP_REAL)R[3*2+1];
  R1[2][0]=(PQP_REAL)R[3*0+2];
  R1[2][1]=(PQP_REAL)R[3*1+2];
  R1[2][2]=(PQP_REAL)R[3*2+2];

  T1[0]=(PQP_REAL)T[0];
  T1[1]=(PQP_REAL)T[1];
  T1[2]=(PQP_REAL)T[2];

  PQP_REAL R2[3][3]={1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
  PQP_REAL T2[3]={0.0,0.0,0.0};

  //Depending on type, determine the intersections
  PQP_DistanceResult dres;
  PQP_Distance(&dres, R1, T1, b1, R2, T2, b2, 0.0, 0.0);

  //Allocate space for answer and copy it
  plhs[0] = mxCreateDoubleMatrix(1,(mwSize) 1, mxREAL);
  double *answer = mxGetPr(plhs[0]);
  *answer=dres.Distance();

  return;
}
