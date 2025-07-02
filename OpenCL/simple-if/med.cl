__kernel void test()
{
    int threadid = get_local_id(0);
    int x = 100;
    printf("ok\n");
    if (threadid < x)
    {
        union
        {
            float  ary[8];
            float8 vec;
        } output, input;
        input.vec = (float8)(MAXFLOAT, MAXFLOAT, MAXFLOAT, MAXFLOAT, MAXFLOAT, MAXFLOAT, MAXFLOAT, MAXFLOAT);

        for (int y=0; y<2; y++)
        {
            //Select only the active threads, some may remain inactive

            if (y == 0)
            {
                /* for (int i=0; i<max_vec; i++)
                {
                    if (threadid<nb_threads)
                    {
                        int pos_y = clamp((int)(y + 8 * band_nr + i - khs1), (int) 0, (int) height-1);
                        input.ary[i] = image[pos_x + width * pos_y];
                    }
                } */
                printf("hello\n");
            }
            else
            {
               printf("helloob\n");

                barrier(CLK_LOCAL_MEM_FENCE);
                printf("okoko\n");
                /* int read_from = threadid + kfs2;
                if (read_from < nb_threads)
                    input.vec.s7 = l_data[read_from].s0;
                else if (threadid < nb_threads) //we are on the last band
                {
                    int pos_y = clamp((int)(y + 8 * band_nr + max_vec - 1 - khs1), (int) 0, (int) height-1);
                    input.ary[max_vec - 1] = image[pos_x + width * pos_y];
                }
 */
            }

            barrier(CLK_LOCAL_MEM_FENCE);
        }
    }
}