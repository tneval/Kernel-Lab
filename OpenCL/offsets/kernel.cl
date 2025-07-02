__kernel void print_ids() {
    int gid_x = get_global_id(0);        // Global ID in dimension 0
    int gid_y = get_global_id(1);        // Global ID in dimension 1
    int gid_z = get_global_id(2);        // Global ID in dimension 2

    int offset_x = get_global_offset(0); // Offset in dimension 0
    int offset_y = get_global_offset(1); // Offset in dimension 1
    int offset_z = get_global_offset(2); // Offset in dimension 2

    printf("Global ID: (%d, %d, %d), Offset: (%d, %d, %d)\n", gid_x, gid_y, gid_z, offset_x, offset_y, offset_z);
}