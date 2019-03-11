analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/Multiply.v
analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/Memory.v
analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/MemChange.v
analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/IDCT_row.v
analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/IDCT_col.v
analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/IDCTTop.v
analyze -format verilog /home/sun/Files/ModelsimProjects/IDCTTop/RTL/idct_chip.v
elaborate idct_chip

#analyze -format verilog ../../RTL/Multiply.v
#analyze -format verilog ../../RTL/Memory.v
#analyze -format verilog ../../RTL/MemChange.v
#analyze -format verilog ../../RTL/IDCT_row.v
#analyze -format verilog ../../RTL/IDCT_col.v
#analyze -format verilog ../../RTL/IDCTTop.v
#analyze -format verilog ../../RTL/idct_chip.v
#read_verilog ../rtl/idct/even_odd.v
#read_verilog ../rtl/idct/mem4x4.v
#read_verilog ../rtl/idct/mem8x8.v
#read_verilog ../rtl/idct/mem_ctrl_tran.v
#read_verilog ../rtl/idct/p2s.v
#read_verilog ../rtl/idct/s2p.v
#read_verilog ../rtl/idct/idct4.v

#read_verilog ../rtl/idct/idct8.v

#read_verilog ../rtl/idct/idct_cal.v

#read_verilog ../rtl/idct/idct.v
#read_verilog ../rtl/idct/idct_chip.v
