//IDCT_row.v
//Function：IDCT row Change

//`include "Multiply.v"

module IDCT_row(input wire clk, 
             input wire rst_b,
             input wire [15:0]data_in,
             input wire mode_flag,
             output reg out_mode_flag,
             output reg [15:0]data_out,
             output reg output_start);
  
/*
wire [15:0]data_in;                  //Data in
wire clk;                            //CLK signal
wire rst_b;                          //reset signal
wire mode_flag;                     //0 for 4x4 & 1 for 8x8

reg [15:0]data_out;           //Data for data out
*/

reg [15:0]data_in_stage0;     //Data in pipeline
reg [15:0]data_in_stage1;
reg [15:0]data_in_stage2;
reg [15:0]data_in_stage3;
reg [15:0]data_in_stage4;
reg [15:0]data_in_stage5;
reg [15:0]data_in_stage6;
reg [15:0]data_in_stage7;

reg mode_flag_stage0;        //mode flag pipeline
reg mode_flag_stage1;
reg mode_flag_stage2;
reg mode_flag_stage3;
reg mode_flag_stage4;
reg mode_flag_stage5;
reg mode_flag_stage6;
reg mode_flag_stage7;
reg mode_flag_stage8;       //For delay
reg mode_flag_stage9;
reg mode_flag_stage10;
reg mode_flag_stage11;
reg mode_flag_stage12;
reg mode_flag_stage13;

reg [22:0]data_out_0;           //data out
reg [22:0]data_out_1;
reg [22:0]data_out_2;
reg [22:0]data_out_3;
reg [22:0]data_out_4;
reg [22:0]data_out_5;
reg [22:0]data_out_6;
reg [22:0]data_out_7;

reg [2:0]count_stage;
reg [2:0]count_stage_1;
reg [2:0]count_stage0;          //count the num of input pipeline.
reg [2:0]count_stage1;
reg [2:0]count_stage2;
reg [2:0]count_stage3;
reg [2:0]count_stage4;
reg [2:0]count_stage5;
reg [2:0]count_stage6;
reg [2:0]count_stage7;

reg [6:0]multiply_ctr_0;
reg [6:0]multiply_ctr_1;
reg [6:0]multiply_ctr_2;
reg [6:0]multiply_ctr_3;
reg [6:0]multiply_ctr_4;
reg [6:0]multiply_ctr_5;
reg [6:0]multiply_ctr_6;
reg [6:0]multiply_ctr_7;

reg [6:0]Mem_multiCtr[6:0];

reg [2:0]Mem_multiCtr_addr_8_stage07[7:0];    //Keep the map of 8x8. 
reg [2:0]Mem_multiCtr_addr_8_stage16[7:0];
reg [2:0]Mem_multiCtr_addr_8_stage25[7:0];
reg [2:0]Mem_multiCtr_addr_8_stage34[7:0];

reg [2:0]Mem_multiCtr_addr_4_stage03[3:0];
reg [2:0]Mem_multiCtr_addr_4_stage12[3:0];

wire [22:0]multi_res_stage0;
wire [22:0]multi_res_stage1;
wire [22:0]multi_res_stage2;
wire [22:0]multi_res_stage3;
wire [22:0]multi_res_stage4;
wire [22:0]multi_res_stage5;
wire [22:0]multi_res_stage6;
wire [22:0]multi_res_stage7;

wire [22:0]data_out_Temp_0;
wire [22:0]data_out_Temp_1;
wire [22:0]data_out_Temp_2;
wire [22:0]data_out_Temp_3;
wire [22:0]data_out_Temp_4;
wire [22:0]data_out_Temp_5;
wire [22:0]data_out_Temp_6;
wire [22:0]data_out_Temp_7;

