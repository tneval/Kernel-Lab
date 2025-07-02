#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>

#define GLOBAL_SIZE_X 2
#define GLOBAL_SIZE_Y 1
#define LOCAL_SIZE_X 2
#define LOCAL_SIZE_Y 1

int main() {
    // Platform and device setup
    cl_platform_id platform;
    cl_device_id device;
    cl_context context;
    cl_command_queue queue;
    cl_program program;
    cl_kernel kernel;

    size_t global_work_size[3];
    size_t local_work_size[3];
    local_work_size[0] = 4;
    local_work_size[1] = 1;
    local_work_size[2] = 1;
    global_work_size[0] = local_work_size[0] * 1;
    global_work_size[1] = local_work_size[1];
    global_work_size[2] = local_work_size[2];


    size_t grid_size = global_work_size[0] * global_work_size[1] * global_work_size[2];

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
    kernel = clCreateKernel(program, "test_kernel", NULL);

    cl_mem outbuf = NULL;
  
      /* Input 4x the grid side of data to allow playing around with
         strided memory access patterns. Note that we read back only
         grid_size worth of data, so the output should be written to
         the lower part of the array. */
      cl_int *init_data = alloca (4 * grid_size * sizeof (cl_int));
      for (int i = 0; i < 4 * grid_size; ++i)
        {
          init_data[i] = 99;
        }
      outbuf
        = clCreateBuffer (context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
                          4 * grid_size * sizeof (cl_int), init_data, &err);

      err = clSetKernelArg (kernel, 0, sizeof (outbuf), &outbuf);


    // Enqueue kernel
    clEnqueueNDRangeKernel(queue, kernel, 2, NULL, global_work_size, local_work_size, 0, NULL, NULL);

    
    // Wait for execution to complete
    clFinish(queue);

    // Cleanup
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseCommandQueue(queue);
    clReleaseContext(context);

    return 0;
}