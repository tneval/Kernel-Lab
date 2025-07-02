#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM_WORK_ITEMS 32

const char *kernel_source =
"#pragma OPENCL EXTENSION cl_khr_subgroups : enable\n"
"__kernel void ballot_example(__global uint *input, __global uint4 *output) {\n"
"    int gid = get_global_id(0);\n"
"    int predicate = input[gid] % 2 == 0;\n"
"    uint4 result = sub_group_ballot(predicate);\n"
"    output[gid] = result;\n"
"}\n";

void check_error(cl_int err, const char *operation) {
    if (err != CL_SUCCESS) {
        printf("Error during operation '%s', error code: %d\n", operation, err);
        exit(1);
    }
}

int main() {
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;
    cl_int err;

    err = clGetPlatformIDs(1, &platform, NULL);
    check_error(err, "clGetPlatformIDs");

    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
    check_error(err, "clGetDeviceIDs");

    context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
    check_error(err, "clCreateContext");

    queue = clCreateCommandQueue(context, device, 0, &err);
    check_error(err, "clCreateCommandQueue");

    program = clCreateProgramWithSource(context, 1, &kernel_source, NULL, &err);
    check_error(err, "clCreateProgramWithSource");

    err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        char log[2048];
        clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, sizeof(log), log, NULL);
        printf("Build log:\n%s\n", log);
        exit(1);
    }

    kernel = clCreateKernel(program, "ballot_example", &err);
    check_error(err, "clCreateKernel");

    // Allocate and initialize input/output buffers
    cl_mem input_buf, output_buf;
    unsigned int input[NUM_WORK_ITEMS], output[NUM_WORK_ITEMS * 4]; // uint4 * NUM_WORK_ITEMS
    for (int i = 0; i < NUM_WORK_ITEMS; i++) input[i] = i;

    input_buf = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,
                               sizeof(unsigned int) * NUM_WORK_ITEMS, input, &err);
    check_error(err, "clCreateBuffer input");

    output_buf = clCreateBuffer(context, CL_MEM_WRITE_ONLY,
                                sizeof(unsigned int)*4 * NUM_WORK_ITEMS, NULL, &err);
    check_error(err, "clCreateBuffer output");

    err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &input_buf);
    check_error(err, "clSetKernelArg input");

    err = clSetKernelArg(kernel, 1, sizeof(cl_mem), &output_buf);
    check_error(err, "clSetKernelArg output");

    // Execute kernel
    size_t global_size = NUM_WORK_ITEMS;
    err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size, NULL, 0, NULL, NULL);
    check_error(err, "clEnqueueNDRangeKernel");

    // Read back results
    err = clEnqueueReadBuffer(queue, output_buf, CL_TRUE, 0, sizeof(unsigned int)*4 * NUM_WORK_ITEMS, output, 0, NULL, NULL);
    check_error(err, "clEnqueueReadBuffer");

    // Print results
    for (int i = 0; i < NUM_WORK_ITEMS; i++) {
        printf("Work-item %d Ballot: (%u, %u, %u, %u)\n", i, output[i * 4], output[i * 4 + 1], output[i * 4 + 2], output[i * 4 + 3]);
    }

    // Cleanup
    clReleaseMemObject(input_buf);
    clReleaseMemObject(output_buf);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    return 0;
}
