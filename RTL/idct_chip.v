//idct_chip.v
//Function	: Define PAD for Top Module
//
module idct_chip(clk,
                 rstn,
                 mode,
                 din,
                 dout,
                 dout_mode,
                 dout_start);
input clk;
input rstn;
input mode;
input [15:0]din;

output [7:0]dout;
output dout_mode;
output dout_start;

wire net_clk;
wire net_rstn;
wire net_mode;
wire net_dout_mode;
wire [15:0]net_din;
wire [7:0]net_dout;
wire net_dout_start;

PIW PIW_clk(.PAD(clk),.C(net_clk));			//INPUT
PIW PIW_rstn(.PAD(rstn),.C(net_rstn));
PIW PIW_mode(.PAD(mode),.C(net_mode));
PIW PIW_din0(.PAD(din[0]),.C(net_din[0]));
PIW PIW_din1(.PAD(din[1]),.C(net_din[1]));
PIW PIW_din2(.PAD(din[2]),.C(net_din[2]));
PIW PIW_din3(.PAD(din[3]),.C(net_din[3]));
PIW PIW_din4(.PAD(din[4]),.C(net_din[4]));
PIW PIW_din5(.PAD(din[5]),.C(net_din[5]));
PIW PIW_din6(.PAD(din[6]),.C(net_din[6]));
PIW PIW_din7(.PAD(din[7]),.C(net_din[7]));
PIW PIW_din8(.PAD(din[8]),.C(net_din[8]));
PIW PIW_din9(.PAD(din[9]),.C(net_din[9]));
PIW PIW_din10(.PAD(din[10]),.C(net_din[10]));
PIW PIW_din11(.PAD(din[11]),.C(net_din[11]));
PIW PIW_din12(.PAD(din[12]),.C(net_din[12]));
PIW PIW_din13(.PAD(din[13]),.C(net_din[13]));
PIW PIW_din14(.PAD(din[14]),.C(net_din[14]));
PIW PIW_din15(.PAD(din[15]),.C(net_din[15]));

PO8W PO8W_dout0(.I(net_dout[0]),.PAD(dout[0]));   //Output
PO8W PO8W_dout1(.I(net_dout[1]),.PAD(dout[1]));
PO8W PO8W_dout2(.I(net_dout[2]),.PAD(dout[2]));
PO8W PO8W_dout3(.I(net_dout[3]),.PAD(dout[3]));
PO8W PO8W_dout4(.I(net_dout[4]),.PAD(dout[4]));
PO8W PO8W_dout5(.I(net_dout[5]),.PAD(dout[5]));
PO8W PO8W_dout6(.I(net_dout[6]),.PAD(dout[6]));
PO8W PO8W_dout7(.I(net_dout[7]),.PAD(dout[7]));
PO8W PO8W_dout_start(.I(net_dout_start),.PAD(dout_start));
PO8W PO8W_dout_mode(.I(net_dout_mode),.PAD(dout_mode));

IDCTTop  IDCTTop1(.clk(net_clk),				//Top Module
                  .rst_b(net_rstn),
                  .mode_flag(net_mode),
                  .data_in(net_din),
                  .data_out(net_dout),
                  .out_mode_flag(net_dout_mode),
                  .output_start(net_dout_start));   
                  
endmodule

