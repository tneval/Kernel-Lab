#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

// Function to read kernel source from a file
char* read_kernel_source(const char* filename, size_t* length) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        perror("Failed to open kernel source file");
        exit(EXIT_FAILURE);
    }

    // Get file size
    fseek(file, 0, SEEK_END);
    *length = ftell(file);
    rewind(file);

    // Allocate memory for the source code
    char* source = (char*)malloc((*length + 1) * sizeof(char));
    if (source == NULL) {
        perror("Failed to allocate memory for kernel source");
        exit(EXIT_FAILURE);
    }

    // Read the file into the source buffer
    fread(source, sizeof(char), *length, file);
    source[*length] = '\0';  // Null-terminate the string

    fclose(file);
    return source;
}

int main() {
    cl_int err;
    cl_context context;
    cl_device_id device;
    cl_platform_id platform;
    cl_command_queue command_queue;

    // Step 1: Get the first available OpenCL platform
    err = clGetPlatformIDs(1, &platform, NULL);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to get platform ID: %d\n", err);
        return EXIT_FAILURE;
    }

    // Step 2: Get the first available device from the platform (we assume a GPU, you can modify this to choose other types)
    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to get device ID: %d\n", err);
        return EXIT_FAILURE;
    }

    // Step 3: Create an OpenCL context for the selected device
    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to create context: %d\n", err);
        return EXIT_FAILURE;
    }

    // Step 4: Create a command queue for the selected device
    command_queue = clCreateCommandQueue(context, device, 0, &err);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to create command queue: %d\n", err);
        clReleaseContext(context);
        return EXIT_FAILURE;
    }
    
    // Read kernel source from file
    size_t kernel_length;
    char* source = read_kernel_source("kernel.cl", &kernel_length);

    // Create program from source code
    cl_program program = clCreateProgramWithSource(context, 1, (const char**)&source, &kernel_length, &err);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to create program: %d\n", err);
        return EXIT_FAILURE;
    }

    // Build the program
    err = clBuildProgram(program, 1, &device, "-g", NULL, NULL);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to build program: %d\n", err);
        return EXIT_FAILURE;
    }

    // Check binary size
    size_t binsizes[32];
    size_t nbinaries;
    err = clGetProgramInfo(program, CL_PROGRAM_BINARY_SIZES, sizeof(binsizes), binsizes, &nbinaries);
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Failed to get binary size: %d\n", err);
        return EXIT_FAILURE;
    }

    for (size_t i = 0; i < nbinaries; ++i)
        printf("binary size [%zd]: %zd\n", i, binsizes[i]);

    // Release resources
    clReleaseProgram(program);
    clReleaseCommandQueue(command_queue);
    clReleaseContext(context);


    printf("OK\n");
    return EXIT_SUCCESS;
}