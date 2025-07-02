__kernel void
test()
{
  //__local int scratch[256]; // max wg size: 256

  const int gid_x = get_global_id (0);
  const int gid_y = get_global_id (1);
  const int gid_z = get_global_id (2);

  int lidx = get_local_id(0);

    int a = 3;
    const int global_id = gid_x + get_global_size (0) * (gid_y + get_global_size (1) * gid_z);

    const int local_id = get_local_id (0) + get_local_size (0) * (get_local_id (1) + get_local_size (1) * get_local_id (2));

    int group_id = global_id / (get_local_size (0) * get_local_size (1) * get_local_size (2));

    //printf("global_id: %d, local_id: %d, group_id: %d\n",global_id, local_id, group_id);


    for(int i = 0; i< 4; i++){
        printf("at loop\n");
        if(group_id >= 0){
            printf("hello0 from: %d \n", lidx);
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("hello1 from: %d \n", lidx);

        }else{
            printf("skipiing\n");
        }   //barrier(CLK_LOCAL_MEM_FENCE);

    }
}