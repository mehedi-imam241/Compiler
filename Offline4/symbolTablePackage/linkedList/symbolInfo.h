#ifndef SYMBOLINFO_H_
#define SYMBOLINFO_H_

#include <bits/stdc++.h>
using namespace std;

class symbolINfo
{
private:
    string name, type,retType,variableType;
public:

    bool isArray,isFunc;
    vector<symbolINfo*>paramList;

    symbolINfo *next;
    symbolINfo(string name, string type)
    {
        this->name = name;
        this->type = type;
        next = nullptr;
        isArray = false;
        isFunc = false;
        paramList = {};
    }

    string getName()
    {
        return name;
    }
    string getType()
    {
        return type;
    }
    string getVariableType()
    {
        return variableType;
    }
    string getReturnType()
    {
        return retType;
    }

    void setName(string name)
    {
        this->name = name;
    }
    void setType(string name)
    {
        this->type = type;
    }
    void setVariableType(string varType)
    {
        this->variableType = varType;
    }
    void setReturnType(string retType)
    {
        this->retType = retType;
    }
    void print()
    {
        cout<<endl<<endl<<name<<" "<<type<<" "<<variableType<<" "<<retType<<" "<<paramList.empty()<<endl<<endl;
    }
};

#endif // !LINKEDLIST_H_
