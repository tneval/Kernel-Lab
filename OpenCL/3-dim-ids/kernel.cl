#define SUB_GROUP_SIZE 16

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {



    // Local IDs
    int local_id_x = get_local_id(0);
    int local_id_y = get_local_id(1);
    int local_id_z = get_local_id(2);

    int loc_lin = get_local_linear_id();

    // Subgroup ID
    int subgroup_id = get_sub_group_id();

    int sg_local_id = get_sub_group_local_id();

    if(subgroup_id ==0 ){
        //sub_group_barrier(CLK_LOCAL_MEM_FENCE);
        sub_group_barrier(CLK_LOCAL_MEM_FENCE);
        printf(" Local ID: (%d, %d, %d), "
            "Subgroup ID: %d, Subgroup local id: %d, local_linear_id: %d\n",
            local_id_x, local_id_y, local_id_z,
            subgroup_id, sg_local_id, loc_lin);
        //sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    }/* else if(subgroup_id == 1) {
        sub_group_barrier(CLK_LOCAL_MEM_FENCE);
        //barrier(CLK_LOCAL_MEM_FENCE);
        printf(" Local ID: (%d, %d, %d), "
            "Subgroup ID: %d, Subgroup local id: %d, local_linear_id: %d\n",
            local_id_x, local_id_y, local_id_z,
            subgroup_id, sg_local_id, loc_lin);


    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
        //barrier(CLK_LOCAL_MEM_FENCE);
        printf(" Local ID: (%d, %d, %d), "
            "Subgroup ID: %d, Subgroup local id: %d, local_linear_id: %d\n",
            local_id_x, local_id_y, local_id_z,
            subgroup_id, sg_local_id, loc_lin);
    } *//* else {
         sub_group_barrier(CLK_LOCAL_MEM_FENCE);
        //barrier(CLK_LOCAL_MEM_FENCE);
        printf(" Local ID: (%d, %d, %d), "
            "Subgroup ID: %d, Subgroup local id: %d, local_linear_id: %d\n",
            local_id_x, local_id_y, local_id_z,
            subgroup_id, sg_local_id, loc_lin);
    } */

    //sub_group_barrier(CLK_LOCAL_MEM_FENCE);

    printf("hello\n");
    //barrier(CLK_LOCAL_MEM_FENCE);

}