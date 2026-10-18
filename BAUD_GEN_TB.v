`timescale 1ns/1ps

module BAUD_GEN_TB; 
    reg clk;
    reg rst;
    wire tx_enb;
    wire rx_enb;

    BAUD_RATE_GEN dut(
        .clk(clk),
        .rst(rst),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #20
        rst = 0;

        #2000000;

        $finish;
    end

    initial begin
        $monitor("Time: %0t | tx_enb=%b | rx_enb=%b", $time, tx_enb, rx_enb);
    end

    initial begin
        $dumpfile("BRG.vcd");
        $dumpvars(0, BAUD_GEN_TB);
    end

endmodule