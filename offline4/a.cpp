#include <bits/stdc++.h>
using namespace std;

#define s(n) scanf("%d", &n)
#define sC(n) scanf("%c", &n)
#define sL(n) scanf("%lld", &n)
#define sD(n) scanf("%lf", &n)
#define sS(n) scanf("%s", n)

#define II ({int a; scanf("%d", &a); a; })
#define LL ({Long a; scanf("%lld", &a); a; })
#define DD ({double a; scanf("%lf", &a); a; })

#define fr(i, a, b) for (int i = (a), _b = (b); i <= _b; i++)
#define frr(i, a, b) for (int i = (a), _b = (b); i >= _b; i--)
#define rep(i, n) for (int i = 0, _n = (n); i < _n; i++)
#define repr(i, n) for (int i = (n)-1; i >= 0; i--)
#define foreach(it, ar) for (typeof(ar.begin()) it = ar.begin(); it != ar.end(); it++)
#define fill(ar, val) memset(ar, val, sizeof(ar))

#define uint64 unsigned long long
#define int64 long long
#define all(ar) ar.begin(), ar.end()
#define pb push_back
#define mp make_pair
#define ff first
#define ss second
#define sz(arr) sizeof(arr) / sizeof(arr[0])

#define BIT(n) (1 << (n))
#define AND(a, b) ((a) & (b))
#define OR(a, b) ((a) | (b))
#define XOR(a, b) ((a) ^ (b))
#define LSOne(a) (a & -a)
#define sqr(x) ((x) * (x))

typedef pair<int, int> ii;
typedef pair<int, ii> iii;
typedef vector<ii> vii;
typedef vector<int> vi;
typedef map<int, int> mpi;

#define PI 3.1415926535897932385
#define INF 1000111222
#define eps 1e-7
#define maxN 1050

#define read freopen("abcd.txt", "r", stdin)
#define write freopen("output.txt", "w", stdout)

// int dx[] = { -1, 0, 1, 0, -1, -1, 1, 1 };
// int dy[] = { -1, -1, 0, 1, 0, 1, 1, -1 }; 

// int dxS[] = {  0, 1, 0, -1 };
// int dyS[] = { -1, 0, 1, 0 };

int main(void)
{
    read;
    write;
    string s;

    while (cin>>s)
    {
        getline(cin,s);
        //cout<<"fprintf(Assembly,\""<<s<<"\\n\");\n";
        string str = s.substr(0, s.length() - 2);
        cout<< "assemblyPrint+="<<str<<";"<<endl;
    }
    
    
}