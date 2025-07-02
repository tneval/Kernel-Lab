/**
 * Test the outer loop parallelization using the implicit loop barriers
 * added by pocl.
 *
 * The barrier should be inserted inside a barrierless loop in case pocl
 * can analyze it's safe to do so. The cases are tested here.
 */
__kernel void
test()
{

  int gid = get_global_id (0);
  int lid = get_local_id (0);
  printf("begin at: lid: %d, gid: %d\n",lid,gid);
  local float dummy[100];
  dummy[get_local_id (0)] = 0;

  if (lid == 0)
    printf ("vertical:\n");
  /* This loop cannot be horizontally vectorized by the implicit loop barrier
     mechanism because of an iteration count that depends on the id. */
  for (int i = 0; i < gid; ++i) {
    printf ("i: %d gid: %d\n", i, gid);
    /* This should make the outerloop intelligence want to transform it to
       a b-loop, if it was legal to do so. */
    dummy[get_local_id (0)] += 1;
  }
    printf("at 1st barrier: lid: %d, gid: %d\n",lid,gid);
  barrier(CLK_GLOBAL_MEM_FENCE);
  printf("after 1st barrier: lid: %d, gid: %d\n",lid,gid);
  if (lid == 0)
    printf ("horizontal:\n");
    /* This loop should be horizontally vectorized because the iteration count
       does not depend on the id. */
#pragma nounroll
  for (int i = 0; i < get_local_size(0); ++i) {
    if (i < 4)
      printf ("i: %d gid: %d\n", i, gid);
    /* This should make the outerloop intelligence want to transform it to
       a b-loop, if it was legal to do so. */
    dummy[get_local_id (0)] += 1;
  }
  printf("at 2nd barrier: lid: %d, gid: %d\n",lid,gid);
  barrier(CLK_GLOBAL_MEM_FENCE);
  if (lid == 0)
    printf ("vertical:\n");

  /* This loop should not be horizontally vectorized because the loop is
     entered only by the subset of the work items. */
  if (gid > 0) {
    for (int i = 0; i < get_local_size(0); ++i) {
      printf ("i: %d gid: %d\n", i, gid);
      /* This should make the outerloop intelligence want to transform it to
         a b-loop, if it was legal to do so. */
      dummy[get_local_id (0)] += 1;
    }
  }
  barrier(CLK_GLOBAL_MEM_FENCE);
}
