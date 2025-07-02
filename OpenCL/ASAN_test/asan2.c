#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

#define DATA_SIZE 10

const char *kernel_source =
"__kernel void out_of_bounds(__global int *data, int size) {"
"    int gid = get_global_id(0);"
"    if (gid == 0) {"
"        int out_of_bounds_value = data[size+5];"
"        data[size+6] = out_of_bounds_value + 1;"
"	printf(\"HELLO: %d\\n\",out_of_bounds_value); "
"    }"
"}";

void checkError(cl_int err, const char *operation) {
    if (err != CL_SUCCESS) {
        fprintf(stderr, "Error during operation '%s': %d\n", operation, err);
        exit(1);
    }
}

int main() {
    cl_int err;
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;
    cl_mem buffer;

    int *host_data = (int *)malloc(DATA_SIZE * sizeof(int));
    for (int i = 0; i < DATA_SIZE; i++) host_data[i] = i;

    err = clGetPlatformIDs(1, &platform, NULL);
    checkError(err, "clGetPlatformIDs");

    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, NULL);
    checkError(err, "clGetDeviceIDs");

    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    checkError(err, "clCreateContext");

    queue = clCreateCommandQueueWithProperties(context, device, 0, &err);
    checkError(err, "clCreateCommandQueueWithProperties");

    buffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
                            DATA_SIZE * sizeof(int), host_data, &err);
    checkError(err, "clCreateBuffer");

    program = clCreateProgramWithSource(context, 1, &kernel_source, NULL, &err);
    checkError(err, "clCreateProgramWithSource");

    err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    checkError(err, "clBuildProgram");

    kernel = clCreateKernel(program, "out_of_bounds", &err);
    checkError(err, "clCreateKernel");

    err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer);
    checkError(err, "clSetKernelArg");

    int size = DATA_SIZE;
    err = clSetKernelArg(kernel, 1, sizeof(int), &size);
    checkError(err, "clSetKernelArg");

    size_t global_size = 1;
    err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size, NULL, 0, NULL, NULL);
    checkError(err, "clEnqueueNDRangeKernel");

    err = clFinish(queue);
    checkError(err, "clFinish");

    clReleaseMemObject(buffer);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);
    free(host_data);

    printf("Done! If running under ASAN/Valgrind, check for memory errors.\n");
    return 0;
}
