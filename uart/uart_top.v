module uart_top (
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,
    output tx,
    output [7:0] data_out,
    output rx_done
);

    wire baud_tick;
    wire tx_wire;
    wire tx_done;

    uart_baud baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx_wire),
        .tx_done(tx_done)
    );

    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(tx_wire),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    assign tx = tx_wire;

endmodule