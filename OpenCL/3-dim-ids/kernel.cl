#define SUB_GROUP_SIZE 2

__kernel __attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE))) 
void test_subgroup_size_3d() {
    // Global IDs
    int global_id_x = get_global_id(0);
    int global_id_y = get_global_id(1);
    int global_id_z = get_global_id(2);

    // Local IDs
    int local_id_x = get_local_id(0);
    int local_id_y = get_local_id(1);
    int local_id_z = get_local_id(2);

    // Workgroup IDs
    int workgroup_id_x = get_group_id(0);
    int workgroup_id_y = get_group_id(1);
    int workgroup_id_z = get_group_id(2);

    // Subgroup ID
    int subgroup_id = get_sub_group_id();

    int sg_local_id = get_sub_group_local_id();

    // Print debug information
    printf("Global ID: (%d, %d, %d), Local ID: (%d, %d, %d), "
           "Workgroup ID: (%d, %d, %d), Subgroup ID: %d, Subgroup local id: %d\n",
           global_id_x, global_id_y, global_id_z,
           local_id_x, local_id_y, local_id_z,
           workgroup_id_x, workgroup_id_y, workgroup_id_z,
           subgroup_id, sg_local_id);
}