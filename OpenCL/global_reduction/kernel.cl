#define SUB_GROUP_SIZE 2

#define LOCAL_SIZE 4

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void global_reduction(__global float* input_buffer, __global float* reduction_buffer) {

    __local float local_mem[LOCAL_SIZE];
    __local float local_input[LOCAL_SIZE];


    // Get global and local IDs
    int global_id = get_global_id(0);
    int local_id = get_local_id(0);
    int sg_id = get_sub_group_id();
    int wg_id = get_group_id(0);
    int sg_local_id = get_sub_group_local_id();



    local_input[local_id] = global_id;

    // Print the IDs
   
    printf("gid: %d\n", global_id);

    local_mem[global_id] = global_id;

    barrier(CLK_LOCAL_MEM_FENCE);

    for(int i = 0; i< 2; i++){
        
        barrier(CLK_LOCAL_MEM_FENCE);

        for(int j = 0 ; j<3; j++){

            barrier(CLK_LOCAL_MEM_FENCE);
            local_mem[global_id] = local_mem[global_id] + 2;
        }

    }

    printf("global id: %d, local id: %d, data: %f\n", global_id, local_id, local_mem[global_id]);

    barrier(CLK_LOCAL_MEM_FENCE);

    float acc = 0;

    if(local_id == 0){

        float input_sum = 0;

        for(int i = 0; i< LOCAL_SIZE; i++){
            input_sum = input_sum + local_input[i];
        }


        for(int i = wg_id * LOCAL_SIZE ; i< LOCAL_SIZE + wg_id*LOCAL_SIZE; i++){
            
            acc = acc + local_mem[i];
            printf("i: %d\t%f\n",i,acc);
        }

        reduction_buffer[wg_id] = acc;


        printf("wg-id: %d\t %f\n",wg_id, input_sum);

    }

    
}