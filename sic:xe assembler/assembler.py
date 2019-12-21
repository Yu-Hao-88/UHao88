import math

opcode = {'ADD':'18','ADDF':'58','ADDR':'90',
              'AND':'40',
              'CLEAR':'B4',
              'COMP':'28','COMPF':'88','COMPR':'A0',
              'DIV':'24','DIVF':'64','DIVR':'9C',
              'FIX':'C4',
              'FLOAT':'C0',
              'HIO':'F4',
              'J':'3C','JEQ':'30','JGT':'34','JLT':'38','JSUB':'48',
              'LDA':'00','LDB':'68','LDCH':'50','LDF':'70','LDL':'08','LDS':'6C','LDT':'74','LDX':'04',
              'LPS':'D0',
              'MUL':'20','MULF':'60','MULR':'98',
              'NORM':'C8','OR':'44',
              'RD':'D8',
              'RMO':'AC','RSUB':'4C',
              'SHIFTL':'A4','SHIFTR':'A8',
              'SIO':'F0',
              'SSK':'EC',
              'STA':'0C','STB':'78','STCH':'54','STF':'80','STI':'D4','STL':'14','STS':'7C','STSW':'E8','STT':'84','STX':'10',
              'SUB':'1C','SUBF':'5C','SUBR':'94',
              'SVC':'B0',
              'TD':'E0','TIO':'F8',
              'TIX':'2C','TIXR':'B8',
              'WD':'DC'}
def inputData(dataName): #讀入檔案
    try:
        f=open(dataName,'r')
        print('read success')
        lineList=f.readlines()
        data=[]
        for line in lineList:
            #print(line)
            data.append(line.split())
        f.close()
        return data
            
    except:
        print('file is not exist')

def getTagName(data):
    for i in data:
        if len(data) == 3:
            print(i[0])

def getMnemonic(i):   
    return i[1] if len(i) == 3 else i[0]

def getSource(i):   
    return i[3] if len(i) == 4 else i[2]

def printAll(data): #印出整份
    for i in data:
        for e in i:
            print("{0:10}".format(e),end='')
        print()

def SYMTAB(data,sym):  #建立SYMTAB並印出
    for i in data:
        if len(i)==4:
            sym[i[1]]=i[0]
        if i[0]=='BASE':
            sym[i[0]]=i[1]
    for i in sym:
        print("{0:8}".format(i),"{0:8}".format(sym[i]))
    return sym

def hexi(num): #int 轉 hex
    temp=hex(num)
    temp=temp[2:]
    temp=temp.zfill(4)
    return temp

def pass1(data):
    LOCcount=0
    for i in data:
        body=getMnemonic(i)
        if body =="START":
            LOCcount=int(getSource(i))
            i.insert(0,hexi(LOCcount))
            continue
        if body=='BASE' or body=='END':
            continue
        i.insert(0,hexi(LOCcount))
        if body[0]=='+':
            LOCcount+=4
        elif body=='RESW':
            LOCcount+=int(getSource(i))*3
        elif body=='RESB':
            LOCcount+=int(getSource(i))
        elif body=='CLEAR' or body=='COMPR' or body=='TIXR':
            LOCcount+=2
        elif body=='BYTE':
            source=getSource(i)
            if source[0]=='C':
                LOCcount+=3
            elif source[0]=='X':
                LOCcount+=1
        else:
            LOCcount+=3
    return LOCcount
def sort(data): #排版
    for i in data:
        if len(i)<4:
            if i[0]=='END' or i[0]=='BASE':
                i.insert(0,'')
                
            i.insert(1,'')

#----------------------------------進位轉進位
def bin_to_dec(bin_str):
    bin = [int(n) for n in bin_str ]
    dec = [bin[-i - 1] * math.pow(2, i) for i in range(len(bin))]
    return int(sum(dec))

def dec_to_hex(dec):
    hex = []
    while dec / 16 > 0:
        hex.append(dec % 16)
        dec = dec // 16
    hex.reverse()
    return ''.join([chr(n + 55) if n > 9 else chr(n + 48) for n in hex])

