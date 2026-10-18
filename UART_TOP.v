module uart_top (
    input rst, 
    input [7:0] data_in,
    input wr_enb,
    input clk,
    input rdy_clr,
    output rdy,
    output busy,
    output [7:0] data_out
);

    wire rx_clk_en; // Output of BRG rx_enb signal 
    wire tx_clk_en; // Output of BRG tx_enb signal
    wire tx_temp;   // Connecting O/P of TX module
    
    BAUD_RATE_GEN bg(.clk(clk), .tx_enb(tx_clk_en), .rx_enb(rx_clk_en), .rst(rst));

    transmitter tx(.clk(clk), .rst(rst), .wr_enb(wr_enb), .enb(tx_clk_en), .data_in(data_in), .tx(tx_temp), .busy(busy));

    receiver rx(.clk(clk), .rst(rst), .rx(tx_temp), .rdy_clr(rdy_clr), .clk_en(rx_clk_en), .rdy(rdy), .data_out(data_out));


endmodule