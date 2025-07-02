#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test_ids() {
    // Get global and local IDs
    int global_id = get_global_id(0);
    int local_id = get_local_id(0);
    //int sg_id = get_sub_group_id();
    int wg_id = get_group_id(0);
    //int sg_local_id = get_sub_group_local_id();
    //sub_group_barrier(CLK_LOCAL_MEM_FENCE);
/*     barrier(CLK_LOCAL_MEM_FENCE);
    // Print the IDs
    printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\n", global_id, local_id, wg_id);
    barrier(CLK_LOCAL_MEM_FENCE);
    printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\n", global_id, local_id, wg_id); */

    //sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    barrier(CLK_LOCAL_MEM_FENCE);
    printf("Past first barrier: Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\n", global_id, local_id, wg_id);
    //sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("Past second barrier: Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\n", global_id, local_id, wg_id);

}
