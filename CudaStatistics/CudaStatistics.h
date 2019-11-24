// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the CUDASTATISTICS_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// CUDASTATISTICS_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef CUDASTATISTICS_EXPORTS
#define CUDASTATISTICS_API __declspec(dllexport)
#else
#define CUDASTATISTICS_API __declspec(dllimport)
#endif

// This class is exported from the dll
class CUDASTATISTICS_API CCudaStatistics {
public:
	CCudaStatistics(void);
	// TODO: add your methods here.
};

extern CUDASTATISTICS_API int nCudaStatistics;

CUDASTATISTICS_API int fnCudaStatistics(void);
