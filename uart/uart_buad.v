module uart_baud (
    input clk,
    input rst,
    output reg baud_tick
);

    reg [13:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            baud_tick <= 0;
        end
        else begin
            if (counter == 14'd10415) begin   // 100MHz / 9600 = 10416
                counter <= 0;
                baud_tick <= 1;
            end
            else begin
                counter <= counter + 1;
                baud_tick <= 0;
            end
        end
    end

endmodule