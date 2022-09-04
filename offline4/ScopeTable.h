#include "HashFunction.cpp"

int BucketSize;

class ScopeTable
{

private:

    int ChildTableCount; // Needed To Name Unique ID For Child
    SymbolInfo **Table;  // The Hash Table
    ScopeTable *ParentScope;
    string UniqueID;

    // Used To Get Position Of A Symbol In The Table
    // int HashFunction(string);

public:
    ScopeTable(int);
    ~ScopeTable();

    bool Insert(SymbolInfo *);
    SymbolInfo *LookUp(string);
    bool Delete(string);
    void Print(FILE *);
    void SetUniqueID();

    inline int GetChildTableCount() { return ChildTableCount; }
    inline void SetChildTableCount(int Child) { ChildTableCount = Child; }
    inline ScopeTable *GetParentScope() { return ParentScope; }
    inline void SetParentScope(ScopeTable *Parent) { ParentScope = Parent; }
    inline string GetUniqueID() { return UniqueID; }
};

ScopeTable::ScopeTable(int Size)
{
    BucketSize = Size;
    ChildTableCount = 0;

    Table = new SymbolInfo *[Size];
    for (int Counter = 0; Counter < Size; Counter++)
    {
        Table[Counter] = nullptr;
    }
    ParentScope = nullptr;
}

void ScopeTable::SetUniqueID()
{
    if (ParentScope)
    {
        UniqueID = ParentScope->UniqueID + "DOT" + to_string(ParentScope->ChildTableCount);
    }
    else
    {
        UniqueID = to_string(1);
    }
}



ScopeTable::~ScopeTable()
{
    // Clean the Hash Table, Including The Chains
    for (int Counter = 0; Counter < BucketSize; Counter++)
    {
        SymbolInfo *Temp = Table[Counter];
        // Delete The Chains
        while (Temp)
        {
            Table[Counter] = Temp;
            Temp = Temp->GetNextSymbol();
            delete Table[Counter];
        }
    }
    delete[] Table;
}

bool ScopeTable::Insert(SymbolInfo *Symbol)
{
    string Name = Symbol->GetSymbolName();
    int Position = HashFunction(Name);
    int Counter = 0;

    if (!Table[Position])
    {
        Table[Position] = Symbol;
    }
    else
    {
        SymbolInfo *Current = Table[Position];

        // It also checks if this name already exists in current scope
        while (Current)
        {
            if (Current->GetSymbolName() == Name)
            {
                delete Symbol;
                return false;
            }
            ++Counter;
            if (!Current->GetNextSymbol())
            {
                break;
            }
            Current = Current->GetNextSymbol();
        }
        Current->SetNextSymbol(Symbol);
    }
    return true;
}

SymbolInfo *ScopeTable::LookUp(string Name)
{
    int Position = HashFunction(Name);

    if (Table[Position])
    {
        SymbolInfo *Current = Table[Position];
        int Counter = 0;

        while (Current)
        {
            if (Current->GetSymbolName() == Name)
            {
                return Current;
            }
            Current = Current->GetNextSymbol();
            ++Counter;
        }
    }
    return nullptr;
}

bool ScopeTable::Delete(string Name)
{
    int Position = HashFunction(Name);

    if (Table[Position])
    {
        SymbolInfo *Current = Table[Position];
        SymbolInfo *Previous = nullptr;
        int Counter = 0;

        while (Current)
        {

            if (Current->GetSymbolName() == Name)
            {
                // If it has a previous symbol, the next of the previous will be the next of current
                if (Previous)
                {
                    Previous->SetNextSymbol(Current->GetNextSymbol());
                }
                // If it has no previous symbol but a next symbol, then the next symbol will be the start of the chain
                else if (!Previous && Current->GetNextSymbol())
                {
                    Table[Position] = Current->GetNextSymbol();
                }
                // If there is no previous or next Symbol, it will become null
                else if (!Previous && !Current->GetNextSymbol())
                {
                    Table[Position] = nullptr;
                }

                delete Current;
                Current = nullptr;
                return true;
            }

            Previous = Current;
            Current = Current->GetNextSymbol();
            ++Counter;
        }
    }
    return false;
}

void ScopeTable::Print(FILE *File)
{
    fprintf(File, "ScopeTable # %s\n", UniqueID.c_str());
    for (int Counter = 0; Counter < BucketSize; Counter++)
    {
        if (Table[Counter])
        {
            SymbolInfo *Current = Table[Counter];
            fprintf(File, "%d --> ", Counter);
            while (Current)
            {
                fprintf(File, "< %s : %s> ", Current->GetSymbolName().c_str(), Current->GetSymbolType().c_str());
                Current = Current->GetNextSymbol();
            }
            fprintf(File, "\n");
        }
    }
    fprintf(File, "\n");
}