//IDCTTop_tb.v
//Function IDCTTop Test Bench

`timescale 1ns/10ps
//`include "IDCTTop.v"

module IDCTTop_tb();

//OUTPUT
wire [7:0]data_out;
wire out_mode;
wire output_start;


//INPUT
reg clk;
reg rst_b;
reg rst_b_func;
reg [15:0]data_input;
reg mode_input;

//Temp
reg [55:0]data_file;
reg [3:0]temp0;             //For String
reg [3:0]temp1;
reg [3:0]temp2;
reg [3:0]temp3;
reg [3:0]temp4;
reg [7:0]temp_mode;

//File point
integer file_r;
integer file_w;
reg input_line;

//Initial
initial 
begin
  clk = 1;
  rst_b = 0;
  rst_b_func = 0;

  file_r = $fopen("../TestFile/file_input_new_1.txt","r");
  file_w = $fopen("../TestFile/file1_myOutput.txt","w");

  if(file_r == 0)
    begin
        $display("Failure to open INPUT File!");
        $stop;
    end
  if(file_w == 0)
    begin
        $display("Failure to open OUTPUT File!");
        $stop;
    end

  #2 rst_b_func = 1;
  #1 rst_b = 1;
  
end

always #1 clk = !clk;  //CLK

always @(posedge clk)
begin
if(!rst_b)
    begin
        temp_mode <= 7'b0;
        temp0 <= 0;
        temp1 <= 0;
        temp2 <= 0;
        temp3 <= 0;
        temp4 <= 0;
    end
else
    begin
		input_line = $fgets(data_file,file_r);
		temp_mode <= data_file[51:48];
		temp0 <= data_file[43:40];
		temp1 <= data_file[35:32];
		temp2 <= data_file[27:24];
		temp3 <= data_file[19:16];
		temp4 <= data_file[11:8];
    end
end

//Data in 
always @(temp_mode or temp0 or temp1 or temp2 or temp3 or temp4) 
begin
	if(temp_mode == 4'h0a) begin
		mode_input = 0;
		if(temp0 == 4'h0d) begin
			data_input = ~(temp1*10'd1000 + temp2*7'd100 + temp3*4'd10 + temp4) + 1; end
		else data_input = (temp1*10'd1000 + temp2*7'd100 + temp3*4'd10 + temp4); end
		else if(temp_mode == 4'h0b) begin
			mode_input = 1; 
			if(temp0 == 4'h0d) begin
				data_input = ~(temp1*10'd1000 + temp2*7'd100 + temp3*4'd10 + temp4) + 1; end
			else data_input = (temp1*10'd1000 + temp2*7'd100 + temp3*4'd10 + temp4); end
		else if(temp0 == 4'h0a) begin
			mode_input = 0; 
			if(temp1 == 4'h0d) begin
				data_input = ~(temp2*7'd100 + temp3*4'd10 + temp4) + 1; end
			else data_input = (temp1*10'd1000 + temp2*7'd100 + temp3*4'd10 + temp4); end
		else if(temp0 == 4'h0b) begin
			mode_input = 1; 
			if(temp1 == 4'h0d) begin
				data_input = ~(temp2*7'd100 + temp3*4'd10 + temp4) + 1; end
			else data_input = (temp1*10'd1000 + temp2*7'd100 + temp3*4'd10 + temp4); end
		else if(temp1 == 4'h0a) begin
			mode_input = 0; 
			if(temp2 == 4'h0d) begin
				data_input = ~(temp3*4'd10 + temp4) + 1; end
			else data_input = (temp2*7'd100 + temp3*4'd10 + temp4); end
		else if(temp1 == 4'h0b) begin
			mode_input = 1; 
			if(temp2 == 4'h0d) begin
				data_input = ~(temp3*4'd10 + temp4) + 1; end
			else data_input = (temp2*7'd100 + temp3*4'd10 + temp4); end
		else if(temp2 == 4'h0a) begin
			mode_input = 0; 
			if(temp3 == 4'h0d) begin
				data_input = ~(temp4) + 1; end
			else data_input = (temp3*4'd10 + temp4); end
		else if(temp2 == 4'h0b) begin
			mode_input = 1; 
			if(temp3 == 4'h0d) begin
				data_input = ~(temp4) + 1; end
			else data_input = (temp3*4'd10 + temp4); end
		else if(temp3 == 4'h0a) begin
			mode_input = 0; 
			data_input = temp4; end
		else if(temp3 == 4'h0b) begin	
			mode_input = 1;
			data_input = temp4; end
	end

always @(posedge clk)
if(output_start & (out_mode == 0))
    $fdisplay(file_w,"j %d",$signed(data_out));

else if(output_start & out_mode)
    $fdisplay(file_w,"k %d",$signed(data_out));

IDCTTop IDCTTop1(.clk(clk), 
                 .rst_b(rst_b),
                 .data_in(data_input),
                 .mode_flag(mode_input),
                 .data_out(data_out),
                 .out_mode_flag(out_mode),
                 .output_start(output_start));

endmodule