#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>


#define GLOBAL_SIZE 32
#define LOCAL_SIZE 16



const char* source =
"__kernel void Sdot_kernel(__global float *_X, __global float *_Y, __global float *scratchBuff,\n"
"                          uint N, uint offx, int incx, uint offy, int incy, int doConj)\n"
"{\n"
"__global float *X = _X + offx;\n"
"__global float *Y = _Y + offy;\n"
"float dotP = (float) 0.0;\n"
"if ( incx < 0 ) {\n"
"X = X + (N - 1) * abs(incx);\n"
"}\n"
"if ( incy < 0 ) {\n"
"Y = Y + (N - 1) * abs(incy);\n"
"}\n"
"int gOffset;\n"
"for( gOffset=(get_global_id(0) * 4); (gOffset + 4 - 1)<N; gOffset+=( get_global_size(0) * 4 ) )\n"
"{\n"
"float4 vReg1, vReg2, res;\n"
"vReg1 = (float4)(  (X + (gOffset*incx))[0 + ( incx * 0)],  (X + (gOffset*incx))[0 + ( incx * 1)],  (X + (gOffset*incx))[0 + ( incx * 2)],  (X + (gOffset*incx))[0 + ( incx * 3)]);\n"
"vReg2 = (float4)(  (Y + (gOffset*incy))[0 + ( incy * 0)],  (Y + (gOffset*incy))[0 + ( incy * 1)],  (Y + (gOffset*incy))[0 + ( incy * 2)],  (Y + (gOffset*incy))[0 + ( incy * 3)]);\n"
"res =  vReg1 *  vReg2 ;\n"
"dotP +=  res .S0 +  res .S1 +  res .S2 +  res .S3;\n"
"}\n"
"for( ; gOffset<N; gOffset++ )\n"
"{\n"
"float sReg1, sReg2, res;\n"
"sReg1 = X[gOffset * incx];\n"
"sReg2 = Y[gOffset * incy];\n"
"res =  sReg1 *  sReg2 ;\n"
"dotP =  dotP +  res ;\n"
"}\n"
"__local float p1753 [ 64 ];\n"
"uint QKiD0 = get_local_id(0);\n"
"p1753 [ QKiD0 ] =  dotP ;\n"
"barrier(CLK_LOCAL_MEM_FENCE);\n"
"if( QKiD0 < 32 ) {\n"
"p1753 [ QKiD0 ] = p1753 [ QKiD0 ] + p1753 [ QKiD0 + 32 ];\n"
"}\n"
"barrier(CLK_LOCAL_MEM_FENCE);\n"
"if( QKiD0 < 16 ) {\n"
"p1753 [ QKiD0 ] = p1753 [ QKiD0 ] + p1753 [ QKiD0 + 16 ];\n"
"}\n"
"barrier(CLK_LOCAL_MEM_FENCE);\n"
"if( QKiD0 < 8 ) {\n"
"p1753 [ QKiD0 ] = p1753 [ QKiD0 ] + p1753 [ QKiD0 + 8 ];\n"
"}\n"
"barrier(CLK_LOCAL_MEM_FENCE);\n"
"if( QKiD0 < 4 ) {\n"
"p1753 [ QKiD0 ] = p1753 [ QKiD0 ] + p1753 [ QKiD0 + 4 ];\n"
"}\n"
"barrier(CLK_LOCAL_MEM_FENCE);\n"
"if( QKiD0 < 2 ) {\n"
"p1753 [ QKiD0 ] = p1753 [ QKiD0 ] + p1753 [ QKiD0 + 2 ];\n"
"}\n"
"barrier(CLK_LOCAL_MEM_FENCE);\n"
"if( QKiD0 == 0 ) {\n"
"dotP  = p1753 [0] + p1753 [1];\n"
"}\n"
"if( (get_local_id(0)) == 0 ) {\n"
"scratchBuff[ get_group_id(0) ] = dotP;\n"
"}\n"
"}\n"
;


// Helper macro for error checking
#define CHECK_CL_ERROR(err, msg) \
    if (err != CL_SUCCESS) { \
        fprintf(stderr, "Error: %s (%d)\n", msg, err); \
        exit(EXIT_FAILURE); \
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
    cl_program program
    = clCreateProgramWithSource (context, 1, &source, NULL, &err);



    clBuildProgram (program, 1, &device, "-g", NULL, NULL);


    size_t binsizes[32];
  size_t nbinaries;
  clGetProgramInfo (program, CL_PROGRAM_BINARY_SIZES,
                                    sizeof (binsizes), binsizes, &nbinaries);
  for (size_t i = 0; i < nbinaries; ++i)
    printf ("binary size [%zd]: %zd\n", i, binsizes[i]);



    printf("Program finished successfully.\n");
    return 0;
}
