#include <bits/stdc++.h>
using namespace std;

extern int BucketSize;

unsigned int HashFunction(string str)
{
    unsigned int hash = 0;
    int c;

    for (char c : str)
    {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }

    return hash % BucketSize;
}

