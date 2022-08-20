#include "scopeTable.cpp"

class symbolTable
{
private:
    scopeTable *cur;
    int counter;
    int size;

public:
    symbolTable()
    {
        cur = nullptr;
        counter = 1;
        size = 0;
    }
    void enterScope()
    {
        if (cur == nullptr)
        {
            cur = new scopeTable(counter);
        }
        else
        {
            scopeTable *temp = new scopeTable(cur->getID(), counter);
            temp->parent = cur;
            cur = temp;
            counter = 1;
        }
        //cout << "New ScopeTable with id " << (cur->getID()) << " created" << endl;
        size++;
    }

    bool exitScope()
    {
        if (!cur)
        {
            return false;
        }
        else
        {
            counter = cur->getCounter() + 1;
            scopeTable *temp = cur;
            cur = cur->parent;
            //cout << "ScopeTable with id " << temp->getID() << " is removed" << endl;
            //cout << "Destroying the ScopeTable" << endl;
            delete temp;
            return true;
        }
    }



    bool insert(string const &name, string const &type)
    {
        if (!cur)
            enterScope();
        return cur->Insert(name, type);
    }

    bool remove(string const &name)
    {
        if(!cur) 
        {
            return false;
        }
        return cur->Delete(name);
    }

    symbolINfo *lookUP(string const &name)
    {
        scopeTable *temp = cur;

        while (temp)
        {
            symbolINfo *sym;
            if (sym = temp->lookUp(name))
            {
                return sym;
            }
            temp = temp->parent;
        }
        // cout << "Entry name " << name << " not found" << endl;
        return NULL;
    }

    void printCurScopeTable()
    {
        if(!cur) 
        {
            //cout<< "Scope table empty"<<endl;
            return;
        }
        cur->print();
    }

    void printAllScopeTable()
    {

        if(!cur) 
        {
            cout<< "Symbol table empty"<<endl;
            return;
        }
        scopeTable *temp = cur;

        while (temp)
        {
            temp->print();
            temp = temp->parent;
        }
    }



    ~symbolTable()
    {
        scopeTable *temp;
        while (cur)
        {
            temp = cur->parent;
            delete cur;
            cur = temp;
        }

        delete cur;
    }
};


