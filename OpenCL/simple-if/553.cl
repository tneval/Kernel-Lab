__kernel void test() {
  int outerend = 1;
  int innerend = 1;
  outerend = 2; // YYYY
  innerend = 2; // YYYY
  int outer = 0;
  int inner = 0;
  int arg1 = 1;
  int arg2 = 1;
  //arg1 = xarg1; // XXXX
  //arg2 = xarg2; // XXXX
/*   for (outer = 0; outer < outerend; outer++) // XXXX
  {
    for (inner = 0; inner < innerend; inner++) // XXXX
    {
      //barrier(CLK_LOCAL_MEM_FENCE);
	    printf("outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
	    if (arg2 > arg1) // XXXX
	    {
            barrier(CLK_LOCAL_MEM_FENCE); // XXXX
	    }
	    if (arg1 > 0) // XXXX
	    {
            barrier(CLK_LOCAL_MEM_FENCE); // XXXX
	    }
	    printf("+ outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
      //barrier(CLK_LOCAL_MEM_FENCE);
    }
  } */


    /* printf("outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
	    if (arg2 > arg1) // XXXX
	    {
            barrier(CLK_LOCAL_MEM_FENCE); // XXXX
	    }
        //printf("ok\n");
	    if (arg1 > 0) // XXXX
	    {
            barrier(CLK_LOCAL_MEM_FENCE); // XXXX
	    }
	    printf("+ outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0)); */


    if(arg1){
        printf("eka\n");
        if(arg2){
          printf("1outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
          barrier(CLK_LOCAL_MEM_FENCE);
          printf("2outer=%d inner=%d lid=%d\n", outer, inner, get_local_id(0));
        }
        printf("ekan jalkee\n");
    }


}