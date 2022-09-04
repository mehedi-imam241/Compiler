#include<string>
using namespace std;

class VariableIdentity{
public:
	string Name;
	string Size;
	
	VariableIdentity(){}
	VariableIdentity(string name, string size){
		Name = name;
		Size = size;
	}
};