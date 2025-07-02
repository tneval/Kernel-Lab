#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test_ids() {
    // Get global and local IDs
    int global_id = get_global_id(0);
    int localx = get_local_id(0);
    int localy = get_local_id(1);
    int localz = get_local_id(2);
    int sg_id = get_sub_group_id();
    int wg_id = get_group_id(0);
    int sg_local_id = get_sub_group_local_id();
    int a = 1;

    //barrier(CLK_LOCAL_MEM_FENCE);
    a = a+1;
    barrier(CLK_LOCAL_MEM_FENCE);
    printf("(%d,%d,%d)\tSubgroup ID: %d\tSubgroup local ID: %d\n", localx,localy,localz, sg_id, sg_local_id);
    // Print the IDs
    //printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n", global_id, local_id, wg_id, sg_id, sg_local_id);

    //barrier(CLK_LOCAL_MEM_FENCE);

    //printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n", global_id, local_id, wg_id, sg_id, sg_local_id);
}