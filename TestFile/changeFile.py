mode = 2
def main():
    #print (1)
    global mode
    file_handle = open('file_output_1.txt', 'r')
    file_out = open('file_output_new_1.txt', 'w')
	
    while 1:
        line = file_handle.readline()
        #print(line)
        if not line: break
        if('mode = 00' in line):
            mode = 0
            #print (1)
        elif('mode = 01' in line):
            mode = 1
        else:
            if(mode == 0):
                data_out = 'j'+ line
                #print (data_out)
                file_out.write(data_out)
            elif(mode == 1):
                data_out = 'k' + line
                file_out.write(data_out)

                
main()
