module uart_tx (
    input clk,
    input rst,
    input baud_tick,
    input tx_start,
    input [7:0] data_in,
    output reg tx,
    output reg tx_done
);

    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg [1:0] state;

    parameter IDLE  = 2'b00,
              SHIFT = 2'b01,
              DONE  = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1;
            tx_done <= 0;
            bit_index <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    tx <= 1;
                    tx_done <= 0;
                    if (tx_start) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; 
                        bit_index <= 0;
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    if (baud_tick) begin
                        tx <= shift_reg[bit_index];
                        bit_index <= bit_index + 1;

                        if (bit_index == 9)
                            state <= DONE;
                    end
                end

                DONE: begin
                    tx_done <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule