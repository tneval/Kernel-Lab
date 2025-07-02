#include <CL/cl.h>
#include <stdio.h>

#define ARRAY_SIZE 10


const char *programSource =
    "__kernel void buffer_overrun_example(__global int *arr) {\n"
    "    printf(\"hello from kernel\\n\");"
    "    int ARRAY_SIZE = 10;\n"
    "    int idx = get_global_id(0);\n"
    "    if (idx < ARRAY_SIZE) {\n"
    "        arr[idx] = idx;\n"
    "    }\n"
    "    // Illegal access outside the bounds\n"
    "    arr[1000] = 42;\n"
    "    int x = arr[0];\n"
    "    printf(\"value: %d\\n\", x);\n"
    "    //__local int arry[4];\n"
    "    //printf(\"value: %d\\n\", arry[3]);\n"
    "}\n";

int main() {
    printf("#hello\n");
    // Platform and device setup (default platform and device)
    cl_platform_id platform;
    clGetPlatformIDs(1, &platform, NULL);

    cl_device_id device;
    clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);

    cl_context context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);
    cl_command_queue queue = clCreateCommandQueue(context, device, 0, NULL);

    // Create buffer to hold an array of integers
    cl_mem buffer = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(int) * ARRAY_SIZE, NULL, NULL);

    // Create the OpenCL program
    cl_program program = clCreateProgramWithSource(context, 1, &programSource, NULL, NULL);
    clBuildProgram(program, 1, &device, NULL, NULL, NULL);

    // Create the OpenCL kernel
    cl_kernel kernel = clCreateKernel(program, "buffer_overrun_example", NULL);

    // Set kernel argument (passing the buffer)
    clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer);

    // Execute the kernel with one work item per array element
    size_t globalWorkSize = ARRAY_SIZE;
    clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &globalWorkSize, NULL, 0, NULL, NULL);

    // Wait for the kernel to finish
    clFinish(queue);

    // Clean up
    clReleaseMemObject(buffer);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    return 0;
}