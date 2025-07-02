#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {


    int local_id_x = get_local_id(0);
    int sg_id = get_sub_group_id();
    int a = 3;

    printf("begin, local_id: %d, sg-id: %d\n", local_id_x, sg_id);

    for(int i = 0; i< 2; i++){


        printf("sg_id: %d\n", sg_id);

        if(sg_id == 1){
            printf("hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
            //a = a + 4;
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("after0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }
        printf("final, local_id: %d, sg-id: %d\n", local_id_x, sg_id);

    }
    printf("end, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
}