#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>


#define GLOBAL_SIZE 4
#define LOCAL_SIZE 2


// Helper macro for error checking
#define CHECK_CL_ERROR(err, msg) \
    if (err != CL_SUCCESS) { \
        fprintf(stderr, "Error: %s (%d)\n", msg, err); \
        exit(EXIT_FAILURE); \
    }

char* readKernelFile(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Failed to open kernel file: %s\n", filename);
        exit(EXIT_FAILURE);
    }

    fseek(file, 0, SEEK_END);
    size_t size = ftell(file);
    rewind(file);

    char* source = (char*)malloc(size + 1);
    if (!source) {
        fprintf(stderr, "Failed to allocate memory for kernel source\n");
        exit(EXIT_FAILURE);
    }

    fread(source, 1, size, file);
    source[size] = '\0';

    fclose(file);
    return source;
}

int main() {
    cl_int err;

    // Get platform and device
    cl_platform_id platform;
    cl_device_id device;
    err = clGetPlatformIDs(1, &platform, NULL);
    CHECK_CL_ERROR(err, "Failed to get platform ID");
    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_DEFAULT, 1, &device, NULL);
    CHECK_CL_ERROR(err, "Failed to get device ID");

    // Create context and command queue
    cl_context context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    CHECK_CL_ERROR(err, "Failed to create context");
    cl_command_queue queue = clCreateCommandQueue(context, device, 0, &err);
    CHECK_CL_ERROR(err, "Failed to create command queue");

    // Read and build kernel
    char* kernelSource = readKernelFile("kernel.cl");
    cl_program program = clCreateProgramWithSource(context, 1, (const char**)&kernelSource, NULL, &err);
    free(kernelSource);
    CHECK_CL_ERROR(err, "Failed to create program");
    err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        size_t logSize;
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &logSize);
        char* log = (char*)malloc(logSize);
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, logSize, log, NULL);
        fprintf(stderr, "Build log:\n%s\n", log);
        free(log);
        exit(EXIT_FAILURE);
    }

    float reduction_array[GLOBAL_SIZE/LOCAL_SIZE];

    float input_array[GLOBAL_SIZE];
    for(int i = 0; i< GLOBAL_SIZE; i++){
        input_array[i] = i%LOCAL_SIZE;
        printf("i: %d\t %f\n",i, input_array[i]);
    }

    cl_mem input_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(float)*GLOBAL_SIZE, input_array, &err);
    cl_mem buffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, sizeof(float) * (GLOBAL_SIZE/LOCAL_SIZE), reduction_array, &err);
    

    // Create kernel
    cl_kernel kernel = clCreateKernel(program, "test_kernel", &err);
    CHECK_CL_ERROR(err, "Failed to create kernel");

    clSetKernelArg(kernel, 0, sizeof(cl_mem),&buffer);

    // Define ND-range
    size_t globalSize = GLOBAL_SIZE; // Total number of work-items
    size_t localSize = LOCAL_SIZE;   // Work-items per work-group

    // Enqueue kernel
    err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &globalSize, &localSize, 0, NULL, NULL);
    CHECK_CL_ERROR(err, "Failed to enqueue kernel");

    // Finish the queue
    clFinish(queue);



    clEnqueueReadBuffer(queue, buffer, CL_TRUE, 0, sizeof(float) * (GLOBAL_SIZE/LOCAL_SIZE), reduction_array, 0, NULL, NULL);

    for(int i = 0; i< GLOBAL_SIZE/LOCAL_SIZE; i++){
        printf("wg %d: val: %f\n",i,reduction_array[i]);
    }


    // Cleanup
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    printf("Program finished successfully.\n");
    return 0;
}