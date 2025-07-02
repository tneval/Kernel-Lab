#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

#define CHECK_ERROR(err, msg) \
    if (err != CL_SUCCESS) { \
        fprintf(stderr, "Error: %s (Code %d)\n", msg, err); \
        exit(EXIT_FAILURE); \
    }

int main() {
    const int N = 40;
    

    // OpenCL variables
    cl_int err;
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;


    // Load the compiled binary from file
    FILE *programFile = fopen("kernel.cl.pocl", "rb");
    if (!programFile) {
        fprintf(stderr, "Failed to open kernel binary file\n");
        return EXIT_FAILURE;
    }

    // Get the size of the binary file
    fseek(programFile, 0, SEEK_END);
    long programSize = ftell(programFile);
    rewind(programFile);

    // Read the binary data into a buffer
    unsigned char *programBinary = (unsigned char *)malloc(programSize);
    fread(programBinary, 1, programSize, programFile);
    fclose(programFile);

    // Get OpenCL platform and device
    err = clGetPlatformIDs(1, &platform, NULL);
    CHECK_ERROR(err, "clGetPlatformIDs");
    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
    CHECK_ERROR(err, "clGetDeviceIDs");

    // Create OpenCL context and command queue
    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    CHECK_ERROR(err, "clCreateContext");
    queue = clCreateCommandQueue(context, device, 0, &err);
    CHECK_ERROR(err, "clCreateCommandQueue");

    // Create OpenCL program from the binary
    size_t binarySize = programSize;
    program = clCreateProgramWithBinary(context, 1, &device, &binarySize, (const unsigned char **)&programBinary, NULL, &err);
    CHECK_ERROR(err, "clCreateProgramWithBinary");

    // Build the program
    err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    CHECK_ERROR(err, "clBuildProgram");

    // Create kernel
    kernel = clCreateKernel(program, "test_ids", &err);
    CHECK_ERROR(err, "clCreateKernel");

    // Enqueue kernel for execution
    size_t globalWorkSize = N;
    size_t localWorkSize = 4;
    err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &globalWorkSize, &localWorkSize, 0, NULL, NULL);
    CHECK_ERROR(err, "clEnqueueNDRangeKernel");

    

    // Wait for completion
    clFinish(queue);

    // Clean up
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    free(programBinary);

    return 0;
}
