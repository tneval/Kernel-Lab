#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test_ids() {
    // Get global and local IDs
    int global_id = get_global_id(0);
    int local_id = get_local_id(0);
    int sg_id = get_sub_group_id();
    int wg_id = get_group_id(0);
    int sg_local_id = get_sub_group_local_id();

    int a = 0;
    for(int i = 0; i< 2; i++){
        a = a+1;
    }
    printf("%d\n",a);
/*
    int b = 0;
    for(int i = 0; i< 4; i++){
        for(int z = 0; z< 2 ; z++){
            b=b+2;
            for(int k = 0; k<3; k++){
                b = b+2;
            }
        }

        b = a+1;
    }

    int c = 0;
    for(int i = 0; i< 4; i++){
        c = b+1;
    } */

    // Print the IDs
    //printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n", global_id, local_id, wg_id, sg_id, sg_local_id);

    //barrier(CLK_LOCAL_MEM_FENCE);

    //printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n", global_id, local_id, wg_id, sg_id, sg_local_id);
}