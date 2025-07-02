#include <stdio.h>
#include <stdlib.h>
#include <CL/cl.h>

#define MAX_SOURCE_SIZE 1024
#define CHECK_ERROR(err, msg) \
    if (err != CL_SUCCESS) { \
        fprintf(stderr, "%s failed: %d\n", msg, err); \
        exit(EXIT_FAILURE); \
    }

int main() {
    // Load kernel source
    FILE *fp = fopen("kernel.cl", "r");
    if (!fp) {
        perror("Kernel file not found");
        return EXIT_FAILURE;
    }

    char *source = (char *)malloc(MAX_SOURCE_SIZE);
    if (!source) {
        perror("Failed to allocate memory for kernel source");
        fclose(fp);
        return EXIT_FAILURE;
    }

    size_t source_size = fread(source, 1, MAX_SOURCE_SIZE, fp);
    fclose(fp);

    if (source_size == 0) {
        fprintf(stderr, "Kernel file is empty or read error\n");
        free(source);
        return EXIT_FAILURE;
    }
    source[source_size] = '\0'; // Null-terminate

    // OpenCL setup
    cl_int err;
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;

    err = clGetPlatformIDs(1, &platform, NULL);
    CHECK_ERROR(err, "clGetPlatformIDs");

    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
    CHECK_ERROR(err, "clGetDeviceIDs");

    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    CHECK_ERROR(err, "clCreateContext");

    queue = clCreateCommandQueue(context, device, 0, &err);
    CHECK_ERROR(err, "clCreateCommandQueue");

    program = clCreateProgramWithSource(context, 1, (const char **)&source, &source_size, &err);
    free(source); // Free the kernel source memory
    CHECK_ERROR(err, "clCreateProgramWithSource");

    err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        size_t log_size;
        char *log;
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);
        log = (char *)malloc(log_size);
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, log_size, log, NULL);
        fprintf(stderr, "Error during build: %s\n", log);
        free(log);
        return EXIT_FAILURE;
    }

    kernel = clCreateKernel(program, "print_ids", &err);
    CHECK_ERROR(err, "clCreateKernel");

    // Set global size, local size, and offsets
    size_t global_size[3] = {4, 4, 4};      // Global work size (4x4x4)
    size_t local_size[3] = {2, 2, 2};       // Local work size (2x2x2)
    size_t global_offset[3] = {10, 20, 30}; // Global offsets (10, 20, 30)

    // Enqueue the kernel
    err = clEnqueueNDRangeKernel(queue, kernel, 3, global_offset, global_size, local_size, 0, NULL, NULL);
    CHECK_ERROR(err, "clEnqueueNDRangeKernel");

    // Wait for completion
    err = clFinish(queue);
    CHECK_ERROR(err, "clFinish");

    // Cleanup
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    printf("Kernel execution completed.\n");
    return 0;
}
