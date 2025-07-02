#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

  printf("ok\n");
  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);
  int local_id_z = get_local_id(2);
  int sg_id = get_sub_group_id();
  int a = 2;



  if(a==2){

    for(int i = 0; i< sg_id+1; i++){

      printf("outer for before: hello0, local_id: (%d, %d, %d) :: sg-id: %d\n", local_id_x, local_id_y, local_id_z, sg_id);
      /* sub_group_barrier(CLK_LOCAL_MEM_FENCE);
      printf("outer2 for before: hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id); */

       /*  printf("hello\n");
        barrier(CLK_LOCAL_MEM_FENCE);
        printf("uuf\n"); */

      for(int j = 0; j< sg_id+1; j++){

        printf("eh\n");

         if(sg_id == 1){
          printf("inner for: hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
          //a = a + 4;
          sub_group_barrier(CLK_LOCAL_MEM_FENCE);
          printf("inner for: after0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);

        /* }else if(sg_id == 1){
          a = a+3;
          printf("hello1, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
          sub_group_barrier(CLK_LOCAL_MEM_FENCE);
          printf("after1, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }else if(sg_id == 2){
          a = a+6;
          printf("hello2, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
          sub_group_barrier(CLK_LOCAL_MEM_FENCE);
          printf("after2, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        }else{
          printf("skipping barrs, local_id: %d, sg-id: %d\n", local_id_x, sg_id); */
        }
        printf("??\n");
      }


      //barrier(CLK_LOCAL_MEM_FENCE);
      printf("outer for after: hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);


      //barrier(CLK_LOCAL_MEM_FENCE);

    }
  }
  printf("end\n");

}