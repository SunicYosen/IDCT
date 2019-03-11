//IDCTTop.v
//Function : IDCTTop
//
//`include "./IDCT_row.v"
//`include "./IDCT_col.v"
//`include "./MemChange.v"


module IDCTTop(input wire clk, 
               input wire rst_b,
               input wire [15:0]data_in,
               input wire mode_flag,
               output reg [7:0]data_out,
               output reg out_mode_flag,
               output reg output_start);

wire [15:0]row_data_out;
wire row_out_mode;
wire row_output_start;

wire [15:0]col_data_in;
wire [7:0]col_data_out;
wire col_out_mode;
wire col_output_start;

wire col_start;


IDCT_row rowIDCT(.clk(clk),              //row IDCT
                .rst_b(rst_b),
                .data_in(data_in),
                .mode_flag(mode_flag),
                .data_out(row_data_out),
                .out_mode_flag(row_out_mode),
                .output_start(row_output_start));



IDCT_col colIDCT(.clk(clk),              //col IDCT
                .rst_b(col_start),
                .data_in(col_data_in),
                .mode_flag(col_mode_flag),
                .data_out(col_data_out),
                .out_mode_flag(col_out_mode),
                .output_start(col_output_start));




MemChange MemChange_1(.clk(clk),
                      .rst_b(rst_b),
                      .start(row_output_start),
                      .data_in(row_data_out),
                      .mode_data_in(row_out_mode),
                      .data_out(col_data_in),
                      .mode_data_out(col_mode_flag),
                      .output_start_col(col_start));


/*
top_sram sramChange1(.rst_b(rst_b),
                     .mode_wr(,
                     .mode_rd(,
                     .sram_clk(clk),
                     .data_in(row_data_out),
                     .data_out_r(col_data_in));
*/

always @(posedge clk)
if(!rst_b)
    data_out <= 8'b0;
else 
    data_out <= col_data_out;

always @(posedge clk)
if(!rst_b)
    out_mode_flag <= 0;
else 
    out_mode_flag <= col_out_mode;

always @(posedge clk)
if(!rst_b)
    output_start <= 1'b0;
else
    output_start <= col_output_start;

endmodule