module receiver (
    input clk, rst, rx, rdy_clr, clk_en,
    output reg rdy,
    output reg [7:0] data_out
);

    parameter START = 2'b00;
    parameter DATA  = 2'b01;
    parameter STOP  = 2'b10;

    reg [1:0] state = START;
    reg [3:0] sample = 0;
    reg [3:0] index = 0;
    reg [7:0] temp_register = 8'b0;

    always @(posedge clk) begin

            if (rst) begin
                state <= START;
                sample <= 0;
                index <= 0;
                temp_register <= 0;
                rdy <= 0;
                data_out <= 0;
            end

            if (rdy_clr)
                rdy <= 0;

            if (clk_en) begin
                case (state)

                    // 🔹 WAIT FOR START BIT
                    START: begin
                         if (!rx) begin
                            sample <= sample + 1;
                            if (sample == 7) begin
                                if (!rx) begin
                                    state <= DATA;
                                    sample <= 0;
                                    index <= 0;
                                end else begin
                                    sample <= 0;
                                end
                            end
                         end else begin
                            sample <= 0;
                         end
                    end

                    // 🔹 RECEIVE DATA
                    DATA: begin
                        if (sample == 8) begin
                            temp_register[index] <= rx;
                        end

                        if (sample == 15) begin
                            sample <= 0;

                            if (index == 7) begin
                                state <= STOP;
                            end else begin
                                index <= index + 1;
                            end
                        end else begin
                            sample <= sample + 1;
                        end
                    end

                    // 🔹 STOP BIT
                    STOP: begin
                        if (sample == 15) begin
                            if (rx == 1'b1) begin
                                state <= START;
                                data_out <= temp_register;
                                rdy <= 1'b1;
                                sample <= 0;
                            end
                        end else begin
                            sample <= sample + 1'b1;
                        end
                    end

                endcase
            end
        end

endmodule