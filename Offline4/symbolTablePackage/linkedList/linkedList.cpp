#include "symbolInfo.h"

FILE* logout;

class linkedList
{
private:
    symbolINfo *Head;

public:
    linkedList()
    {
        Head = nullptr;
    };

    int insert(const string &name, string const &type)
    {
        pair<int, symbolINfo *> p = search(name);
        int pos = p.first;

        if (pos != -1)
            return -1;

        symbolINfo *newNode = new symbolINfo(name, type);

        if (Head == NULL)
        {
            Head = newNode;
            pos = 0;
        }

        else
        {
            symbolINfo *temp = Head;
            pos = 0;

            // last node's next address will be NULL.
            while (temp->next != NULL)
            {
                temp = temp->next;
                pos++;
            }

            // add the newNode at the end of the linked list
            temp->next = newNode;
            pos++;
        }
        return pos;
    }

    pair<int, symbolINfo *> search(string const &name)
    {
        symbolINfo *temp = Head;
        int pos = 0;
        while (temp)
        {
            if (temp->getName() == name)
                return {pos, temp};

            pos++;
            temp = temp->next;
        }
        return {-1, nullptr};
    }

    int remove(string name)
    {
        int pos = 0;
        symbolINfo *temp;

        if (Head)
        {
            if (Head->getName() == name)
            {
                temp = Head;
                Head = Head->next;
                delete temp;
            }
            else
            {
                bool found = false;
                symbolINfo *current = Head;
                while (current->next != NULL)
                {

                    if (current->next->getName() == name)
                    {
                        temp = current->next;
                        current->next = current->next->next;
                        delete temp;
                        found = true;
                        break;
                    }
                    else
                    {
                        current = current->next;
                    }
                    pos++;
                }
                pos = found ? pos : -1;
            }
        }
        else
        {
            pos = -1;
        }

        return pos;
    }

    void display(int i)
    {
        symbolINfo *temp = Head;

        if (Head)
            fprintf(logout, "%d --> ", i);

        while (temp)
        {
            fprintf(logout, " < %s : %s >", temp->getName().c_str(), temp->getType().c_str());
            // cout << " < " << temp->getName() << " : " << temp->getType() << " >";
            temp = temp->next;
        }

        if (Head)
            fprintf(logout, "\n");
        // cout << endl;
    }

    ~linkedList()
    {
        if (Head != nullptr)
        {
            while (Head->next != nullptr)
            {
                symbolINfo *temp = Head->next;
                delete Head;
                Head = temp;
            }
            delete Head;
        }
    };
};

// int main()
// {

//     linkedList l;
//     // inserting elements
//     l.insert("ami", "123");
//     l.insert("ami1", "12");
//     l.insert("ami2", "12");
//     l.insert("ami3", "12");
//     cout << "Current Linked List: ";
//     l.display();

//     cout << "Deleting am,123: ";
//     l.remove("ami", "123");
//     l.display();

//     cout << "Deleting 13: ";
//     l.remove("ami1", "12");

//     cout << "Searching for 7: ";
//     cout << l.search("ami2", "12") << endl;

//     cout << "Searching for 13: ";
//     cout << l.search("ami", "123") << endl;

//     linkedList l1;

//     l1.insert("ami", "123");
//     l1.insert("ami1", "12");
//     l1.insert("ami2", "12");
//     l1.insert("ami3", "12");
//     cout << "Current Linked List: ";
//     l1.display();

//     // cout << "Deleting am,123: ";
//     // l1.remove("ami", "123");
//     // l1.display();

//     // cout << "Deleting 13: ";
//     // l1.remove("ami1", "12");

//     cout << "Searching for 7: ";
//     cout << l1.search("ami2", "12") << endl;

//     cout << "Searching for 13: ";
//     cout << l1.search("ami", "123") << endl;
// }
