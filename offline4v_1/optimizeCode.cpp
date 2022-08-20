#include <bits/stdc++.h>
#include "optimizeCode.h"
using namespace std;

extern FILE *Assembly;
extern FILE *Optimized;

void optimizeCode()
{
    vector<string> lines;
    vector<string> outputlines;
    char str[1000];
    string str2, str3;

    while (fgets(str, sizeof(str), Assembly))
    {

        stringstream ss(str);
        string temp, tempLine;
        bool first = true;

        while (ss >> temp)
        {
            tempLine += (first ? "" : " ") + temp;
            first = false;
        }

        if (!tempLine.empty() && tempLine[0] != ';')
        {   
            lines.push_back(tempLine);
            outputlines.push_back(str);
        }
    }

    for (int i = 0; i < lines.size(); i++)
    {
        if (i + 1 >= lines.size())
        {
            stringstream ss;
            ss << lines[i];
            string str11, str12, str21, str22;
            ss >> str;
            ss >> str11;
            str11.pop_back();
            ss >> str12;

            if (str12 == str2 && str11 == str3)
            {
                fprintf(Optimized, "\t; Redundant MOV optimized\n");
                i++;
                continue;
            }

            if (str11 == str2 && str12 == str3)
            {
                fprintf(Optimized, "\t; Redundant MOV optimized\n");
                i++;
                continue;
            }

            fprintf(Optimized, "%s", outputlines[i].c_str());
        }
        else if (lines[i].substr(0, 3) == "MOV" && lines[i + 1].substr(0, 3) == "MOV")
        {

            stringstream ss;
            ss << lines[i];
            string str11, str12, str21, str22;
            ss >> str;
            ss >> str11;
            str11.pop_back();
            ss >> str12;

            ss.clear();
            ss.str("");

            ss << lines[i + 1];
            ss >> str;
            ss >> str21;
            str21.pop_back();
            ss >> str22;

            if (str11 == str22 && str21 == str12)
            {
                fprintf(Optimized, "\t; Redundant MOV optimized\n");
                fprintf(Optimized, "%s", outputlines[i].c_str());
                str2 = str11;
                str3 = str12;
                i++;
                continue;
            }

            if (str11 == str2 && str12 == str3)
            {
                fprintf(Optimized, "\t; Redundant MOV optimized\n");
                continue;
            }

            fprintf(Optimized, "%s", outputlines[i].c_str());
            str2 = str11;
            str3 = str12;
        }

        else
        {
            fprintf(Optimized, "%s", outputlines[i].c_str());
            str2 = "";
            str3 = "";
        }
    }
}


