#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

// Function to read a file into a string
char* load_kernel_source(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open kernel file");
        exit(1);
    }

    // Get the file size
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);

    // Allocate memory for the file content
    char *source = (char*)malloc(size + 1); // +1 for null-terminator
    if (!source) {
        perror("Failed to allocate memory for kernel source");
        exit(1);
    }

    // Read the file into the string
    fread(source, 1, size, file);
    source[size] = '\0'; // Null-terminate the string

    fclose(file);
    return source;
}

int main() {
    const unsigned int n = 1024;

    // Allocate memory for the vectors
    int *a = (int*)malloc(sizeof(int) * n);
    int *b = (int*)malloc(sizeof(int) * n);
    int *result = (int*)malloc(sizeof(int) * n);

    // Initialize input vectors with some values
    for (unsigned int i = 0; i < n; i++) {
        a[i] = i;
        b[i] = i * 2;
    }

    // OpenCL setup: Platform, Device, Context, Command Queue
    cl_platform_id platform;
    clGetPlatformIDs(1, &platform, NULL);

    cl_device_id device;
    clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);

    cl_context context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);
    cl_command_queue queue = clCreateCommandQueue(context, device, 0, NULL);

    // Load the OpenCL kernel from a file
    const char *kernelSource = load_kernel_source("kernel.cl");

    // Create and build the OpenCL program
    cl_program program = clCreateProgramWithSource(context, 1, &kernelSource, NULL, NULL);
    clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    cl_kernel kernel = clCreateKernel(program, "vector_add", NULL);

    // Create buffers for the input/output data
    cl_mem bufferA = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(int) * n, NULL, NULL);
    cl_mem bufferB = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(int) * n, NULL, NULL);
    cl_mem bufferResult = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(int) * n, NULL, NULL);

    // Copy input data to the buffers
    clEnqueueWriteBuffer(queue, bufferA, CL_TRUE, 0, sizeof(int) * n, a, 0, NULL, NULL);
    clEnqueueWriteBuffer(queue, bufferB, CL_TRUE, 0, sizeof(int) * n, b, 0, NULL, NULL);

    // Set kernel arguments
    clSetKernelArg(kernel, 0, sizeof(cl_mem), &bufferA);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), &bufferB);
    clSetKernelArg(kernel, 2, sizeof(cl_mem), &bufferResult);
    clSetKernelArg(kernel, 3, sizeof(unsigned int), &n);

    // Execute the kernel
    size_t globalWorkSize = n;
    clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &globalWorkSize, NULL, 0, NULL, NULL);

    // Read the results back
    clEnqueueReadBuffer(queue, bufferResult, CL_TRUE, 0, sizeof(int) * n, result, 0, NULL, NULL);

    // Print the result for verification
    for (unsigned int i = 0; i < 10; i++) {  // Print first 10 elements
        printf("%d + %d = %d\n", a[i], b[i], result[i]);
    }

    // Cleanup
    clReleaseMemObject(bufferA);
    clReleaseMemObject(bufferB);
    clReleaseMemObject(bufferResult);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    free(a);
    free(b);
    free(result);

    return 0;
}