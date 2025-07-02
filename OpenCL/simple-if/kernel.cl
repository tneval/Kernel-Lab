#define SUB_GROUP_SIZE 4

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

  printf("ok\n");
/*
    // Local IDs
    int local_id_x = get_local_id(0);
    int local_id_y = get_local_id(1);
    int local_id_z = get_local_id(2);

    int loc_lin = get_local_linear_id();

    // Subgroup ID
    int subgroup_id = get_sub_group_id();

    int sg_local_id = get_sub_group_local_id();


    //barrier(CLK_LOCAL_MEM_FENCE);
    int a = 100;
    if(a==1){
        printf("aa\n");
        barrier(CLK_LOCAL_MEM_FENCE);
        printf("bb\n");
    }else if(a == 100){
        printf("asd\n");
        barrier(CLK_LOCAL_MEM_FENCE);
        printf("barr-asd\n");
    }else if(a == 30){
        printf("odd\n");
        barrier(CLK_LOCAL_MEM_FENCE);
        printf("indeed\n");
    }

    printf("CC\n"); */


   /*  size_t gid = get_global_id(0);
    int a = 2;
    printf("all should print this\n");
    if(a == 3){
        return;
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    if(gid==1){
        printf("ok\n");
    }else{
        printf("oh, right\n");
    } */
   /*  int b = 0;

    for(int i = 0; i< 4; i++){
        barrier(CLK_LOCAL_MEM_FENCE);

        b++;
    }
    printf("res: %d\n",b); */
     int local_id_x = get_local_id(0);
     int sg_id = get_sub_group_id();
    int a = 3;


  // CONDITIONAL SG-BARR WITHIN LOOP
/*
  for(int i = 0; i < 2; i++){
    if(sg_id == 0){
      printf("i: %d,  hello0, local_id: %d, sg-id: %d\n",i, local_id_x, sg_id);
      a = a + 4;
      sub_group_barrier(CLK_LOCAL_MEM_FENCE);
      printf("i: %d,  after0, local_id: %d, sg-id: %d\n",i, local_id_x, sg_id);

    }else{
    a = a+3;
    printf("i: %d, hello1, local_id: %d, sg-id: %d\n",i, local_id_x, sg_id);
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("i: %d, after1, local_id: %d, sg-id: %d\n",i, local_id_x, sg_id);
    }
  } */


    // SG IN LOOP
    /* for(int i = 0; i< 3; i++){
        a=a+1;
        sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    } */
    for(int i = 0; i< 2; i++){

        /* if(sg_id == 0){
          printf("hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
          a = a + 4;
          sub_group_barrier(CLK_LOCAL_MEM_FENCE);
          printf("after0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);

        }else if(sg_id == 1){
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
          printf("skipping barrs, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
        } */

        printf("hello\n");
        barrier(CLK_LOCAL_MEM_FENCE);
        printf("uuf\n");




        if(sg_id == 0){
          printf("hello0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);
          a = a + 4;
          sub_group_barrier(CLK_LOCAL_MEM_FENCE);
          printf("after0, local_id: %d, sg-id: %d\n", local_id_x, sg_id);

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



    barrier(CLK_LOCAL_MEM_FENCE);


    }

    printf("end\n");
   /*  printf("hello all\n");
    for(int z = 0; z<local_id_x; z++){
        if(local_id_x){
            printf("asd\n");
        }

    } */


    /*  int gid_x = get_global_id (0);

  for (volatile int i = 0; i < 3; ++i)
    {
      if (i == 1 && gid_x == 0)
        {
         printf("hello alli");
          return;
        }
     printf("hello alla");
      if (i == 1 && gid_x == 1)
        {
          printf("hello allf");
          return;
        }
      printf("hello allz");
    }
  if (gid_x > 3)
    {%cmp = icmp slt i32 %36, 2
      printf("hello ally");
    }
  else if (gid_x == 2)
    {
      printf("hello allx");
    }
 */
/*  barrier(CLK_LOCAL_MEM_FENCE);
 if(sg_id == 0){
    printf("hello0, local_id: %d\n", local_id_x);
    a = a + 4;
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("after0\n");

  }else {
    a = a+3;
    printf("hello1, local_id: %d\n", local_id_x);
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("after1\n");
  } */

}