#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main()
{
	vector<int> v{0,0,0,0,0,0,0,0};
	for(int i = 0; i<8; i++)
	{
		for(int i = 0; i<8; i++)
		cout << v[i];
		cout << endl;
		v[1] = 1;
		rotate(v.begin(), v.begin()+1, v.end());
	}
	for(int i = 0; i<8; i++)
	cout << v[i];

}