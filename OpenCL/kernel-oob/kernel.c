#define SUB_GROUP_SIZE 4

#include <stdio.h>

//__attribute__((reqd_sub_group_size(SUB_GROUP_SIZE)))
void test_oob(int *overflow_this, int x, float *y) {


    overflow_this[5000] = 7;

    // Global IDs
    int global_id_x = 0;

    // Local IDs
    int local_id_x = 0;

    // Workgroup IDs
    int workgroup_id_x = 0;


printf("X: %d, Y: %f\n", x,*y);

       if(global_id_x == 0){
              x = 0;
              *y = 0.0;
       }


printf("X: %d, Y: %f\n", x,*y);

    // Global size
   /*  int global_size_x = get_global_size(0);
    int global_size_y = get_global_size(1); */

    // Subgroup ID
    /* int subgroup_id = get_sub_group_id();

    int sg_local_id = get_sub_group_local_id(); */

    // Print debug information
    /* printf("Global ID: (%d, %d), Local ID: (%d, %d), "
           "Workgroup ID: (%d, %d), Subgroup ID: %d, Subgroup local ID: %d\n",
           global_id_x, global_id_y, local_id_x, local_id_y,
           workgroup_id_x, workgroup_id_y, subgroup_id, sg_local_id); */
    // For conformance test

    printf("Global ID: (%d), Local ID: (%d), "
           "Workgroup ID: (%d)\n",
           global_id_x, local_id_x,
           workgroup_id_x);
}