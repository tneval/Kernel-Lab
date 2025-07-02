

__kernel void test_ids() {
    // Get global and local IDs
    int gid0 = get_global_id(0);
    int gid1 = get_global_id(1);
    int gid2 = get_global_id(2);
    int lid0 = get_local_id(0);
    int lid1 = get_local_id(1);
    int lid2 = get_local_id(2);
    
    int gs0 = get_global_size(0);
    int gs1 = get_global_size(1);
    int gs2 = get_global_size(2);

    int grid0 = get_group_id(0);
    int grid1 = get_group_id(1);
    int grid2 = get_group_id(2);

    int ls0 = get_local_size(0);
    int ls1 = get_local_size(1);
    int ls2 = get_local_size(2);



    int wg_id = get_group_id(0);

    int glb_id = get_global_linear_id();


    int first = (ls2 * grid2 + lid2) * gs1 * gs0;
   
    int second = (ls1*grid1+lid1)*gs0;
 
    int third = ls0*grid0+lid0;

    barrier(CLK_LOCAL_MEM_FENCE);
    // Print the IDs
    printf("Global: (%d,%d,%d)  Global size:(%d,%d,%d)  Local:(%d,%d,%d)  Local size: (%d,%d,%d)  Group id: (%d,%d,%d) Calc: (%d,%d,%d) Global_linear_id: %d\n", gid0,gid1,gid2,gs0,gs1,gs2,lid0,lid1,lid2,ls0,ls1,ls2,grid0,grid1,grid2,first,second,third,glb_id);
    

     barrier(CLK_LOCAL_MEM_FENCE);
    // Print the IDs
   // printf("Global: (%d,%d,%d)  Global size:(%d,%d,%d)  Local:(%d,%d,%d)  Local size: (%d,%d,%d)  Group id: (%d,%d,%d) Calc: (%d,%d,%d) Global_linear_id: %d\n", gid0,gid1,gid2,gs0,gs1,gs2,lid0,lid1,lid2,ls0,ls1,ls2,grid0,grid1,grid2,first,second,third,glb_id);
    
    


}
