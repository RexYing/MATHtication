// This is a MATLAB interface to PQP, this file wraps around the code needed to build a PQP hierarcy of a model (vertices and faces)

using namespace std;
#include "mex.h"
#include "matrix.h"
#include "PQP.h"
#include "object_handle.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  //Check arguments
  if(nrhs !=2 || nlhs != 1 )
    mexErrMsgTxt("Requires 2 inputs and one output\n");
  
  if ( mxIsComplex(prhs[0])|| mxIsClass(prhs[0], "sparse") || mxIsChar(prhs[0]) )    
    mexErrMsgTxt("Input must be real, full, and nonstring");
  if ( mxIsComplex(prhs[1])|| mxIsClass(prhs[1], "sparse") || mxIsChar(prhs[1]) )    
    mexErrMsgTxt("Input must be real, full, and nonstring");
  
  //Get dimensions of X, epsilon and Q
  mwSize nrBv, ncBv, nrBf, ncBf, nrWv, ncWv, nrWf, ncWf, nre, nce;
  nrBv = mxGetM(prhs[0]);
  ncBv = mxGetN(prhs[0]);
  nrBf = mxGetM(prhs[1]);
  ncBf = mxGetN(prhs[1]);

  //Check that arguments make sense
  if( nrBv != 3 ) 
    mexErrMsgTxt("Bv must have 3 rows\n");
  if( nrBf != 3 )
    mexErrMsgTxt("Bf must have 3 rows\n");
    
  //Get pointers to Bv, Bf, Wv, Wf
  double *Bv=mxGetPr(prhs[0]);
  double *Bf=mxGetPr(prhs[1]);

  // initialize PQP model pointer
  PQP_Model *b1 = new PQP_Model;

  //Insert all triangles into the model
  b1->BeginModel();
  PQP_REAL p1[3], p2[3], p3[3];
  for( int i=0;i<ncBf;i++) { //the -1's are because of the indexing difference
    p1[0]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+0]-1)+0];
    p1[1]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+0]-1)+1];
    p1[2]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+0]-1)+2];
    p2[0]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+1]-1)+0];
    p2[1]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+1]-1)+1];
    p2[2]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+1]-1)+2];
    p3[0]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+2]-1)+0];
    p3[1]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+2]-1)+1];
    p3[2]= (PQP_REAL) Bv[3*(long int)(Bf[3*i+2]-1)+2];
    b1->AddTri(p1, p2, p3, i);
  }
  b1->EndModel();

  //Create handle to be returned to MATLAB
  plhs[0] = create_handle(b1);
  return;
}
