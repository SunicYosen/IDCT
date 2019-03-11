//MemChange.v
//Function : Control Memory 

//`include "/home/sun/Files/ModelsimProjects/IDCTTop/RTL/Memory.v"

module MemChange(clk,
                 rst_b,
                 data_in,
                 start,
                 mode_data_in,
                 data_out,
                 mode_data_out,
                 output_start_col);
input wire clk;
input wire rst_b;
input wire [15:0]data_in;
input wire mode_data_in;
input wire start;

output reg [15:0]data_out;
output reg mode_data_out;
output reg output_start_col;

reg output_start;

reg Mem1_mode;
reg Mem2_mode;

reg [5:0]Mem1_addr;
reg [5:0]Mem1_addr_temp;

reg write_read_Mem1;
wire [15:0]data_out_Mem1;

wire [15:0]data_out_Mem2;
reg write_read_Mem2;
reg [5:0]Mem2_addr;
reg [5:0]Mem2_addr_temp;

/*
reg [5:0]Memory8[0:63];
reg [3:0]Memory4[0:15];

always @(posedge clk)
if (!rst_b)
begin
    Memory4[0] <= 4'b0000;
    Memory4[1] <= 4'b0100;
    Memory4[2] <= 4'b1000;
    Memory4[3] <= 4'b1100;

    Memory4[4] <= 4'b0001;
    Memory4[5] <= 4'b0101;
    Memory4[6] <= 4'b1001;
    Memory4[7] <= 4'b1101;

    Memory4[8] <= 4'b0010;
    Memory4[9] <= 4'b0110;
    Memory4[10] <= 4'b1010;
    Memory4[11] <= 4'b1110;

    Memory4[12] <= 4'b0011;
    Memory4[13] <= 4'b0111;
    Memory4[14] <= 4'b1011;
    Memory4[15] <= 4'b1111;
end
*/
/*
always @(posedge clk)
if(!rst_b)
*/


always @(posedge clk)                    //Mem1: write(0) or read(1) 
if(!rst_b)
    write_read_Mem1 <= 1'b0;
else if(start & Mem1_addr == 6'b111111)
    write_read_Mem1 <= !write_read_Mem1;
else 
    write_read_Mem1 <= write_read_Mem1;

always @(posedge clk)                   //Mem2: write(0) or read(1) 
if(!rst_b)
    write_read_Mem2 <= 1'b1;
else if(start & Mem2_addr == 6'b111111)
    write_read_Mem2 <= !write_read_Mem2;
else 
    write_read_Mem2 <= write_read_Mem2;

always @(posedge clk)                     //Mem1 4*4 or 8*8
if(!rst_b)
    Mem1_mode <= 1'b1;
else if(start & !write_read_Mem1)
    Mem1_mode <= mode_data_in;
else 
    Mem1_mode <= Mem1_mode;

always @(posedge clk)                      //Mem2 4*4 or 8*8
if(!rst_b)
    Mem2_mode <= 1'b1;
else if(start & !write_read_Mem2)
    Mem2_mode <= mode_data_in;
else 
    Mem2_mode <= Mem2_mode;

always @(posedge clk)                      //Output Start
if(!rst_b)
    output_start <= 1'b0;
else if(Mem1_addr == 6'b111111)
    output_start <= 1'b1;
else 
    output_start <= output_start;

always @(posedge clk)
if(!rst_b)
    output_start_col <= 1'b0;
else output_start_col <= output_start;

always @(posedge clk)                     //Mode data out
if(!rst_b)
    mode_data_out <= 1'b1;
else
    mode_data_out <= write_read_Mem1 ? Mem1_mode : Mem2_mode;


always @(posedge clk)                     //Data out
if(!rst_b)
    data_out <= 16'b0;
else if(output_start)
    data_out <= write_read_Mem1 ? data_out_Mem1 : data_out_Mem2;
else 
    data_out <= 16'b0;

always @(posedge clk)                   //Address temp 0-63
if(!rst_b)
    Mem1_addr_temp <= 6'b000001;
else if(start)
    Mem1_addr_temp <= Mem1_addr_temp + 1'b1;
else Mem1_addr_temp <= Mem1_addr_temp;

always @(posedge clk)                   //Address temp 0-63
if(!rst_b)
    Mem2_addr_temp <= 6'b000001;
else if(start)
    Mem2_addr_temp <= Mem2_addr_temp + 1'b1;
else Mem2_addr_temp <= Mem2_addr_temp;

always @(posedge clk)                   //Address 0-63
if(!rst_b)
    Mem1_addr <= 6'b0;
else if(start & !write_read_Mem1)
    Mem1_addr <= Mem1_addr + 1'b1;

else if(start & write_read_Mem1 & !Mem1_mode)
    Mem1_addr <= {Mem1_addr_temp[5:4],Mem1_addr_temp[1:0],Mem1_addr_temp[3:2]};

else if(start & write_read_Mem1 & Mem1_mode)
    Mem1_addr <= {Mem1_addr_temp[2:0],Mem1_addr_temp[5:3]};

else Mem1_addr <= Mem1_addr;

always @(posedge clk)                   //Address 0-63
if(!rst_b)
    Mem2_addr <= 6'b0;
else if(start & !write_read_Mem2)
    Mem2_addr <= Mem2_addr + 1'b1;

else if(start & write_read_Mem2 & !Mem2_mode)
    Mem2_addr <= {Mem2_addr_temp[5:4],Mem2_addr_temp[1:0],Mem2_addr_temp[3:2]};

else if(start & write_read_Mem2 & Mem2_mode)
    Mem2_addr <= {Mem2_addr_temp[2:0],Mem2_addr_temp[5:3]};

else Mem2_addr <= Mem2_addr;



Memory Memory1(.clk(clk),
               .rst_b(rst_b),
               .addr(Mem1_addr),
               .data_in(data_in),
               .write_read(write_read_Mem1),
               .data_out(data_out_Mem1));

Memory Memory2(.clk(clk),
               .rst_b(rst_b),
               .addr(Mem2_addr),
               .data_in(data_in),
               .write_read(write_read_Mem2),
               .data_out(data_out_Mem2));

endmodule