def bin_to_hex(bin_str):
    dec = bin_to_dec(bin_str)
    hex = dec_to_hex(dec)
    return hex

def hex_to_dec(hex_str):
    hex = [ord(n) - 55 if n in list("ABCDEF") else ord(n) - 48 for n in hex_str.upper()]
    dec = [hex[-i - 1] * math.pow(16, i) for i in range(len(hex))]
    return int(sum(dec))

def dec_to_bin(dec):
    bin = []
    while dec / 2 > 0:
        bin.append(str(dec % 2))
        dec = dec // 2
    bin.reverse()
    return ''.join(bin)
#----------------------------------進位轉進位
def twoCom(B):
    new=''
    for i in range(len(B)):
        if B[i]=='0':
            new+='1'
        else:
            new+='0'
    new=dec_to_bin(bin_to_dec(str(new))+1)
    return new
def bini(num,what): #int 轉 bin
    if num<0:
        temp=bin(-num)
        temp=temp[2:]
        temp=twoCom(temp.zfill(12))
        return temp
    else:
        temp=bin(num)
        temp=temp[2:]
    if what=='disp':
        temp=temp.zfill(12)
    else:
        temp=temp.zfill(8)
    return temp

def objectCode(code,n,l,x,b,p,e,disp): #給定資料回傳objectcode
    xbpe=str(x)+str(b)+str(p)+str(e)
    nl=str(n)+str(l)
    opnl=hex_to_dec(opcode[code])+bin_to_dec(nl)
    if e==1 or (b==0 and p==0 and e==0):
        fill=5
        if e==0:
            fill=3
        disp=disp.zfill(fill)
        objectCode=bini(opnl,'opnl')+xbpe
        return (bin_to_hex(objectCode)+disp).zfill(6)
    else:    
        objectCode=bini(opnl,'opnl')+xbpe+bini(disp,'disp')
    return bin_to_hex(objectCode).zfill(6)

def nextLoc(i,data): #找下一個loc
    count=1
    if data[data.index(i,0,len(data))+1][2]=='BASE':
        count=2
    nextLOC=data[data.index(i,0,len(data))+count][0]
    return nextLOC
register={          #register編號
    'A':'0',
    'X':'1',
    'L':'2',
    'B':'3',
    'S':'4',
    'T':'5',
    'F':'6',
    'PC':'8',
    'SW':'9'
}
def appendToTex(tex,lastAddress,temp):
    length=lastAddress-hex_to_dec(temp[1])
    temp.insert(2,dec_to_hex(length).zfill(2))
    tex.append(listToString(temp))
    return tex
def tempRefresh(temp,i):
    temp.clear()
    temp.append('T')
    temp.append(i[0].zfill(6))
    temp.append(i[4])