always @ (posedge clk)
if(!rst_b)
    begin
      Mem_multiCtr[0] <= 7'b1000000;    //64
      Mem_multiCtr[1] <= 7'b1011001;    //89
      Mem_multiCtr[2] <= 7'b1010011;    //83
      Mem_multiCtr[3] <= 7'b1001011;    //75
      Mem_multiCtr[4] <= 7'b0110010;    //50
      Mem_multiCtr[5] <= 7'b0100100;    //36
      Mem_multiCtr[6] <= 7'b0010010;    //18
    end
else 
    begin
      Mem_multiCtr[0] <= 7'b1000000;    //64
      Mem_multiCtr[1] <= 7'b1011001;    //89
      Mem_multiCtr[2] <= 7'b1010011;    //83
      Mem_multiCtr[3] <= 7'b1001011;    //75
      Mem_multiCtr[4] <= 7'b0110010;    //50
      Mem_multiCtr[5] <= 7'b0100100;    //36
      Mem_multiCtr[6] <= 7'b0010010;    //18
    end

//Initial the ctr data. 8*8
always @ (posedge clk)
if(!rst_b)
    begin
        Mem_multiCtr_addr_8_stage07[0] = 3'b000;
        Mem_multiCtr_addr_8_stage07[1] = 3'b001;
        Mem_multiCtr_addr_8_stage07[2] = 3'b010;
        Mem_multiCtr_addr_8_stage07[3] = 3'b011;
        Mem_multiCtr_addr_8_stage07[4] = 3'b000;
        Mem_multiCtr_addr_8_stage07[5] = 3'b100;
        Mem_multiCtr_addr_8_stage07[6] = 3'b101;
        Mem_multiCtr_addr_8_stage07[7] = 3'b110;
    end
else
    begin
        Mem_multiCtr_addr_8_stage07[0] = 3'b000;
        Mem_multiCtr_addr_8_stage07[1] = 3'b001;
        Mem_multiCtr_addr_8_stage07[2] = 3'b010;
        Mem_multiCtr_addr_8_stage07[3] = 3'b011;
        Mem_multiCtr_addr_8_stage07[4] = 3'b000;
        Mem_multiCtr_addr_8_stage07[5] = 3'b100;
        Mem_multiCtr_addr_8_stage07[6] = 3'b101;
        Mem_multiCtr_addr_8_stage07[7] = 3'b110;
    end

always @ (posedge clk)
if(!rst_b)
    begin
        Mem_multiCtr_addr_8_stage16[0] = 3'b000;
        Mem_multiCtr_addr_8_stage16[1] = 3'b011;
        Mem_multiCtr_addr_8_stage16[2] = 3'b101;
        Mem_multiCtr_addr_8_stage16[3] = 3'b110;
        Mem_multiCtr_addr_8_stage16[4] = 3'b000;
        Mem_multiCtr_addr_8_stage16[5] = 3'b001;
        Mem_multiCtr_addr_8_stage16[6] = 3'b010;
        Mem_multiCtr_addr_8_stage16[7] = 3'b100;
    end
else
    begin
        Mem_multiCtr_addr_8_stage16[0] = 3'b000;
        Mem_multiCtr_addr_8_stage16[1] = 3'b011;
        Mem_multiCtr_addr_8_stage16[2] = 3'b101;
        Mem_multiCtr_addr_8_stage16[3] = 3'b110;
        Mem_multiCtr_addr_8_stage16[4] = 3'b000;
        Mem_multiCtr_addr_8_stage16[5] = 3'b001;
        Mem_multiCtr_addr_8_stage16[6] = 3'b010;
        Mem_multiCtr_addr_8_stage16[7] = 3'b100;
    end

always @ (posedge clk)
if(!rst_b)
    begin
        Mem_multiCtr_addr_8_stage25[0] = 3'b000;
        Mem_multiCtr_addr_8_stage25[1] = 3'b100;
        Mem_multiCtr_addr_8_stage25[2] = 3'b101;
        Mem_multiCtr_addr_8_stage25[3] = 3'b001;
        Mem_multiCtr_addr_8_stage25[4] = 3'b000;
        Mem_multiCtr_addr_8_stage25[5] = 3'b110;
        Mem_multiCtr_addr_8_stage25[6] = 3'b010;
        Mem_multiCtr_addr_8_stage25[7] = 3'b011;
    end
