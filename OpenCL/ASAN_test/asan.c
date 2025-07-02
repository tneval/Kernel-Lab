#include <stdio.h>
#include <stdlib.h>
#include <CL/cl.h>

#define BUFFER_SIZE 10

const char *kernelSource =
"__kernel void out_of_bounds(__global int *data, int size) {\n"
"    printf(\"hello from kernel\");"
"    int gid = get_global_id(0);\n"
"    if (gid == 0) {\n"
"        data[size + 1] = 42;\n"  // Out-of-bounds write
"    }\n"
"}\n";

int main() {
    cl_int err;
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;
    cl_mem buffer;

    // Get platform and device
    err = clGetPlatformIDs(1, &platform, NULL);
    err |= clGetDeviceIDs(platform, CL_DEVICE_TYPE_DEFAULT, 1, &device, NULL);

    // Create OpenCL context
    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);

    // Create command queue
    queue = clCreateCommandQueue(context, device, 0, &err);

    // Create program
    program = clCreateProgramWithSource(context, 1, &kernelSource, NULL, &err);
    err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);

    // Create kernel
    kernel = clCreateKernel(program, "out_of_bounds", &err);

    // Allocate buffer
    buffer = clCreateBuffer(context, CL_MEM_READ_WRITE, BUFFER_SIZE * sizeof(int), NULL, &err);

    // Set kernel arguments
    clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer);
    int size = BUFFER_SIZE;
    clSetKernelArg(kernel, 1, sizeof(int), &size);

    // Execute kernel
    size_t global_size = 1;
    err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size, NULL, 0, NULL, NULL);

    // Wait for completion
    clFinish(queue);

    // Cleanup
    clReleaseMemObject(buffer);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    printf("Kernel executed. Check ASAN or Valgrind for errors.\n");
    return 0;
}
