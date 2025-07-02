/* #define SG_SIZE 2

__attribute__((intel_reqd_sub_group_size(SG_SIZE)))
__kernel void test_ids() {
    // Get global and local IDs
    int global_id = get_global_id(0);
    int local_id = get_local_id(0);
    int sg_id = get_sub_group_id();
    int wg_id = get_group_id(0);
    int sg_local_id = get_sub_group_local_id();

    int j=0;
    int k=0;

    if(sg_id == 0){

        for(int i = 0; i<2; i++){
            printf("before_sg_barrier: ijk(%d,%d,%d): Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n",i,j,k, global_id, local_id, wg_id, sg_id, sg_local_id);
            sub_group_barrier(CLK_LOCAL_MEM_FENCE);
            printf("after_sg_barrier: ijk(%d,%d,%d): Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n",i,j,k, global_id, local_id, wg_id, sg_id, sg_local_id);
        }

        
    }
    if(sg_id == 0){

        for(int i = 0; i< 2; i++){

            for(int j = 0; j<2; j++){

                for(int k = 0; k<2; k++){
                    printf("before_sg_barrier: ijk(%d,%d,%d): Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n",i,j,k, global_id, local_id, wg_id, sg_id, sg_local_id);
                    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
                    printf("after_sg_barrier: ijk(%d,%d,%d): Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n",i,j,k, global_id, local_id, wg_id, sg_id, sg_local_id);

                }
            }

        }
    }
    



    barrier(CLK_LOCAL_MEM_FENCE);
    // Print the IDs
    printf("Global ID: %d\tLocal ID: %d\tWorkgroup ID: %d\tSubgroup ID: %d\tSubgroup local ID: %d\n", global_id, local_id, wg_id, sg_id, sg_local_id);
}
 */
__kernel void
test_ids (void)
{
  int gid_x = get_global_id (0);
  int k = 0;
  int i;
  volatile int foo[15000];

/* This bug reproduces only if the last 'if' in the loop
   writes to a memory, thus cannot be converted to a select. 

   This produces a crash with 'repl' and an infinite loop with 'wiloops'. 

   It is caused by a loop structure where there are two paths to the
   latch block which decrements the iteration variable. The first path
   skips the last if, the second executes it. This confuses the
   barrier tail replication.
*/

  for (i = 16; i > 0; i--) {
      barrier(CLK_LOCAL_MEM_FENCE);
      printf ("gid_x %u after barrier at iteration %d\n", gid_x, i);
      k += gid_x;
      if(i < 15)
          foo[i] = k*160 * gid_x;
  }
  /* If it did not crash and the program does not go to an inifinite
     loop, assume OK. */
  if (gid_x == 0)
      printf("OK\n");
}
