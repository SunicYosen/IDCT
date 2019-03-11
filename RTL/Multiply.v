//Multiply.v
//Function : Multiply module

module Multiply(clk,
                rst_b,
                data_multi,
                data_ctr,
                data_result);
                
input wire clk;
input wire rst_b;
input wire [15:0]data_multi;
input wire [6:0]data_ctr;

output reg [22:0]data_result;

reg [22:0]data_multi_l1;
reg [22:0]data_multi_p1;
reg [6:0]data_ctr_p1;

reg [22:0]data_p5p6;
reg [22:0]data_p3p4;
reg [22:0]data_p1p2;
reg [22:0]data_p0;

always @(posedge clk)
if(!rst_b)
    data_multi_p1 <= 23'b0;
else 
    data_multi_p1 <= {(data_multi[15] ? 7'b1111111 : 7'b0000000),data_multi};   //sign num extend

always @(posedge clk)
if(!rst_b)
    data_multi_l1 <= 23'b0;
else 
    data_multi_l1 <= {(data_multi[15] ? 6'b111111 : 6'b000000),data_multi,1'b0};  //sign num extend
//assign data_multi_l1 = data_multi << 1;

always @(posedge clk)
if(!rst_b)
    data_ctr_p1 <= 7'b0;
else data_ctr_p1 <= data_ctr;

always @(posedge clk)
if(!rst_b)
    data_p0 <= 0;
else
    data_p0 <= data_ctr_p1[0] ? data_multi_p1 : 0;
//assign data_p0 = data_ctr_p1[0]?data_multi:0;

always @(posedge clk)
if(!rst_b)
    data_p1p2 <= 0;
else
    data_p1p2 <= data_ctr_p1[2] ? data_multi_l1 : (data_ctr_p1[1] ? data_multi_p1 : 0);
/*
case (data_ctr[2:1])
    2'b01:assign data_p1p2 = data_multi;
    2'b10:assign data_p1p2 = data_multi_l1;
    default: assign data_p1p2 = 0;
endcase
*/

always @(posedge clk)
if(!rst_b)
    data_p3p4 <= 0;
else 
    data_p3p4 <= data_ctr_p1[4]?(data_ctr_p1[3]?data_multi_l1+data_multi_p1:data_multi_l1):(data_ctr_p1[3]?data_multi_p1:0);
/*
case (data_ctr[4:3])
    2'b01: assign data_p3p4 = data_multi;
    2'b11: assign data_p3p4 = data_multi + data_multi_l1;
    2'b10: assign data_p3p4 = data_multi_l1; 
    default: assign data_p3p4 = 0;
endcase
*/

always @(posedge clk)
if(!rst_b)
    data_p5p6 <= 0;
else
    data_p5p6 <= (data_ctr_p1[6]?data_multi_l1:(data_ctr_p1[5]?data_multi_p1:0))<<2;



always @(posedge clk)
if(!rst_b)
    data_result <= 23'b0;
else 
    data_result <= ((data_p5p6 + data_p3p4) << 3) + ((data_p1p2 << 1) + data_p0);
//assign data_result = ((data_p5p6 + data_p3p4)<<3) + (data_p1p2 << 1)+ data_p0;

endmodule