#include <sycl/sycl.hpp>
#include <iostream>

using namespace sycl;

int main() {
    // Input data
    constexpr size_t N = 8;
    float input1[N] = {1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f};
    float input2[N] = {8.0f, 7.0f, 6.0f, 5.0f, 4.0f, 3.0f, 2.0f, 1.0f};
    float output[N];

    // SYCL queue
    queue q;

    {
        // Create buffers for input and output
        buffer<float, 1> buf1(input1, range<1>(N));
        buffer<float, 1> buf2(input2, range<1>(N));
        buffer<float, 1> bufOut(output, range<1>(N));

        q.submit([&](handler &h) {
            // Accessors for the buffers
            auto acc1 = buf1.get_access<access::mode::read>(h);
            auto acc2 = buf2.get_access<access::mode::read>(h);
            auto accOut = bufOut.get_access<access::mode::write>(h);

            // Kernel
            h.parallel_for(range<1>(N), [=](id<1> idx) {
                accOut[idx] = acc1[idx] + acc2[idx];
            });
        });
    } // Buffers go out of scope, data is synchronized back

    // Print the result
    std::cout << "Result: ";
    for (size_t i = 0; i < N; ++i) {
        std::cout << output[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
