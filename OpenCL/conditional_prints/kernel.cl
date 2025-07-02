/* #define SG_SIZE 2
__attribute ((intel_reqd_sub_group_size(SG_SIZE))) */
__kernel void
kernel23 (void)
{
  int gid_x = get_global_id (0);
  int gid_y = get_global_id (1);
  int gid_z = get_global_id (2);

  //int sg_id = get_sub_group_id();
  //int sg_local_id = get_sub_group_local_id();

  
  if(gid_x < 2){
    printf("okok\n");
  }
}
