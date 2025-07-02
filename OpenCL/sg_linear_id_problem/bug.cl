// CAUSES BUG WITH WI-LOOPS: both sub-group go through the conditional
#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

  printf("ok\n");
  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);
  int local_id_z = get_local_id(2);
  int sg_id = get_sub_group_id();
  int loc_lin_id = get_local_linear_id();
  int sgs = get_sub_group_size();
  int a = 2;

  int val = 0xDA;

  int id = val >> local_id_x & 1;

  printf("x: %d, id: %d\n", local_id_x, id);

   printf("outer for before: hello0, local_id: (%d, %d, %d) :: sg-id: %d, LLID: %d, sgs: %d\n", local_id_x, local_id_y, local_id_z, sg_id, loc_lin_id, sgs);


  if(sg_id == 1){
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("outer2 for before: hello0, local_id: (%d, %d, %d) :: sg-id: %d, LLID: %d, sgs: %d\n", local_id_x, local_id_y, local_id_z, sg_id, loc_lin_id, sgs);

    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("outer3 for before: hello0, local_id: (%d, %d, %d) :: sg-id: %d, LLID: %d, sgs: %d\n", local_id_x, local_id_y, local_id_z, sg_id, loc_lin_id, sgs);
  }



  sub_group_barrier(CLK_LOCAL_MEM_FENCE);
  printf("outer4 for after: hello0, local_id: (%d, %d, %d) :: sg-id: %d, LLID: %d, sgs: %d\n", local_id_x, local_id_y, local_id_z, sg_id, loc_lin_id, sgs);


  barrier(CLK_LOCAL_MEM_FENCE);

  printf("end\n");

}