else
    begin
        Mem_multiCtr_addr_8_stage25[0] = 3'b000;
        Mem_multiCtr_addr_8_stage25[1] = 3'b100;
        Mem_multiCtr_addr_8_stage25[2] = 3'b101;
        Mem_multiCtr_addr_8_stage25[3] = 3'b001;
        Mem_multiCtr_addr_8_stage25[4] = 3'b000;
        Mem_multiCtr_addr_8_stage25[5] = 3'b110;
        Mem_multiCtr_addr_8_stage25[6] = 3'b010;
        Mem_multiCtr_addr_8_stage25[7] = 3'b011;
    end

always @ (posedge clk)
if(!rst_b)
    begin
        Mem_multiCtr_addr_8_stage34[0] = 3'b000;
        Mem_multiCtr_addr_8_stage34[1] = 3'b110;
        Mem_multiCtr_addr_8_stage34[2] = 3'b010;
        Mem_multiCtr_addr_8_stage34[3] = 3'b100;
        Mem_multiCtr_addr_8_stage34[4] = 3'b000;
        Mem_multiCtr_addr_8_stage34[5] = 3'b011;
        Mem_multiCtr_addr_8_stage34[6] = 3'b101;
        Mem_multiCtr_addr_8_stage34[7] = 3'b001;
    end

else 
    begin
        Mem_multiCtr_addr_8_stage34[0] = 3'b000;
        Mem_multiCtr_addr_8_stage34[1] = 3'b110;
        Mem_multiCtr_addr_8_stage34[2] = 3'b010;
        Mem_multiCtr_addr_8_stage34[3] = 3'b100;
        Mem_multiCtr_addr_8_stage34[4] = 3'b000;
        Mem_multiCtr_addr_8_stage34[5] = 3'b011;
        Mem_multiCtr_addr_8_stage34[6] = 3'b101;
        Mem_multiCtr_addr_8_stage34[7] = 3'b001;
    end

//Initial the ctr data. 4*4
always @(posedge clk)
if(!rst_b)
    begin
        Mem_multiCtr_addr_4_stage03[0] = 3'b000;
        Mem_multiCtr_addr_4_stage03[1] = 3'b010;
        Mem_multiCtr_addr_4_stage03[2] = 3'b000;
        Mem_multiCtr_addr_4_stage03[3] = 3'b101;
    end
else 
    begin
        Mem_multiCtr_addr_4_stage03[0] = 3'b000;
        Mem_multiCtr_addr_4_stage03[1] = 3'b010;
        Mem_multiCtr_addr_4_stage03[2] = 3'b000;
        Mem_multiCtr_addr_4_stage03[3] = 3'b101;
    end

always @(posedge clk)
if(!rst_b)
    begin
        Mem_multiCtr_addr_4_stage12[0] = 3'b000;
        Mem_multiCtr_addr_4_stage12[1] = 3'b101;
        Mem_multiCtr_addr_4_stage12[2] = 3'b000;
        Mem_multiCtr_addr_4_stage12[3] = 3'b010;
    end
else 
    begin
        Mem_multiCtr_addr_4_stage12[0] = 3'b000;
        Mem_multiCtr_addr_4_stage12[1] = 3'b101;
        Mem_multiCtr_addr_4_stage12[2] = 3'b000;
        Mem_multiCtr_addr_4_stage12[3] = 3'b010;
    end

//pipeline the data_in
always @(posedge clk)
if(!rst_b)
    data_in_stage0 <= 16'b0;
else
    data_in_stage0 <= data_in;

always @(posedge clk)
if(!rst_b)
    data_in_stage1 <= 16'b0;
else 
    data_in_stage1 <= data_in_stage0;

always @(posedge clk)
if(!rst_b)
    data_in_stage2 <= 16'b0;
else 
    data_in_stage2 <= data_in_stage1;

