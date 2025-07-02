

__kernel void
test_kernel (void)
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
