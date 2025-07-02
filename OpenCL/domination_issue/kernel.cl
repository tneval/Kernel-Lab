__kernel void Sdot_kernel(__global float* _X, __global float* _Y, __global float* scratchBuff,
                          uint N, uint offx, int incx, uint offy, int incy, int doConj)
{
    __global float* X = _X + offx;
    __global float* Y = _Y + offy;
    float dotP = (float) 0.0;

    if (incx < 0) {
        X = X + (N - 1) * abs(incx);
    }

    if (incy < 0) {
        Y = Y + (N - 1) * abs(incy);
    }

    int gOffset;
    // Loop for 4 elements per work item
    for (gOffset = (get_global_id(0) * 4); (gOffset + 4 - 1) < N; gOffset += (get_global_size(0) * 4))
    {
        float4 vReg1, vReg2, res;
        vReg1 = (float4)(
            (X + (gOffset * incx))[0 + (incx * 0)],
            (X + (gOffset * incx))[0 + (incx * 1)],
            (X + (gOffset * incx))[0 + (incx * 2)],
            (X + (gOffset * incx))[0 + (incx * 3)]
        );
        vReg2 = (float4)(
            (Y + (gOffset * incy))[0 + (incy * 0)],
            (Y + (gOffset * incy))[0 + (incy * 1)],
            (Y + (gOffset * incy))[0 + (incy * 2)],
            (Y + (gOffset * incy))[0 + (incy * 3)]
        );
        res = vReg1 * vReg2;
        dotP += res.S0 + res.S1 + res.S2 + res.S3;
    }

    // Loop for remaining elements
    for (; gOffset < N; gOffset++)
    {
        float sReg1, sReg2, res;
        sReg1 = X[gOffset * incx];
        sReg2 = Y[gOffset * incy];
        res = sReg1 * sReg2;
        dotP = dotP + res;
    }

    // Local memory buffer for reduction
    __local float p1753[64];
    uint QKiD0 = get_local_id(0);
    p1753[QKiD0] = dotP;

    // Local memory reduction
    barrier(CLK_LOCAL_MEM_FENCE);
    if (QKiD0 < 32) {
        p1753[QKiD0] = p1753[QKiD0] + p1753[QKiD0 + 32];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    if (QKiD0 < 16) {
        p1753[QKiD0] = p1753[QKiD0] + p1753[QKiD0 + 16];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    if (QKiD0 < 8) {
        p1753[QKiD0] = p1753[QKiD0] + p1753[QKiD0 + 8];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    if (QKiD0 < 4) {
        p1753[QKiD0] = p1753[QKiD0] + p1753[QKiD0 + 4];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    if (QKiD0 < 2) {
        p1753[QKiD0] = p1753[QKiD0] + p1753[QKiD0 + 2];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    if (QKiD0 == 0) {
        dotP = p1753[0] + p1753[1];
    }

    // Write result to global memory
    if ((get_local_id(0)) == 0) {
        scratchBuff[get_group_id(0)] = dotP;
    }
}