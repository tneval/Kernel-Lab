#include <sycl/sycl.hpp>
#include <iostream>

using namespace sycl;

int main() {
    
    constexpr int N = 2;

    // SYCL queue
    queue q;
    {
        q.submit([&](handler &h) {
            
            std::cout << "One dimensional range:\n";

            h.parallel_for(range<1>(N), [=](id<1> idx) {

                size_t global_id_x = idx.get(0);
                
                sycl::ext::oneapi::experimental::printf("hello from: %d\n",global_id_x);

            });

        }).wait();


        q.submit([&](handler &h) {
            
            std::cout << "Two-dimensional range:\n";

            h.parallel_for(range<2>(N,N), [=](id<2> idx) {
                
                size_t global_id_x = idx.get(0);
                size_t global_id_y = idx.get(1);

                sycl::ext::oneapi::experimental::printf("hello from: %d\t%d\n",global_id_x, global_id_y);

            });
        }).wait();



        q.submit([&](handler &h) {
            
            std::cout << "Three-dimensional range:\n";

            // Kernel
            h.parallel_for(range<3>(N,N,N), [=](id<3> idx) {

                size_t global_id_x = idx.get(0);
                size_t global_id_y = idx.get(1);
                size_t global_id_z = idx.get(2);
           
                sycl::ext::oneapi::experimental::printf("hello from: %d\t%d\t%d\n",global_id_x, global_id_y, global_id_z);
            });
        }).wait();
    } 

    return 0;
}
