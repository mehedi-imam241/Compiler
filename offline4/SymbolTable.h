#ifndef S1705058_SYMBOLTABLE_H_INCLUDED
#define S1705058_SYMBOLTABLE_H_INCLUDED

#include "SymbolInfo.h"
#include "ScopeTable.h"
#include <bits/stdc++.h>
using namespace std;

// Class For Scope Table


class SymbolTable
{

private:
    ScopeTable *CurrentScope;
    int BucketSizeForTable;

public:
    SymbolTable(int);
    ~SymbolTable();
    void EnterScope(FILE *);
    void ExitScope(FILE *);
    bool Insert(SymbolInfo *);
    bool Remove(string);
    SymbolInfo *LookUp(string);
    SymbolInfo *LookUpCurrentScope(string);
    void PrintCurrentScope(FILE *);
    void PrintAllScopes(FILE *);
    bool InsertToGlobalScope(SymbolInfo *);
    string GetCurrentScopeID();
};

SymbolTable::SymbolTable(int Size)
{
    CurrentScope = nullptr;
    BucketSizeForTable = Size;
    EnterScope(nullptr); // Create Global Scope
}

SymbolTable::~SymbolTable()
{
    // Delete All Available Scopes
    ScopeTable *Temp = CurrentScope;

    // Delete Scope then its parent scope and so on
    while (Temp)
    {
        CurrentScope = Temp;
        Temp = Temp->GetParentScope();
        delete CurrentScope;
    }
    delete Temp;
}

void SymbolTable::EnterScope(FILE *Log)
{
    ScopeTable *NewScope = new ScopeTable(BucketSizeForTable);

    if (CurrentScope)
    {
        CurrentScope->SetChildTableCount(CurrentScope->GetChildTableCount() + 1);
        NewScope->SetParentScope(CurrentScope);
    }
    NewScope->SetUniqueID();
    CurrentScope = NewScope;

    if (Log)
    {
        fprintf(Log, "New Scopetable with id %s created\n", CurrentScope->GetUniqueID().c_str());
    }
}

void SymbolTable::ExitScope(FILE *Log)
{
    ScopeTable *ToDelete = CurrentScope;
    if (ToDelete)
    {
        if (Log)
        {
            fprintf(Log, "Scopetable with id %s removed\n", ToDelete->GetUniqueID().c_str());
        }
        CurrentScope = CurrentScope->GetParentScope();
        delete ToDelete;
    }
}

bool SymbolTable::Insert(SymbolInfo *Symbol)
{
    if (CurrentScope)
    {
        return CurrentScope->Insert(Symbol);
    }
    return false;
}

bool SymbolTable::Remove(string Name)
{
    if (CurrentScope)
    {
        return CurrentScope->Delete(Name);
    }
    return false;
}

SymbolInfo *SymbolTable::LookUp(string Name)
{
    ScopeTable *Current = CurrentScope;

    if (Current)
    {
        while (Current)
        {
            SymbolInfo *Symbol = Current->LookUp(Name);

            if (Symbol)
            {
                return Symbol;
            }
            Current = Current->GetParentScope();
        }
    }
    return nullptr;
}

SymbolInfo *SymbolTable::LookUpCurrentScope(string Name)
{
    ScopeTable *Current = CurrentScope;

    if (Current)
    {
        return Current->LookUp(Name);
    }
    return nullptr;
}

void SymbolTable::PrintCurrentScope(FILE *File)
{
    if (CurrentScope)
    {
        CurrentScope->Print(File);
    }
}

void SymbolTable::PrintAllScopes(FILE *File)
{
    ScopeTable *Current = CurrentScope;

    if (Current)
    {
        while (Current)
        {
            Current->Print(File);
            Current = Current->GetParentScope();
        }
    }
}

bool SymbolTable::InsertToGlobalScope(SymbolInfo *ToAdd)
{
    if (CurrentScope)
    {
        ScopeTable *Temp = CurrentScope;
        while (Temp->GetParentScope())
        {
            Temp = Temp->GetParentScope();
        }
        return Temp->Insert(ToAdd);
    }
    return false;
}

string SymbolTable::GetCurrentScopeID()
{
    if (CurrentScope)
    {
        return CurrentScope->GetUniqueID();
    }
    else
    {
        return "nan";
    }
}
#endif // S1705058_SYMBOLTABLE_H_INCLUDED
