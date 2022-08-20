#include "symbolTable.cpp"
#include "globals.h"

int totalBuckets;

#define read freopen("input.txt", "r", stdin)
#define write freopen("output.txt", "w", stdout)

int main(void)
{
    read;
    write;
    cin >> totalBuckets;

    string cmd, name, type;
    symbolTable s;

    while (cin >> cmd)
    {
        cout<<cmd<<" ";
        if (cmd == "I")
        {
            cin >> name >> type;
            cout<<name<<" "<<type<<endl<<endl;
            s.insert(name, type);
        }
        else if (cmd == "L")
        {
            cin >> name;
            cout<<name<<endl<<endl;
            symbolINfo *symInfo;
            s.lookUP(name);
        }
        else if (cmd == "P")
        {
            string str;
            cin >> str;
            cout<<str<<endl<<endl;
            if (str == "A")
            {
                s.printAllScopeTable();
            }
            else if (str == "C")
            {
                s.printCurScopeTable();
            }
            else
            {
                puts("Invalid print statement!");
            }
        }
        else if (cmd == "S")
        {
            puts("\n");
            s.enterScope();
        }
        else if (cmd == "E")
        {
            puts("\n");
            if (!s.exitScope())
                puts("No current scope");

        }
        else if (cmd == "D")
        {
            cin >> name;
            cout<< name<<endl<<endl;
            s.remove(name);
        }
        else
        {
            puts("\n");
            puts("Invalid command!");
        }
        puts("");
    }
}