always @(posedge clk)
if(!rst_b)
    data_in_stage3 <= 16'b0;
else 
    data_in_stage3 <= data_in_stage2;

always @(posedge clk)
if(!rst_b)
    data_in_stage4 <= 16'b0;
else 
    data_in_stage4 <= data_in_stage3;

always @(posedge clk)
if(!rst_b)
    data_in_stage5 <= 16'b0;
else 
    data_in_stage5 <= data_in_stage4;

always @(posedge clk)
if(!rst_b)
    data_in_stage6 <= 16'b0;
else 
    data_in_stage6 <= data_in_stage5;

always @(posedge clk)
if(!rst_b)
    data_in_stage7 <= 16'b0;
else 
    data_in_stage7 <= data_in_stage6;
    
//End of pipeline data_in

//pipeline mode flag
always @(posedge clk)
if(!rst_b)
    mode_flag_stage0 <= 1'b0;
else
    mode_flag_stage0 <= mode_flag;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage1 <= 1'b0;
else 
    mode_flag_stage1 <= mode_flag_stage0;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage2 <= 1'b0;
else 
    mode_flag_stage2 <= mode_flag_stage1;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage3 <= 1'b0;
else 
    mode_flag_stage3 <= mode_flag_stage2;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage4 <= 1'b0;
else 
    mode_flag_stage4 <= mode_flag_stage3;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage5 <= 1'b0;
else 
    mode_flag_stage5 <= mode_flag_stage4;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage6 <= 1'b0;
else 
    mode_flag_stage6 <= mode_flag_stage5;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage7 <= 1'b0;
else 
    mode_flag_stage7 <= mode_flag_stage6;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage8 <= 1'b0;
else 
    mode_flag_stage8 <= mode_flag_stage7;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage9 <= 1'b0;
else 
    mode_flag_stage9 <= mode_flag_stage8;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage10 <= 1'b0;
else 
    mode_flag_stage10 <= mode_flag_stage9;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage11 <= 1'b0;
else 
    mode_flag_stage11 <= mode_flag_stage10;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage12 <= 1'b0;
else 
    mode_flag_stage12 <= mode_flag_stage11;

always @(posedge clk)
if(!rst_b)
    mode_flag_stage13 <= 1'b0;
else 
    mode_flag_stage13 <= mode_flag_stage12;
//End of pipeline mode flag


//count pipeline
always @(posedge clk)
if(!rst_b)
    count_stage <= 3'b0;
else 
    count_stage <= count_stage + 1'b1;

always @(posedge clk)
if(!rst_b)
    count_stage_1 <= 3'b0;
else 
    count_stage_1 <= count_stage;

always @(posedge clk)
if(!rst_b)
    count_stage0 <= 3'b0;
else 
    count_stage0 <= count_stage_1;

always @(posedge clk)
if(!rst_b)
    count_stage1 <= 3'b0;
else 
    count_stage1 <= count_stage0;

always @(posedge clk)
if(!rst_b)
    count_stage2 <= 3'b0;
else 
    count_stage2 <= count_stage1;

always @(posedge clk)
if(!rst_b)
    count_stage3 <= 3'b0;
else 
    count_stage3 <= count_stage2;

always @(posedge clk)
if(!rst_b)
    count_stage4 <= 3'b0;
else 
    count_stage4 <= count_stage3;

always @(posedge clk)
if(!rst_b)
    count_stage5 <= 3'b0;
else 
    count_stage5 <= count_stage4;

always @(posedge clk)
if(!rst_b)
    count_stage6 <= 3'b0;
else 
    count_stage6 <= count_stage5;

always @(posedge clk)
if(!rst_b)
    count_stage7 <= 3'b0;
else 
    count_stage7 <= count_stage6;
//END count pipeliine

/*
//Count
always @(posedge clk)
if(!rst_b)
    count_clk <= 8'b0;
else 
    count_clk <= count_clk + 1;
*/
always @(posedge clk)
if(!rst_b)
    multiply_ctr_0 <= 7'b0;
