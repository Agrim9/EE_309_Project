#include<string>
#include<iostream>
#include<fstream>
using namespace std;
char* conv_16(int arg)
{
  char* str1=new char[16];
  for(int i=arg,j=15;j>=0;arg=arg/2,j--)

    str1[j]=(char)(arg%2+(int)'0');
  str1[16]='\0';
  return str1;
}
char* conv_6(int arg)
{
  char* str1=new char[6];
  for(int i=arg,j=5;j>=0;arg=arg/2,j--)

    str1[j]=(char)(arg%2+(int)'0');
  str1[6]='\0';
  return str1;
}
char* conv_9(int arg)
{
  char* str1=new char[9];
  for(int i=arg,j=8;j>=0;arg=arg/2,j--)

    str1[j]=(char)(arg%2+(int)'0');
  str1[9]='\0';
  return str1;
}
int main()
{
string str,reg1,opcode,reg2,reg3,str_9;
ofstream opfile,opfile1;
int address,data_6,data_9;
char a;
char* filename=new char(25);
char* filename2=new char(25);
cout<<"Enter File Name -> ";
cin>>filename;
cout<<"Enter hFile Name -> ";
cin>>filename2;
opfile.open(filename);
opfile1.open(filename2);
while(true)
  {
  cout<<"Instruction(I) or data(D) ?";
  cin>>a;
  if(a=='I') {

  cout<<"Enter Op Code->";
  cin>>str;
  if(str=="EXIT") {opfile<<"0 0000000000000000 0000000000000000";break;}
  opfile<<"1 ";
    if((str=="ADD")||(str=="ADC")||(str=="ADZ")||(str=="NDU")||(str=="NDC")||(str=="NDZ"))
      {
        if((str=="ADD")||(str=="ADC")||(str=="ADZ"))
        opcode="0000";
        else
        opcode="0010";
        cout<<"Enter Reg1(Binary)->";
        cin>>reg1;
        opcode+=reg1;
        cout<<"Enter Reg2(Binary)->";
        cin>>reg2;
        opcode+=reg2;
        cout<<"Enter Reg3(Binary)->";
        cin>>reg3;
        opcode+=reg3;
        if((str=="ADD")||(str=="NDU"))
        opcode+="000";
        else {
          if ((str=="ADC")||(str=="NDC"))
          opcode+="010";
          else opcode+="001";
        }
        cout<<"The Op Code is ->"<<opcode<<endl;
        opfile<<opcode<<" ";
        opfile1<<'\"'<<opcode<<'\"'<<','<<endl;
      }
    if((str=="ADI")||(str=="LW")||(str=="SW")||(str=="BEQ")||(str=="JLR"))
      {
        if(str=="ADI")
        opcode="0001";
        else if(str=="LW")
        opcode="0100";
        else if(str=="SW")
        opcode="0101";
        else if(str=="BEQ")
        opcode="1100";
        else
        opcode="1001";
        cout<<"Enter Reg1(Binary)->";
        cin>>reg1;
        opcode+=reg1;
        cout<<"Enter Reg2(Binary)->";
        cin>>reg2;
        opcode+=reg2;
        if(str!="JLR"){
        cout<<"Enter 6 bit immediate data (decimal)->";
        cin>>data_6;
        opcode+=conv_6(data_6);}
        else opcode+="000000";
        cout<<"The Op Code is ->"<<opcode<<endl;
        opfile<<opcode<<" ";
        opfile1<<'\"'<<opcode<<'\"'<<','<<endl;
      }
      if((str=="LHI")||(str=="LM")||(str=="SM")||(str=="JAL"))
      {
        if(str=="LHI")
        opcode="0011";
        else if(str=="LM")
        opcode="0110";
        else if(str=="SM")
        opcode="0111";
        else if(str=="JAL")
        opcode="1000";
        cout<<"Enter Reg1(Binary)->";
        cin>>reg1;
        opcode+=reg1;

        cout<<"Enter 9 bit immediate data(Decimal) ->";
        cin>>data_9;
        opcode+=conv_9(data_9);

        cout<<"The Op Code is ->"<<opcode<<endl;
        opfile<<opcode<<" ";
        opfile1<<'\"'<<opcode<<'\"'<<','<<endl;
      }

    cout<<"Enter Address (Decimal)-> ";
    cin>>address;
    opfile<<conv_16(address)<<endl;
    if(address==13)   for(int j=1;j<=6;j++) opfile1<<"\"0000000000000000\""<<','<<endl;
    if(address==21)  opfile1<<"\"0000000000000000\""<<','<<endl;
    if(address==24)    for(int j=1;j<=4;j++) opfile1<<"\"0000000000000000\""<<','<<endl;
    if(address==38)    for(int j=1;j<=7;j++) opfile1<<"\"0000000000000000\""<<','<<endl;
  }
  else if(a=='D') {
    opfile<<"1  ";
    cout<<"Enter Data (Decimal)-> ";
    cin>>address;
    opfile<<conv_16(address)<<" ";
    opfile1<<'\"'<<conv_16(address)<<'\"'<<','<<endl;

    cout<<"Enter Address (Decimal)-> ";
    cin>>address;
    opfile<<conv_16(address)<<endl;
    if(address==13)   for(int j=1;j<=6;j++) opfile1<<"\"0000000000000000\""<<','<<endl;
    if(address==21)  opfile1<<"\"0000000000000000\""<<','<<endl;
    if(address==24)    for(int j=1;j<=4;j++) opfile1<<"\"0000000000000000\""<<','<<endl;
    if(address==38)    for(int j=1;j<=7;j++) opfile1<<"\"0000000000000000\""<<','<<endl;
  }
  else {opfile<<"0 0000000000000000 0000000000000000";break;}
}
opfile.close();
opfile1.close();
return 1;
}
