__kernel void ballot_example(__global uint *input, __global uint4 *output) {
    int gid = get_global_id(0);
    int predicate = input[gid] % 2 == 0; // Example: ballot even numbers

    uint4 result = sub_group_ballot(predicate);
    output[gid] = result;
}