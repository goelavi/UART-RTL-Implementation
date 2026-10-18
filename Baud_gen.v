module BAUD_RATE_GEN (clk, tx_enb, rx_enb, rst);

    input clk;
    input rst;
    output reg tx_enb;
    output reg rx_enb;

    reg [15:0] tx_counter;
    reg [15:0] rx_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_counter <= 0;
            tx_enb <= 0;
            rx_enb <= 0;
        end
        else begin
            if (tx_counter == 10415) begin
                tx_enb <= 1;
                tx_counter <= 0;
            end
            else begin
                tx_counter <= tx_counter + 1'b1;
                tx_enb <= 0;
            end
        end
    end 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_counter <= 0;
        end
        else begin
            if (rx_counter == 650) begin
                rx_enb <= 1;
                rx_counter <= 0;
            end
            else begin
                rx_counter <= rx_counter + 1'b1;
                rx_enb <= 0;
            end
        end
    end

endmodule