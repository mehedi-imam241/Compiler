#define MAXSIZE 500

class stack
{
private:
    int *stk;
    int top;

public:
    stack();

    bool isempty()
    {

        return top == -1;
    }

    bool isfull()
    {

        return top == MAXSIZE;
    }

    int peek()
    {
        return stk[top];
    }

    int pop()
    {
        int data;

        if (isempty())
        {
        }
        else
        {
            data = stk[top];
            top = top - 1;
            return data;
        }
    }

    int push(int data)
    {

        if (!isfull())
        {
        }
        else
        {
            top = top + 1;
            stk[top] = data;
        }
    }
    ~stack();
};

stack::stack()
{
    top = -1;
    stk = new int[MAXSIZE];
}

stack::~stack()
{
}
