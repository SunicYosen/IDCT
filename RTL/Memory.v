//Memory.v
//Function : Memory.v Module
//
module Memory(clk,
              rst_b,
              addr,
              data_in,
              write_read,
              data_out);

input wire clk;
input wire rst_b;
input wire [5:0]addr;
input wire [15:0]data_in;
input wire write_read;     //0 for write & 1 for read

output reg [15:0]data_out;

reg [15:0]Memory[63:0];

always @(posedge clk)
if (!write_read)                //Write
    Memory[addr] <= data_in;
else 
    Memory[addr] <= 16'b0;

always @(posedge clk)
if(write_read)                  //READ
    data_out <= Memory[addr];
else 
    data_out <= 16'b0;

endmodule