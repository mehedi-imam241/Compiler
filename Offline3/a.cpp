#include <iostream>
#include <string>
#include<regex>
  
using namespace std;
  
int main()
{
    regex exp("0*(.0+)?");
    string s= "0000000";
    if(regex_match(s,exp))
    {
        cout<<"matched";
    }
    else {
        cout<<"un";
    }
  
}