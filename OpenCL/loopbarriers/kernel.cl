kernel void
test_kernel (global int *output)
{
/* 
  size_t flat_id = get_global_id (2) * get_global_size (1)
                   + get_global_id (1) * get_global_size (0)
                   + get_global_id (0); */

    //printf("flat_id(%d), global_sizes: (%d, %d, %d)\n",flat_id,get_global_size (0),get_global_size (1),get_global_size (2));
    printf("get_global_size(0): %d\n",get_global_size(0));
  /* size_t grid_size
      = get_global_size (2) * get_global_size (1) * get_global_size (0);
    printf("flat_id (%d): grid_size(%d)\n",flat_id,grid_size); */

    /* int a = 5;

    printf("a(%d)\n",a); */

/* 
    output[flat_id] = flat_id;
    

    barrier (CLK_GLOBAL_MEM_FENCE);
    for(int i = 0; i<6; i++){
        printf("output[%d]: %d\n",i,output[i]);
    }
    barrier (CLK_GLOBAL_MEM_FENCE);
    
    long temp;
    printf("comparing: %d and griz_size %d\n", flat_id, grid_size-1);
    if(flat_id == grid_size-1){
        printf("a\n");
        temp = output[0];
    }else{
        printf("b\n");
        temp = output[flat_id+1];
    }
    //long temp = output[flat_id + 1 == grid_size ? 0 : (flat_id + 1)];
    printf("flat_id(%d): %ld\n",flat_id, temp); */

  //printf ("a. flat_id %d lid %d\n", flat_id, get_local_id (0));
  /* for (volatile int i = 0; i < 3; ++i)
    {
      printf("i: %d\n",i);
      output[flat_id] = flat_id * 1000 + i;
      //printf ("b. flat_id %d i %d lid %d\n", flat_id, i, get_local_id (0));
      printf("output[%d]: %d\n", flat_id, output[flat_id]);
      barrier (CLK_GLOBAL_MEM_FENCE);
      //printf ("c. flat_id %d i %d lid %d\n", flat_id, i, get_local_id (0));
        printf("after first barrier: output[%d]: %d\n", flat_id, output[flat_id]);
      int temp = output[flat_id + 1 == grid_size ? 0 : (flat_id + 1)];
        printf("temp before barrier: %d\n",temp );
      barrier (CLK_GLOBAL_MEM_FENCE);
      //If the barrier was ignored, we are likely copying
         //a zero from the neighbour's slot or the previous
         //value (in case the iterations are executed in
         //lock step).
      output[flat_id] = temp;
      printf("output[%d]: %d\n",i, temp);
      //printf ("d. flat_id %d i %d lid %d\n", flat_id, i, get_local_id (0));
    } */
}