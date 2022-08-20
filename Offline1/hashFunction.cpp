#include <bits/stdc++.h>
#include "globals.h"
using namespace std;

int hashFunction(string str)
{
    unsigned int hash = 0;
    int c;

    for (char c : str)
    {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }

    return hash % totalBuckets;
}
