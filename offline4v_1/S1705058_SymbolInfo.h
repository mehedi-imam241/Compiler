#ifndef S1705058_SymbolInfo_H_INCLUDED
#define S1705058_SymbolInfo_H_INCLUDED

#include <bits/stdc++.h>
using namespace std;

class SymbolInfo
{

private:
	string SymbolName;
	string SymbolType;

	string Identity;	 // Function or Variable
	string VariableType; // int or float etc
	string ReturnType;	 // For function

	// For Arrays
	int VariableSize = -1;
	int ArrayAccessVariable = -1;

	bool Function = false;

	// For Assembly
	string Code;
	string AssSymbol;
	string ImplementationID;

	SymbolInfo *NextSymbol;

public:
	vector<SymbolInfo *> ParamList;
	int IValue;
	float FValue;
	bool RetVal = false;
	bool GlobalVar = false;

	int *IntValue;
	float *FloatValue;
	char *CharValue;

	SymbolInfo()
	{
		SymbolName = "";
		SymbolType = "";
		Identity = "";
		VariableType = "";
		ReturnType = "";

		IntValue = nullptr;
		FloatValue = nullptr;
		CharValue = nullptr;
		NextSymbol = nullptr;
	}

	SymbolInfo(string Type)
	{
		SymbolName = "";
		SymbolType = Type;
		Identity = "";
		VariableType = "";
		ReturnType = "";

		IntValue = nullptr;
		FloatValue = nullptr;
		CharValue = nullptr;
		NextSymbol = nullptr;
	}

	SymbolInfo(string Name, string Type)
	{
		SymbolName = Name;
		SymbolType = Type;
		Identity = "";
		VariableType = "";
		ReturnType = "";

		IntValue = nullptr;
		FloatValue = nullptr;
		CharValue = nullptr;
		NextSymbol = nullptr;
	}
	~SymbolInfo() {}

	inline string GetSymbolName() { return SymbolName; }
	inline string GetSymbolType() { return SymbolType; }
	inline string GetIdentity() { return Identity; }
	inline string GetVariableType() { return VariableType; }
	inline string GetReturnType() { return ReturnType; }
	inline int GetVariableSize() { return VariableSize; }
	inline int GetArrayAccessVariable() { return ArrayAccessVariable; }
	inline SymbolInfo *GetNextSymbol() { return NextSymbol; }
	inline vector<SymbolInfo *> GetParamList() { return ParamList; }
	inline string GetCode() { return Code; }
	inline string GetAssemblySymbol() { return AssSymbol; }
	inline string GetImplementationID() { return ImplementationID; }
	inline void SetSymbolName(string Name) { SymbolName = Name; }
	inline void SetSymbolType(string Type) { SymbolType = Type; }
	inline void SetIdentity(string ID) { Identity = ID; }
	inline void SetVariableType(string Type) { VariableType = Type; }
	inline void SetReturnType(string Type) { ReturnType = Type; }
	inline void SetNextSymbol(SymbolInfo *Next) { NextSymbol = Next; }
	inline void SetVariableSize(int Size) { VariableSize = Size; }
	inline void SetArrayAccessVariable(int Access) { ArrayAccessVariable = Access; }
	inline void SetCode(string code) { Code = code; }
	inline void SetAssemblySymbol(string Ass) { AssSymbol = Ass; }
	inline void SetImplementationID(string ID) { ImplementationID = ID; }

	void CreateIntegerArray()
	{
		IntValue = new int[VariableSize];
		for (int Counter = 0; Counter < VariableSize; Counter++)
		{
			IntValue[Counter] = -1;
		}
	}

	void CreateFloatArray()
	{
		FloatValue = new float[VariableSize];
		for (int Counter = 0; Counter < VariableSize; Counter++)
		{
			FloatValue[Counter] = -1;
		}
	}
	void CreateCharacterArray()
	{
		CharValue = new char[VariableSize];
		for (int Counter = 0; Counter < VariableSize; Counter++)
		{
			CharValue[Counter] = '%';
		}
	}
};
#endif // S1705058_SymbolInfo_H_INCLUDED
