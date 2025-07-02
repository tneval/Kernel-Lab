#define SUB_GROUP_SIZE 4

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

    printf("ok\n");
    int local_id_x = get_local_id(0);
    int sg_id = get_sub_group_id();
    int a = 3;


    for(int i = 0; i< 2; i++){

        printf("hello\n");
        barrier(CLK_LOCAL_MEM_FENCE);
        printf("uuf\n");

        if(sg_id == 0){
          printf("hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
          a = a + 4;
          sub_group_barrier(CLK_LOCAL_MEM_FENCE);
          printf("after0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }else if(sg_id == 1){
            printf("asda local_id: %d, sg-id: %d\n", local_id_x, sg_id);
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("yyh local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }else{
            printf("others0 local_id: %d, sg-id: %d\n", local_id_x, sg_id);
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("others1 local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }

        barrier(CLK_LOCAL_MEM_FENCE);


        for(int i= 0; i<2 ;i++){

            if(sg_id == 0){
                printf("inner0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
                a = a + 4;
                sub_group_barrier(CLK_LOCAL_MEM_FENCE);
                printf("inner1, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
            }
            barrier(CLK_LOCAL_MEM_FENCE);
        }


    }
    printf("end\n");
}