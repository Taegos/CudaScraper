// CudaStatistics.cpp : Defines the exported functions for the DLL.
//

#include "pch.h"
#include "framework.h"
#include "CudaStatistics.h"


// This is an example of an exported variable
CUDASTATISTICS_API int nCudaStatistics=0;

// This is an example of an exported function.
CUDASTATISTICS_API int fnCudaStatistics(void)
{
    return 0;
}

// This is the constructor of a class that has been exported.
CCudaStatistics::CCudaStatistics()
{
    return;
}