else 
    multiply_ctr_0 <= mode_flag ? Mem_multiCtr[Mem_multiCtr_addr_8_stage07[count_stage_1]] : 7'b0;
always @(posedge clk)
if(!rst_b)
    multiply_ctr_1 <= 7'b0;
else 
    multiply_ctr_1 <= mode_flag_stage0 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage16[count_stage0]] : 7'b0;

always @(posedge clk)
if(!rst_b)
    multiply_ctr_2 <= 7'b0;
else
    multiply_ctr_2 <= mode_flag_stage1 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage25[count_stage1]] : 7'b0;

always @(posedge clk)
if(!rst_b)
    multiply_ctr_3 <= 7'b0;
else
    multiply_ctr_3 <= mode_flag_stage2 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage34[count_stage2]] : 7'b0;

always @(posedge clk)
if(!rst_b)
    multiply_ctr_4 <= 7'b0;
else
    multiply_ctr_4 <= mode_flag_stage3 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage34[count_stage3]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage03[((count_stage3) > 3'b011) ? (count_stage3 - 4) : (count_stage3)]];


always @(posedge clk)
if(!rst_b)
    multiply_ctr_5 <= 7'b0;
else
    multiply_ctr_5 <= mode_flag_stage4 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage25[count_stage4]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage12[((count_stage4) > 3'b011) ? (count_stage4 - 4) : (count_stage4)]];

always @(posedge clk)
if(!rst_b)
    multiply_ctr_6 <= 7'b0;
else
    multiply_ctr_6 <= mode_flag_stage5 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage16[count_stage5]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage12[((count_stage5) > 3'b011) ? (count_stage5 - 4) : (count_stage5)]];

always @(posedge clk)
if(!rst_b)
    multiply_ctr_7 <= 7'b0;
else
    multiply_ctr_7 <= mode_flag_stage6 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage07[count_stage6]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage03[((count_stage6) > 3'b011) ? (count_stage6 - 4) : (count_stage6)]];

/*
assign multiply_ctr_0 = mode_flag_stage0 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage07[count_stage0]] : 7'b0;
assign multiply_ctr_1 = mode_flag_stage1 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage16[count_stage1]] : 7'b0;
assign multiply_ctr_2 = mode_flag_stage2 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage25[count_stage2]] : 7'b0;
assign multiply_ctr_3 = mode_flag_stage3 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage34[count_stage3]] : 7'b0;
assign multiply_ctr_4 = mode_flag_stage4 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage34[count_stage4]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage03[((count_stage4) > 3'b011) ? (count_stage4 - 4) : (count_stage4)]];
assign multiply_ctr_5 = mode_flag_stage5 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage25[count_stage5]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage12[((count_stage5) > 3'b011) ? (count_stage5 - 4) : (count_stage5)]];
assign multiply_ctr_6 = mode_flag_stage6 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage16[count_stage6]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage12[((count_stage6) > 3'b011) ? (count_stage6 - 4) : (count_stage6)]];
assign multiply_ctr_7 = mode_flag_stage7 ? Mem_multiCtr[Mem_multiCtr_addr_8_stage07[count_stage7]] : Mem_multiCtr[Mem_multiCtr_addr_4_stage03[((count_stage7) > 3'b011) ? (count_stage7 - 4) : (count_stage7)]];
*/
Multiply Multi_stage0(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage0),
                      .data_ctr(multiply_ctr_0),
                      .data_result(multi_res_stage0));

Multiply Multi_stage1(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage1),
                      .data_ctr(multiply_ctr_1),
                      .data_result(multi_res_stage1));

Multiply Multi_stage2(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage2),
                      .data_ctr(multiply_ctr_2),
                      .data_result(multi_res_stage2));

Multiply Multi_stage3(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage3),
                      .data_ctr(multiply_ctr_3),
                      .data_result(multi_res_stage3));

Multiply Multi_stage4(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage4),
                      .data_ctr(multiply_ctr_4),
                      .data_result(multi_res_stage4));

Multiply Multi_stage5(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage5),
                      .data_ctr(multiply_ctr_5),
                      .data_result(multi_res_stage5));

Multiply Multi_stage6(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage6),
                      .data_ctr(multiply_ctr_6),
                      .data_result(multi_res_stage6));

Multiply Multi_stage7(.clk(clk),
                      .rst_b(rst_b),
                      .data_multi(data_in_stage7),
                      .data_ctr(multiply_ctr_7),
                      .data_result(multi_res_stage7));

always @ (posedge clk)
if(!rst_b)
    data_out_0 <= 0;
else if(count_stage0 == 3)
    data_out_0 <= multi_res_stage0;
else
    data_out_0 <= data_out_0 + multi_res_stage0;

always @ (posedge clk)
if(!rst_b)
    data_out_1 <= 0;
else if(count_stage1 == 3)
    data_out_1 <= multi_res_stage1;
    
else if((count_stage1 > 5) | (count_stage1 < 3))
    data_out_1 <= data_out_1 - multi_res_stage1;
else 
    data_out_1 <= data_out_1 + multi_res_stage1;

always @ (posedge clk)
if(!rst_b)
    data_out_2 <= 0;         //Add_col
else if(count_stage2 == 3)
    data_out_2 <= multi_res_stage2;

else if(count_stage2 > 4)
    data_out_2 <= data_out_2 - multi_res_stage2;
else 
    data_out_2 <= data_out_2 + multi_res_stage2;

always @ (posedge clk)
if(!rst_b)
    data_out_3 <= 0;
else if(count_stage3 == 3)
    data_out_3 <= multi_res_stage3;

else if((count_stage3 == 5)|(count_stage3 == 6)|(count_stage3 == 1)|(count_stage3 == 2))
    data_out_3 <= data_out_3 - multi_res_stage3;

else 
    data_out_3 <= data_out_3 + multi_res_stage3;

always @ (posedge clk)
if(!rst_b)
    data_out_4 <= 0;
else if((mode_flag_stage7 & (count_stage4 == 3)) | ((!mode_flag_stage7) & ((count_stage4 == 3)|(count_stage4 == 7))))
    data_out_4 <= multi_res_stage4;

else if((mode_flag_stage7) & ((count_stage4 == 4)|(count_stage4 == 5)|(count_stage4 == 0)|(count_stage4 == 1)))
    data_out_4 <= data_out_4 - multi_res_stage4;

else 
    data_out_4 <= data_out_4 + multi_res_stage4;

always @ (posedge clk)
if(!rst_b)
    data_out_5 <= 0;
else if((mode_flag_stage8 & (count_stage5 == 3)) | ((!mode_flag_stage8) & ((count_stage5 == 3)|(count_stage5 == 7))))
    data_out_5 <= multi_res_stage5;
else if((mode_flag_stage8)&((count_stage5 == 4)|(count_stage5 == 5)|(count_stage5 == 7)|(count_stage5 == 0)|(count_stage5 == 2)) | ((!mode_flag_stage8)&((count_stage5 == 5)|(count_stage5 == 6)|(count_stage5 == 1)|(count_stage5 == 2))))
    data_out_5 <= data_out_5 - multi_res_stage5;
else
    data_out_5 <= data_out_5 + multi_res_stage5;

always @ (posedge clk)
if(!rst_b)
    data_out_6 <= 0;
else if((mode_flag_stage9 & (count_stage6 == 3)) | ((!mode_flag_stage9) & ((count_stage6 == 3)|(count_stage6 == 7))))
    data_out_6 <= multi_res_stage6;

else if((mode_flag_stage9) &((count_stage6 == 4)|(count_stage6 == 7)|(count_stage6 == 1)) | ((!mode_flag_stage9) & ((count_stage6 == 4) | (count_stage6 == 5)|(count_stage6 == 0) | (count_stage6 == 1))))
    data_out_6 <= data_out_6 - multi_res_stage6;
else
    data_out_6 <= data_out_6 + multi_res_stage6;

always @ (posedge clk)
if(!rst_b)
    data_out_7 <= 0;

else if((mode_flag_stage10 & (count_stage7 == 3)) | ((!mode_flag_stage10) & ((count_stage7 == 3)|(count_stage7 == 7))))
    data_out_7 <= multi_res_stage7;

else if(((mode_flag_stage10)&((count_stage7 == 4)|(count_stage7 == 6)|(count_stage7 == 0)|(count_stage7 == 2))) | ((!mode_flag_stage10)&((count_stage7 == 4) | (count_stage7 == 6)|(count_stage7 == 0) | (count_stage7 == 2))))
    data_out_7 <= data_out_7 - multi_res_stage7;
    
else 
    data_out_7 <= data_out_7 + multi_res_stage7;

assign data_out_Temp_0 = data_out_0 + 7'b1000000;
assign data_out_Temp_1 = data_out_1 + 7'b1000000;
assign data_out_Temp_2 = data_out_2 + 7'b1000000;
assign data_out_Temp_3 = data_out_3 + 7'b1000000;
assign data_out_Temp_4 = data_out_4 + 7'b1000000;
assign data_out_Temp_5 = data_out_5 + 7'b1000000;
assign data_out_Temp_6 = data_out_6 + 7'b1000000;
assign data_out_Temp_7 = data_out_7 + 7'b1000000;

always @ (posedge clk)
if(!rst_b)
begin
    data_out <= 16'b0;
    out_mode_flag <= 1'b0;
end

else if(mode_flag_stage6 & (count_stage0 == 3))
begin
    //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_0[22:7]));
    data_out <= data_out_Temp_0[22:7];
    out_mode_flag <= mode_flag_stage6;
end

else if(mode_flag_stage7 & (count_stage1 == 3))
begin
    //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_1[22:7]));
    data_out <= data_out_Temp_1[22:7];
    //out_mode_flag <= mode_flag_stage7;
end

else if(mode_flag_stage8 & (count_stage2 == 3))
begin
    //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_2[22:7]));
    data_out <= data_out_Temp_2[22:7];
    //out_mode_flag <= mode_flag_stage8;
end

else if(mode_flag_stage9 & (count_stage3 == 3))
begin
    //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_3[22:7]));
    data_out <= data_out_Temp_3[22:7];
    //out_mode_flag <= mode_flag_stage9;
end

else if((mode_flag_stage10 & (count_stage4 == 3)) | ((!mode_flag_stage10) & (count_stage4 == 7 | count_stage4 == 3)))
begin
   //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_4[22:7]));
   data_out <= data_out_Temp_4[22:7];
   out_mode_flag <= mode_flag_stage10;
end

else if((mode_flag_stage11 & (count_stage5 == 3)) | ((!mode_flag_stage11) & (count_stage5 == 7 | count_stage5 == 3)))
begin
   //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_5[22:7]));
   data_out <= data_out_Temp_5[22:7];
   //out_mode_flag <= mode_flag_stage8;
end

else if((mode_flag_stage12 & (count_stage6 == 3)) | ((!mode_flag_stage12) & (count_stage6 == 7 | count_stage6 == 3)))
begin
   //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_6[22:7]));
   data_out <= data_out_Temp_6[22:7];
   //out_mode_flag <= mode_flag_stage9;
end

else if((mode_flag_stage13 & (count_stage7 == 3)) | ((!mode_flag_stage13) & (count_stage7 == 7 | count_stage7 == 3)))
begin
   //$fdisplay(file1_myRowOutput,"%d",$signed(data_out_Temp_7[22:7]));
   data_out <= data_out_Temp_7[22:7];
   //out_mode_flag <= mode_flag_stage10;
end

else
begin
    data_out <= 8'b0;
    out_mode_flag <= 1'b1;
end

always @(posedge clk)
if(!rst_b)
    output_start <= 1'b0;
else if(count_stage7 == 4)
    output_start <= 1'b1;
else output_start <= output_start;

endmodule