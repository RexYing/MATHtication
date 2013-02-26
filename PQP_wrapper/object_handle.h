template <typename T>
mxArray *create_handle(T* obj) {
  mxArray* handle = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
  *reinterpret_cast<T **>(mxGetPr(handle)) = obj;
  return handle;
}

template <typename T>
T* get_object(const mxArray *handle)
{
  return *reinterpret_cast<T **>(mxGetData(handle));
}
