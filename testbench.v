module testbench();

  reg [7:0] x = 0;
  reg [1:0] on = 0;
  reg start = 0;
  wire [7:0] y;
  wire [2:0] s;
  wire b;
  wire active;
  wire[1:0] regime;
  reg clk, rst;

  main my_module(.x(x), 
                .on(on),
                .start(start),
                .y(y),
                .s(s),
                .b(b),
                .regime(regime),
                .active(active),
                .clk(clk),
                .rst(rst));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        clk = 0;
        rst = 1;
    end

endmodule