def pass2(data,sym,LOCcount):
    OP=[] #objectprogram
    tex=[]
    mod=[]
    bit=0
    temp=[]
    for i in data:
        try:
            n=1
            l=1
            x=0
            b=0
            p=1
            e=0
            code=i[2]
            target=''
            if code=='START':
                head='H'+i[1]  #for H record
                if len(i[1])<6:
                    for e in range(len(i[1]),6):
                        head+=' '
                head+=i[0].zfill(6)
                head+=hexi(LOCcount).zfill(6)
                OP.append(head)
                continue
            if code=='END':
                tex=appendToTex(tex,int(LOCcount),temp)
                continue
            if code=='BASE':
                continue
            if (code=='RESW' or code=='RESB' )and bit!=0:
                tex=appendToTex(tex,hex_to_dec(i[0]),temp)
                temp.clear()
                bit=0
                continue
            if code=='RESW' or code=='RESB' :
                continue
            if bit==0:
                temp.append('T')
                temp.append(i[0].zfill(6))
                bit=9
            if len(i)==4:    
                target=i[3]
            else:
                target='0'
                i.append('')

            if code=='BYTE':
                if target[0]=='C':
                    objectcode=dec_to_hex(ord(target[2]))+dec_to_hex(ord(target[3]))+dec_to_hex(ord(target[4]))
                elif target[0]=='X':
                    objectcode=target[2]+target[3]
                #print(objectcode)
                i.append(objectcode)
                if bit+len(i[4])>69 :
                    tex=appendToTex(tex,hex_to_dec(i[0]),temp)
                    tempRefresh(temp,i)
                    bit=9+len(i[4])
                else:
                    temp.append(i[4])
                    bit+=len(i[4])
                continue
            if code=='CLEAR' or code=='TIXR':
                objectcode=opcode[code]+register[target]+'0'
                #print(objectcode)
                i.append(objectcode)
                if bit+len(i[4])>69 :
                    tex=appendToTex(tex,hex_to_dec(i[0]),temp)
                    tempRefresh(temp,i)
                    bit=9+len(i[4])
                else:
                    temp.append(i[4])
                    bit+=len(i[4])
                continue
            if code=='COMPR':
                objectcode=opcode[code]+register[target[0]]+register[target[2]]
                #print(objectcode)
                i.append(objectcode)
                if bit+len(i[4])>69 :
                    tex=appendToTex(tex,hex_to_dec(i[0]),temp[1])
                    tempRefresh(temp,i)
                    bit=9+len(i[4])
                else:
                    temp.append(i[4])
                    bit+=len(i[4])
                continue
            try:
                if ',X' in target:
                    x=1
                    target=target[:-2]
                if target[0]=='#': #n=0 l=1
                    target=sym[target[1:]]
                    n=0
                    l=1
                elif target[0]=='@':
                    target=sym[target[1:]]
                    n=1
                    l=0
                else: #n=1 l=1
                    target=sym[target]
                nextLOC=nextLoc(i,data)
                disp=hex_to_dec(target)-hex_to_dec(nextLOC)
            
                if e==0 and -2048<=disp<=2047:
                    p=1
                    b=0
                elif e==0 or disp>2047:
                    b=1
                    p=0
                    disp=hex_to_dec(target)-hex_to_dec(sym[sym['BASE']])

            except:
                p=0
                if target[0]=='#': #n=0 l=1
                    target=target[1:]
                    n=0
                    l=1

                else: #n=1 l=1
                    target=target
                disp=target

            if code[0]=='+':
                code=code[1:]
                e=1
                p=0
                b=0
                disp=target
                if n==0 and l==1:
                    disp=hexi(int(disp))
            #print(objectCode(code,n,l,x,b,p,e,disp))
            i.append(objectCode(code,n,l,x,b,p,e,disp))
            if i[2][0]=='+' and i[3][0]!='#': #for M record
                tmp=''
                tmp+='M'
                tmp+=hexi(hex_to_dec(i[0])+1).zfill(6)
                tmp+=dec_to_hex(2*(hex_to_dec(nextLoc(i,data))-hex_to_dec(i[0])-1))
                mod.append(tmp)

            if bit+len(i[4])>69 :
                tex=appendToTex(tex,hex_to_dec(i[0]),temp)
                tempRefresh(temp,i)
                bit=9+len(i[4])
            else:
                temp.append(i[4])
                bit+=len(i[4])
        except:
            print('error')
    for i in tex:
        OP.append(i)
    for i in mod:
        OP.append(i)
    OP.append('E'+data[0][0].zfill(6)) #for E record
    return OP
def listToString(list):
    Str=''
    for i in list:
        Str+=i
    return Str
def output(OP):
    f = open("output.txt", "w")

    for i in OP:
        print(i, file = f)

    f.close()
print('Please input data name-->',end='')
data=inputData('input.txt')
LOCcount=pass1(data)
print(LOCcount)
sym={}
sym=SYMTAB(data,sym)
sort(data)
#printAll(data)
OP=pass2(data,sym,LOCcount)
printAll(data)
output(OP)
print(OP)