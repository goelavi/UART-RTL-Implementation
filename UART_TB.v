`timescale 1ns/1ps

module uart_top_tb;
    
    reg clk,rst;
    reg [7:0] data_in;
    reg wr_enb;

    wire tx;
    wire rdy;

    reg rdy_clr;
    wire [7:0] dout;

    wire busy;

    uart_top dut(rst, data_in, wr_enb, clk, rdy_clr, rdy, busy, dout);

    initial begin
        {clk,rst,data_in,rdy_clr} = 0;
    end

    always #5 clk = ~clk;

    task send_byte(input [7:0] din);

    begin
        @(negedge clk);
        data_in = din;
        wr_enb = 1'b1;
        @(negedge clk);
        wr_enb = 0;
    end
    endtask

    task clear_ready;
    begin
        @(negedge clk)
            rdy_clr = 1'b1;
            @(negedge clk)
                rdy_clr = 1'b0;
    end
    endtask

    initial begin 

        @(negedge clk)
            rst = 1'b1;

        @(negedge clk)
            rst = 1'b0;

        send_byte(8'h41);
        wait(!busy);
        wait(rdy);
        $display("received data is %h",dout);
        clear_ready;

        send_byte(8'h55);
        wait(!busy);
        wait(rdy);
        $display("received data is %h",dout);
        clear_ready;

        #400 $finish;
    end

    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_top_tb);  // or your top testbench module name
    end

endmodule