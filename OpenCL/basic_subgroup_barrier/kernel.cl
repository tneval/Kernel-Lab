#define SG_SIZE 2
__attribute ((intel_reqd_sub_group_size(SG_SIZE)))
__kernel void
basic_sg_barrier (void)
{
  int gid_x = get_global_id (0);
  int gid_y = get_global_id (1);
  int gid_z = get_global_id (2);

  int sg_id = get_sub_group_id();
  int sg_local_id = get_sub_group_local_id();

  barrier(CLK_LOCAL_MEM_FENCE);

  printf ("WI:(%d %d %d) SG:[%d %d] - before subgroup barrier\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  sub_group_barrier(CLK_LOCAL_MEM_FENCE);

  printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier\n", gid_x, gid_y, gid_z, sg_id, sg_local_id);

  barrier(CLK_LOCAL_MEM_FENCE);

}
