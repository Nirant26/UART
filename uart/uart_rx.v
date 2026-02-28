module uart_rx (
    input clk,
    input rst,
    input baud_tick,
    input rx,
    output reg [7:0] data_out,
    output reg rx_done
);

    reg [3:0] bit_index;
    reg [7:0] rx_shift;
    reg [1:0] state;

    parameter IDLE  = 2'b00,
              SHIFT = 2'b01,
              DONE  = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_index <= 0;
            rx_done <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    rx_done <= 0;
                    if (rx == 0) begin
                        bit_index <= 0;
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    if (baud_tick) begin
                        rx_shift[bit_index] <= rx;
                        bit_index <= bit_index + 1;

                        if (bit_index == 7)
                            state <= DONE;
                    end
                end

                DONE: begin
                    data_out <= rx_shift;
                    rx_done <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule