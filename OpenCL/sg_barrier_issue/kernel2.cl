#define SUB_GROUP_SIZE 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

  printf("ok\n");
  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);
  int local_id_z = get_local_id(2);
  int sg_id = get_sub_group_id();
  int sg_local_id = get_sub_group_local_id();
  int llid = get_local_linear_id();
  int a = 2;

printf("ok, local_id: %d, sg-id: %d, sg-local-id: %d, llid: %d\n", local_id_x, sg_id, sg_local_id, llid);
  if(sg_id == 1){
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("fok, local_id: %d, sg-id: %d, sg-local-id: %d, llid: %d\n", local_id_x, sg_id, sg_local_id, llid);
  }




  printf("end\n");

}