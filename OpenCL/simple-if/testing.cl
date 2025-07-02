#define SUB_GROUP_SIZE 4

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

    printf("ok\n");
    int local_id_x = get_local_id(0);
    int sg_id = get_sub_group_id();
    int a = 3;


    // THIS IS NOT WORKING

    if(sg_id == 0){

        /* a= a+1;
        barrier(CLK_LOCAL_MEM_FENCE);
        a= a+1; */

        for(int i = 0; i< 2; i++){
            printf("hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
            a = a + 4;
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("after0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }
    }else{
             printf("others0 local_id: %d, sg-id: %d\n", local_id_x, sg_id);
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("others1 local_id: %d, sg-id: %d\n", local_id_x, sg_id);
    }
    a=a+1;
    printf("sumthing\n");
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("after sg\n");

    for(int i = 0; i<2 ; i++){
        barrier(CLK_LOCAL_MEM_FENCE);
        a = a+1;
    }

    printf("end\n");
}