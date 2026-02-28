module uart_tx_tb;
    reg clk;
    reg tx_enb;
    reg [7:0] data;
    wire tx;
    uart_tx uut (
        .clk(clk),
        .tx_enb(tx_enb),
        .data(data),
        .tx(tx)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        tx_enb = 0;
        data = 8'b10101010;
        tx_enb = 1;
        #10;
        tx_enb = 0;
        $stop;
    end
endmodule