// This is a MATLAB interface to PQP, this file wraps around the code needed to build a PQP hierarcy of a model (vertices and faces)

using namespace std;
#include "mex.h"
#include "matrix.h"
#include "PQP.h"
#include "object_handle.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  //Check arguments
  if(nrhs !=1 || nlhs != 0 )
    mexErrMsgTxt("Requires 1 inputs and zero outputs\n");

  //Get the object 
  //[MISSING] Should check that prhs[0] has the right type
  PQP_Model *b1= get_object<PQP_Model>(prhs[0]);

  //And delete it
  delete b1;

  return;
}

