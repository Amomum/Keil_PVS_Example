#include "project_config.h"

int main(void)
{

    volatile int * a = nullptr;
    
    *a = 1; // комментируйте эту строку, чтобы проверить наличие/отсутствие предупреждений

    while(1);

    return 0;
}
