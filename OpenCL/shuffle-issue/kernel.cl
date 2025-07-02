#define SUB_GROUP_SIZE 8
#define SHUFFLE_AMOUNT 2

__attribute__((intel_reqd_sub_group_size(SUB_GROUP_SIZE)))
__kernel void test() {

  int res = get_local_linear_id();
  int fallback_value = 99;
  res = intel_sub_group_shuffle_down(res, fallback_value, SHUFFLE_AMOUNT);
  printf("%d\n", res);
}