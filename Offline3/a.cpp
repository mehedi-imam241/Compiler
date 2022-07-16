#include <iostream>
#include <string>
  
using namespace std;
  
int main()
{
    string str = "      geeksforgeeks a computer science";
    string str1 = "geeksp";
  
    // Find first occurrence of "geeks"
    int found = str.find(str1);
    if (found != string::npos)
        cout << "First occurrence is " << found << endl;

    cout<<found<<endl;
  
}