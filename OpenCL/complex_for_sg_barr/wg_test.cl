__kernel void
wgs (void)
{
    int gid_x = get_global_id (0);
    printf("hello %d\n", gid_x);
    barrier(CLK_LOCAL_MEM_FENCE);
    printf("hello_after %d\n",gid_x);
    work_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("jelöl\n");
    sub_group_barrier(CLK_LOCAL_MEM_FENCE);
    printf("asdf\n");
}
