#include <sycl/sycl.hpp>
#include <iostream>

using namespace sycl;

int main() {
    
    constexpr int global_size = 4;
    constexpr int local_size = 4;

    // SYCL queue
    queue q;
    {
        /* q.submit([&](handler &h) {
            
            std::cout << "One dimensional nd_range:\n";

            range<1> global(global_size);
            range<1> local(local_size);
            
            nd_range<1> range(global, local); 
            
            h.parallel_for(range, [=](nd_item<1> idx) {
                
                //size_t workgroup_id_x = idx.get_group(0);

                //size_t global_id_x = idx.get_global_id(0);
                size_t local_id_x = idx.get_local_id(0);
                
                //sycl::ext::oneapi::experimental::printf("hello from: %d (global)\t%d (local)\t%d (workgroup)\n",global_id_x, local_id_x,workgroup_id_x);
                sycl::ext::oneapi::experimental::printf("hello from: %d (local)\n",local_id_x);

            });

        }).wait(); */


        q.submit([&](handler &h) {
            
            std::cout << "One dimensional nd_range:\n";

            range<1> global(global_size);
            range<1> local(local_size);
            
            nd_range<1> range(global, local); 

            h.parallel_for(range, [=](nd_item<1> idx) {
                
                size_t workgroup_id_x = idx.get_group(0);

                size_t global_id_x = idx.get_global_id(0);
                size_t local_id_x = idx.get_local_id(0);
                
                sycl::ext::oneapi::experimental::printf("hello from: %d (local)\t%d (global)\t%d (global)\t%d (local)\n",global_id_x, global_id_x,global_id_x, global_id_x);
               
            });


        }).wait();

    } 

    return 0;
}
