__kernel void
test_kernel (void)
{
  unsigned group_id = get_group_id (0);
  unsigned local_id = get_local_id (0);

  int a = 0;

  printf ("LOCAL_ID=%d before if\n", local_id);
  if (local_id == 0)
  {
      printf ("LOCAL_ID=%d inside if\n", local_id);
      a = a+1;
  }else {
    a= a+2;
  }

  int b = a+3;
  printf ("LOCAL_ID=%d after if, a: %d\n", local_id, b);
}
