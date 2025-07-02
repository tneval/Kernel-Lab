// vector_add.cl
__kernel void vector_add(__global int *a, __global int *b, __global int *result, const unsigned int n) {
    // Get the global ID for this work-item
    int id = get_global_id(0);

    // Ensure we do not go out of bounds
    if (id < n) {
        result[id] = a[id] + b[id]; // Element-wise addition
    }
}