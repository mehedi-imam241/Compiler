#include <bits/stdc++.h>
using namespace std;

#ifndef SYMBOLINFO_H_
#define SYMBOLINFO_H_

class symbolINfo
{
private:
    string name, type;

public:
    symbolINfo *next;
    symbolINfo(string name, string type)
    {
        this->name = name;
        this->type = type;
        next = nullptr;
    }

    string getName()
    {
        return name;
    }
    string getType()
    {
        return type;
    }

    void setName(string name)
    {
        this->name = name;
    }
    void setType(string name)
    {
        this->type = type;
    }
    // ~Node()
    // {
    //     delete next;
    // }
};

#endif // !LINKEDLIST_H_
