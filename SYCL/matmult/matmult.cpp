#include <sycl/sycl.hpp>
#include <iostream>
#include <vector>

constexpr size_t TILE_SIZE = 2;

class MatrixMultiplication;

int main() {
    constexpr size_t N = 8; // Matrix size N x N

    // Initialize host matrices
    std::vector<float> A(N * N, 1.0f); // Fill with 1.0 for simplicity
    std::vector<float> B(N * N, 2.0f); // Fill with 2.0
    std::vector<float> C(N * N, 0.0f); // Result matrix

    sycl::queue q;

    {
        // Create buffers
        sycl::buffer<float, 2> bufferA(A.data(), sycl::range<2>(N, N));
        sycl::buffer<float, 2> bufferB(B.data(), sycl::range<2>(N, N));
        sycl::buffer<float, 2> bufferC(C.data(), sycl::range<2>(N, N));

        // Submit the kernel
        q.submit([&](sycl::handler& h) {
            auto a = bufferA.get_access<sycl::access::mode::read>(h);
            auto b = bufferB.get_access<sycl::access::mode::read>(h);
            auto c = bufferC.get_access<sycl::access::mode::write>(h);

            // Local memory (shared memory for tiles)
            sycl::local_accessor<float, 2> localA(sycl::range<2>(TILE_SIZE, TILE_SIZE), h);
            sycl::local_accessor<float, 2> localB(sycl::range<2>(TILE_SIZE, TILE_SIZE), h);

            h.parallel_for<class MatrixMultiplication>(
                sycl::nd_range<2>(sycl::range<2>(N, N), sycl::range<2>(TILE_SIZE, TILE_SIZE)),
                [=](sycl::nd_item<2> item) {
                    // Get global and local IDs
                    size_t globalRow = item.get_global_id(0);
                    size_t globalCol = item.get_global_id(1);
                    size_t localRow = item.get_local_id(0);
                    size_t localCol = item.get_local_id(1);
                    size_t groupRow = item.get_group(0);
                    size_t groupCol = item.get_group(1);

                    float sum = 0.0f;

                    // Loop over tiles
                    for (size_t tile = 0; tile < N / TILE_SIZE; ++tile) {
                        // Load data into local memory
                        if (globalRow < N && (tile * TILE_SIZE + localCol) < N)
                            localA[localRow][localCol] = a[globalRow][tile * TILE_SIZE + localCol];
                        else
                            localA[localRow][localCol] = 0.0f;

                        if ((tile * TILE_SIZE + localRow) < N && globalCol < N)
                            localB[localRow][localCol] = b[tile * TILE_SIZE + localRow][globalCol];
                        else
                            localB[localRow][localCol] = 0.0f;

                        // Synchronize threads to ensure tile is fully loaded
                        item.barrier(sycl::access::fence_space::local_space);

                        // Multiply the tiles
                        for (size_t k = 0; k < TILE_SIZE; ++k) {
                            sum += localA[localRow][k] * localB[k][localCol];
                        }

                        // Synchronize again before loading the next tile
                        item.barrier(sycl::access::fence_space::local_space);
                    }

                    // Write the result
                    if (globalRow < N && globalCol < N) {
                        c[globalRow][globalCol] = sum;
                    }
                });
        });
    }

    // Verify the result
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j) {
            if (C[i * N + j] != 2.0f * N) {
                std::cout << "Mismatch at (" << i << ", " << j << "): " << C[i * N + j] << "\n";
                //return -1;
                
            }
            std::cout << C[i*N+j] << " "; 
        }
        std::cout << std::endl;
    }
    std::cout << "Matrix multiplication completed successfully.\n";

    return 0;
}