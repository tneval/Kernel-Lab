/* Tests nested for-loops with variable iteration counts with barriers inside.

   Copyright (c) 2014 Pekka Jääskeläinen / Tampere University of Technology

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
*/



// Enable OpenCL C++ exceptions
#define CL_HPP_ENABLE_EXCEPTIONS

#include <CL/opencl.hpp>

#include <cstdio>
#include <cstdlib>
#include <iostream>

#define WINDOW_SIZE 32
#define WORK_ITEMS 2
#define BUFFER_SIZE (WORK_ITEMS + WINDOW_SIZE)

static char
kernelSourceCode[] =
"kernel \n"
"void test_kernel(__global float *input, \n"
"                 __global int *result,\n"
"                 int a) {\n"
" size_t gid = get_global_id(0);\n"
" size_t i;\n"
" volatile int something = 0;\n"
" for (int k = 0; k < a; k++) {\n"
"     for (int j = k + 1; j < result[0]; j++) {\n"
"         something += result[j];\n"
"     }\n"
"     something *= 2;\n"
"     for (int l = 0; l < result[1]; ++l) {\n"
"         something += result[k];\n"
// This barrier here causes the kernel compiler to crash.
"         barrier(CLK_LOCAL_MEM_FENCE);\n"
"     }\n"
" }\n"
"}\n";

int
main(void)
{
    float A[BUFFER_SIZE];
    int R[WORK_ITEMS];
    int a = 3;

    for (int i = 0; i < BUFFER_SIZE; i++) {
        A[i] = (float)i;
    }

    for (int i = 0; i < WORK_ITEMS; i++) {
        R[i] = i;
    }

    std::vector<cl::Platform> platformList;
    try {

        // Pick platform
        cl::Platform::get(&platformList);

        // Pick first platform
        cl_context_properties cprops[] = {
            CL_CONTEXT_PLATFORM, (cl_context_properties)(platformList[0])(), 0};
        cl::Context context(CL_DEVICE_TYPE_ALL, cprops);

        // Query the set of devices attched to the context
        std::vector<cl::Device> devices = context.getInfo<CL_CONTEXT_DEVICES>();

        // Create and program from source
        cl::Program::Sources sources({kernelSourceCode});
        cl::Program program(context, sources);

        // Build program
        program.build(devices);

        // Create buffer for A and copy host contents
        cl::Buffer aBuffer = cl::Buffer(
            context,
            CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
            BUFFER_SIZE * sizeof(float),
            (void *) &A[0]);

        // Create buffer for that uses the host ptr C
        cl::Buffer cBuffer = cl::Buffer(
            context,
            CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR,
            WORK_ITEMS * sizeof(int),
            (void *) &R[0]);

        // Create kernel object
        cl::Kernel kernel(program, "test_kernel");

        // Set kernel args
        kernel.setArg(0, aBuffer);
        kernel.setArg(1, cBuffer);
        kernel.setArg(2, a);

        // Create command queue
        cl::CommandQueue queue(context, devices[0], 0);

        // Do the work
        queue.enqueueNDRangeKernel(
            kernel,
            cl::NullRange,
            cl::NDRange(WORK_ITEMS),
            cl::NullRange);


        // Map cBuffer to host pointer. This enforces a sync with
        // the host backing space, remember we choose GPU device.
        void *res =
            queue.enqueueMapBuffer(cBuffer,
                                   CL_TRUE, // block
                                   CL_MAP_READ, 0, WORK_ITEMS * sizeof(int));

        queue.enqueueUnmapMemObject(cBuffer, res);
        queue.finish();
    }
    catch (cl::Error &err) {
         std::cerr
             << "ERROR: "
             << err.what()
             << "("
             << err.err()
             << ")"
             << std::endl;
         return EXIT_FAILURE;
    }

    platformList[0].unloadCompiler();

    // If the kernel compiler succeeds, we are happy for now.
    std::cout << "OK" << std::endl;
    return EXIT_SUCCESS;
}
