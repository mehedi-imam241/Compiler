#include "globalFunctions.h"
#include "globals.h"
#include "linkedList/symbolInfo.h"
#include "linkedList/linkedList.cpp"

class scopeTable
{
private:
    linkedList *table;
    string id;
    int counter;

public:
    scopeTable* parent;

    scopeTable(int counter)
    {
        table = new linkedList[totalBuckets];
        this->counter = counter;
        id = to_string(counter);
        parent = nullptr;
    }

    scopeTable(string parentID, int counter)
    {
        table = new linkedList[totalBuckets];
        this->counter = counter;
        id = parentID + "." + to_string(counter);
    }

    string getID()
    {
        return id;
    }
    int getCounter()
    {
        return counter;
    }

    bool Insert(const string &name, string const &type)
    {
        int hash = hashFunction(name);

        int pos = table[hash].insert(name, type);

        if (pos != -1)
        {
            //fprintf(logout,"Inserted in ScopeTable# %s at position %d")
            //cout << "Inserted in ScopeTable# " << getID() << " at position " << hash << ", " << pos << endl;
            return true;
        }
        else
        {
            fprintf(logout,"\n%s already exists in current ScopeTable\n",name.c_str());
            //cout << "<" << name << "," << type << "> already exists in current ScopeTable" << endl;
            return false;
        }
    }

    symbolINfo *lookUp(const string &name)
    {
        int hash = hashFunction(name);
        pair<int,symbolINfo*> s = table[hash].search(name);
        if(s.first!=-1)
        {
            //cout << "Found in ScopeTable# " << getID() << " at position " << hash << ", " << s.first << endl;
            return s.second;
        }
        else {
            return nullptr;
        }
    }

    bool Delete(string name)
    {
        int hash = hashFunction(name);

        int pos = table[hash].remove(name);
        if (pos != -1)
        {
            //cout << "Found in ScopeTable# " << getID() << " at position " << hash << ", " << pos << endl;
            //cout << "Deleted Entry " << hash << ", " << pos << " from current Scopetable" << endl;
            return true;
        }
        else
        {
            //cout << "Entry name " << name << " not found" << endl;
            return false;
        }
    }

    void print()
    {

        fprintf(logout,"\nScopeTable # %s\n",id.c_str());
        //cout<<"ScopeTable # "<<id<<endl;

        for (int i = 0; i < totalBuckets; i++)
        {
            //cout <<  i << " --> ";
            table[i].display(i);
        }
        //cout<<endl;
    }
    ~scopeTable()
    {
        delete[] table;
    }
};

