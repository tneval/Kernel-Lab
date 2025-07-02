#define SUB_GROUP_SIZE 4

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

  //printf("ok\n");

  int local_id_x = get_local_id(0);
  int sg_id = get_sub_group_id();
  int a = 3;


  if(sg_id == 0){
    printf("ff\n");
    if(a > 0){
      sub_group_ballot(a);
      printf("a localID: %d, sg_id: %d\n", local_id_x, sg_id);
    }

  }else{
    printf("b localID: %d, sg_id: %d\n", local_id_x, sg_id);
  }



}