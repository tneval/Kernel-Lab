#define SUB_GROUP_SIZE 2

#define LOCAL_SIZE 8

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void nested_for() {

    __local int local_mem[LOCAL_SIZE];


    // Get global and local IDs
    int global_id = get_global_id(0);
    int local_id = get_local_id(0);
    int sg_id = get_sub_group_id();
    int wg_id = get_group_id(0);
    int sg_local_id = get_sub_group_local_id();

    // Print the IDs

    printf("gid: %d\n", global_id);

    local_mem[local_id] = 0;

    barrier(CLK_LOCAL_MEM_FENCE);

    for(int i = 0; i< 2; i++){
        printf("outer\n");
        local_mem[local_id] = local_mem[local_id] + 1;
        sub_group_barrier(CLK_LOCAL_MEM_FENCE);

        /* for(int j = 0 ; j<3; j++){
            printf("inner\n");
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            local_mem[local_id] = local_mem[local_id] + 1;
        } */

    }

    printf("global id: %d, local id: %d, data: %f\n", global_id, local_id, local_mem[global_id]);

    barrier(CLK_LOCAL_MEM_FENCE);

    if(local_id == 0){

        for(int i = 0; i<LOCAL_SIZE; i++){
            printf("i: %d\t%d\n", i, local_mem[i]);
        }

    }

}