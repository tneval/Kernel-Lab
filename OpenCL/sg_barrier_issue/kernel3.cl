#define SG_SIZE 2

__attribute ((intel_reqd_sub_group_size (SG_SIZE))) __kernel void
test (void)
{
  /* int gid_x = get_global_id (0);
  int gid_y = get_global_id (1);
  int gid_z = get_global_id (2);

  int sg_id = get_sub_group_id ();
  int sg_local_id = get_sub_group_local_id ();

  if (sg_id == 1)
    {
      printf ("WI:(%d %d %d) SG:[%d %d] - before subgroup barrier\n", gid_x,
              gid_y, gid_z, sg_id, sg_local_id);

      sub_group_barrier (CLK_LOCAL_MEM_FENCE);

      printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier\n", gid_x,
              gid_y, gid_z, sg_id, sg_local_id);
    }
  else if (sg_id == 0)
    {
      printf ("WI:(%d %d %d) SG:[%d %d] - sg 0\n", gid_x, gid_y,
              gid_z, sg_id, sg_local_id);
              sub_group_barrier (CLK_LOCAL_MEM_FENCE);
    }else {
        printf ("WI:(%d %d %d) SG:[%d %d] - not sg 0 or 1\n", gid_x, gid_y,
              gid_z, sg_id, sg_local_id);
}

printf ("WI:(%d %d %d) SG:[%d %d] - the end, all should end up here\n", gid_x, gid_y,
              gid_z, sg_id, sg_local_id); */


    int gid_x = get_global_id (0);
  int gid_y = get_global_id (1);
  int gid_z = get_global_id (2);

  int sg_id = get_sub_group_id ();
  int sg_local_id = get_sub_group_local_id ();

  if (sg_id == 1)
    {
      printf ("WI:(%d %d %d) SG:[%d %d] - before subgroup barrier\n", gid_x,
              gid_y, gid_z, sg_id, sg_local_id);

      sub_group_barrier (CLK_LOCAL_MEM_FENCE);

      printf ("WI:(%d %d %d) SG:[%d %d] - after subgroup barrier\n", gid_x,
              gid_y, gid_z, sg_id, sg_local_id);
    }
  else
    {
      printf ("WI:(%d %d %d) SG:[%d %d] - avoided sg barrier\n", gid_x, gid_y,
              gid_z, sg_id, sg_local_id);
    }

}