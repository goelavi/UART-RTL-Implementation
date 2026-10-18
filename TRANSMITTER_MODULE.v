module transmitter (
    input clk,
    input rst,
    input wr_enb,
    input enb,          // baud rate tick
    input [7:0] data_in,
    output reg tx,
    output busy
);

    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    reg [7:0] data = 8'h00;
    reg [2:0] index = 3'h0;
    reg [1:0] state = IDLE;

    always @(posedge clk) begin
    if (rst) begin
        tx    <= 1'b1;
        state <= IDLE;
        index <= 3'd0;
        data  <= 8'd0;
    end else begin
        case (state)

            IDLE: begin
                tx <= 1'b1;
                if (wr_enb) begin
                    data  <= data_in;
                    index <= 3'd0;
                    state <= START;
                end
            end

            START: begin
                tx <= 1'b0;
                if (enb)
                    state <= DATA;
            end

            DATA: begin
                tx <= data[index];
                if (enb) begin
                    if (index == 3'd7)
                        state <= STOP;
                    else
                        index <= index + 1;
                end
            end

            STOP: begin
                tx <= 1'b1;
                if (enb)
                    state <= IDLE;
            end

        endcase
    end
end

    assign busy = (state != IDLE);

endmodule