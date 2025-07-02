#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test_ids_3d() {
    // Get global and local IDs
    int global_id_x = get_global_id(0);
    int global_id_y = get_global_id(1);
    int global_id_z = get_global_id(2);
    int local_id_x = get_local_id(0);
    int local_id_y = get_local_id(1);
    int local_id_z = get_local_id(2);
    //int sg_id = get_sub_group_id();
    int sg_id = 1;
    int wg_id_x = get_group_id(0);
    int wg_id_y = get_group_id(1);
    int wg_id_z = get_group_id(2);
    //int sg_local_id = get_sub_group_local_id();
    int sg_local_id = 1;

    // Print the IDs
    printf("B1: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);

    printf("B2: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);

    printf("B3: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);

    printf("B4: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);

    printf("B5: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);

    printf("B6: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);

    printf("B7: Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), Workgroup ID: (%d,%d,%d), Subgroup ID: %d\tSubgroup local ID: %d\n", global_id_x, global_id_y, global_id_z, local_id_x, local_id_y, local_id_z, wg_id_x, wg_id_y, wg_id_z, sg_id, sg_local_id);

    barrier(CLK_LOCAL_MEM_FENCE);
    
   


}