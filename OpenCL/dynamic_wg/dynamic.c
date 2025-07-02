#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

#define GLOBAL_SIZE_X 8
#define GLOBAL_SIZE_Y 4
#define LOCAL_SIZE_X 4
#define LOCAL_SIZE_Y 2

int main() {
    // Platform and device setup
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;

    // Load kernel source from file
    FILE *kernel_file = fopen("kernel.cl", "r");
    if (!kernel_file) {
        perror("Failed to open kernel file");
        return 1;
    }
    fseek(kernel_file, 0, SEEK_END);
    size_t kernel_size = ftell(kernel_file);
    rewind(kernel_file);
    char *kernel_source = (char *)malloc(kernel_size + 1);
    fread(kernel_source, 1, kernel_size, kernel_file);
    kernel_source[kernel_size] = '\0';
    fclose(kernel_file);

    size_t global_size[2] = {GLOBAL_SIZE_X, GLOBAL_SIZE_Y};
    size_t local_size[2] = {LOCAL_SIZE_X, LOCAL_SIZE_Y};

    // OpenCL setup
    clGetPlatformIDs(1, &platform, NULL);
    clGetDeviceIDs(platform, CL_DEVICE_TYPE_DEFAULT, 1, &device, NULL);
    context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);
    queue = clCreateCommandQueue(context, device, 0, NULL);

    // Create program from kernel source
    program = clCreateProgramWithSource(context, 1, (const char **)&kernel_source, &kernel_size, NULL);
    free(kernel_source);

    // Build program
    cl_int err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        char build_log[16384];
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, sizeof(build_log), build_log, NULL);
        fprintf(stderr, "Kernel build error: %s\n", build_log);
        return 1;
    }

    // Create kernel
    kernel = clCreateKernel(program, "test_subgroup_size_2d", NULL);

    // Enqueue kernel
    clEnqueueNDRangeKernel(queue, kernel, 2, NULL, global_size, NULL, 0, NULL, NULL);

    // Wait for execution to complete
    clFinish(queue);

    // Cleanup
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    return 0;
}