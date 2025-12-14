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

    integer i;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        clk = 0;
        rst = 0;

        #1

        clk = 1;
        rst = 1;

        #1 
        clk = 0;
        rst = 0;

        #1 
        clk = 1;
        

        //проверка обновления
        #3;
        clk = 0;
        on = 3;
        x = 5;

        #1;
        clk = 1; //В y присваивается значение x.
        on = 0;

        #1
        clk = 0;
        
        #1
        clk = 1;// Из y вычитается значение s, и одновременно с этим s уменьшается на единицу

        #1
        clk = 0;

        #1 
        clk = 1; //Схема выключается.

        #1
        clk = 0;

        #1
        clk = 1;

        //обнова 2

        #3;
        clk = 0;
        on = 3;
        x = 33;

        #1;
        clk = 1; //В y присваивается значение x.
        on = 0;

        #1
        clk = 0;
        
        #1
        clk = 1;// Из y вычитается значение s, и одновременно с этим s уменьшается на единицу

        #1
        clk = 0;

        #1 
        clk = 1; //Схема выключается.

        #1
        clk = 0;

        #1
        clk = 1;


        /*.
        Поведение считающей схемы. В active выдаётся 0. Если читается значение start(t) = 0, то схема
        выключается, а иначе (при каждом чтении start(t) = 1):
        • Значение s уменьшается на 1 (здесь и дальше  с переполнением).
        • Если при уменьшении s происходит переполнение, то в тот же момент y увеличивается на 
        */
        //counting check start(0) = 1
        #5
        clk = 0;
        on = 2;
        start = 1;

        #1
        clk = 1;
        on = 0;

        for(i = 0; i < 10; ++i) begin
            #1
            clk = 0;

            #1
            clk = 1;
        end

        #1
        clk = 0;
        start = 0;

        #1
        clk = 1;

        #1
        clk = 0;

        #1
        clk = 1;

        //counting check start(0) = 0
        
        #3
        clk = 0;
        on = 2;
        start = 0;

        #1
        clk = 1;
        on = 0;

        #1
        clk = 0;

        #1
        clk = 1;

         #1
        clk = 0;

        #1
        clk = 1;

        
        //enum check start(0) = 0
        #5
        clk = 0;
        on = 1;
        start = 0;

        #1
        clk = 1;

        #1 
        clk = 0;
        on = 0;

        #1
        clk = 1;

        #1
        clk = 0;
        start = 1;

        #1
        clk = 1;

        for (i = 0; i < 10; ++i) begin
            #1
            clk = 0;

            #1
            clk = 1;
        end
        
        #1
        clk = 0;
        start = 0;

        #1
        clk = 1;

        #3
        clk = 0;

        #1
        clk = 1;


        #10
        clk = 0;
        rst = 1;

        #1
        clk = 1;
        rst = 0;


        //enum check start(0) = 1
         #3
        clk = 0;
        on = 1;
        start = 1;

        #1
        clk = 1;
        start = 0;

        for (i = 0; i < 10; ++i) begin
            #1
            clk = 0;

            #1
            clk = 1;
        end

        #1
        clk = 0;

        #1
        clk = 1;






        
    end

endmodule