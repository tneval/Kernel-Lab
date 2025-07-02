#define SG_SIZE 4

__attribute ((intel_reqd_sub_group_size(SG_SIZE)))
__kernel void
basic_sg_barrier (void)
{
  int gid_x = get_global_id (0);
  int gid_y = get_global_id (1);
  int gid_z = get_global_id (2);

  int sg_id = get_sub_group_id();
  int sg_local_id = get_sub_group_local_id();

  printf ("WI:(%d %d %d) SG:[%d %d] - before workgroup barrier 1\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  barrier (CLK_LOCAL_MEM_FENCE);

  printf ("WI:(%d %d %d) SG:[%d %d] - after workgroup barrier 1\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  
  if (sg_id % 2 == 0) {
    printf ("WI:(%d %d %d) SG:[%d %d] - at subgroup barrier 1\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

    sub_group_barrier (CLK_LOCAL_MEM_FENCE);

    printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier 1\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

    printf ("WI:(%d %d %d) SG:[%d %d] - at subgroup barrier 2\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

    sub_group_barrier (CLK_LOCAL_MEM_FENCE);

    printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier 2\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  } else {
    printf ("WI:(%d %d %d) SG:[%d %d] - avoided sg barriers 1 and 2\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);
  }


  printf ("WI:(%d %d %d) SG:[%d %d] - before workgroup barrier 2\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  barrier (CLK_LOCAL_MEM_FENCE);
  
  printf ("WI:(%d %d %d) SG:[%d %d] - after workgroup barrier 2\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);


  if (sg_id % 2 == 1) {

    printf ("WI:(%d %d %d) SG:[%d %d] - at subgroup barrier 3\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

    sub_group_barrier (CLK_LOCAL_MEM_FENCE);

    printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier 3\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

    printf ("WI:(%d %d %d) SG:[%d %d] - at subgroup barrier 4\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

    sub_group_barrier (CLK_LOCAL_MEM_FENCE);

    printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier 4\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  } else {
    
    printf ("WI:(%d %d %d) SG:[%d %d] - avoided sg barriers 3 and 4\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);
  }


  printf ("WI:(%d %d %d) SG:[%d %d] - before workgroup barrier 3\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  barrier (CLK_LOCAL_MEM_FENCE);
  
  printf ("WI:(%d %d %d) SG:[%d %d] - after workgroup barrier 3\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);
}
