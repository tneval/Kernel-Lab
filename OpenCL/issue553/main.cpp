#include <CL/opencl.hpp>
#include <iostream>

using namespace std;

const char *SOURCE = R"RAW(
// Expected output:
//  outer=A inner=B
//  + outer=A inner=B
// for each value of A and B.
// However I see three copies of the second line (starting with +).
// Commenting out any one line marked with YYYY bring it down to two copies,
// and commenting out any one line marked with XXXX gives the expected output.

__kernel void pocltest(int xarg1, int xarg2) {
  int outerend = 1;
  int innerend = 1;
  outerend = 2; // YYYY
  innerend = 2; // YYYY
  int outer = 0;
  int inner = 0;
  int arg1 = 1;
  int arg2 = 1;
  arg1 = xarg1; // XXXX
  arg2 = xarg2; // XXXX
  for (outer = 0; outer < outerend; outer++) // XXXX
  {
    for (inner = 0; inner < innerend; inner++) // XXXX
    {
      //barrier(CLK_LOCAL_MEM_FENCE);
	    printf("outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
	    if (arg2 > arg1) // XXXX
	    {
        barrier(CLK_LOCAL_MEM_FENCE); // XXXX
	    }
	    if (arg1 > 0) // XXXX
	    {
        barrier(CLK_LOCAL_MEM_FENCE); // XXXX
	    }
	    printf("+ outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
      //barrier(CLK_LOCAL_MEM_FENCE); /* This barrier also fixes it.  */
    }
  }
}
)RAW";

int main(int argc, char *argv[])
{
    cl::Platform platform = cl::Platform::getDefault();
    cl::Device device = cl::Device::getDefault();
    
        cl::CommandQueue queue = cl::CommandQueue::getDefault();
        cl::Program program(SOURCE, true);


        auto kernel = cl::KernelFunctor<cl_int, cl_int>(program, "pocltest");

        cl::Buffer buffer;
        kernel(cl::EnqueueArgs(queue, cl::NDRange(2), cl::NDRange(2)), 1, 2);



        queue.finish();
    

    platform.unloadCompiler();

    std::cout << "OK" << std::endl;
    return EXIT_SUCCESS;
}