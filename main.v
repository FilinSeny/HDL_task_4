// ВНИМАНИЕ!
// Можно изменять ТОЛЬКО части кода, помеченные "(*)",
//   и ТОЛЬКО так, как написано у "(*)".
module main(x, on, start, y, s, b, regime, active, clk, rst);
  // // (*) По необходимости можно добавть "reg" в объявлениях выходных точек, задающихся в управляющем автомате.
  input [7:0] x;
  input [1:0] on;
  input start;
  output [7:0] y;
  output [2:0] s;
  output b;
  output reg active;
  output reg[1:0] regime;
  input clk, rst;
  
  // (*) По необходимости можно заменить wire на reg для любых точек далее.
  wire [1:0] y_select_next, s_step;
  wire y_en, s_en, y_upd, s_sub, s_zero;
  
  // Основная часть операционного автомата.
  datapath _datapath(
    .x(x),
    .y(y),
    .s(s),
    .b(b),
    .s_en(s_en),
    .s_step(s_step),
    .s_sub(s_sub),
    .s_zero(s_zero),
    .y_en(y_en),
    .y_select_next(y_select_next),
    .y_upd(y_upd),
    .clk(clk),
    .rst(rst)
  );

  
  
  // Распознавание свойств данных в операционном автомате.
  // (*) Здесь следует по необходимости объявить новые управляющие точки
  //   и реализовать задающие их подсхемы
  //   (преобразующие данные в управление).
  
   typedef enum reg [3:0] {
        OFF_STATE =     0,
        UPD_0 =         1,
        UPD_1 =         2,
        UPD_2 =         3,
        COUNT_0 =       4,
        COUNT_1 =       5,
        COUNT_2 =       6,
        ENUM_INACTIVE = 7,
        ENUM_ACTIVE_6 = 8,
        ENUM_ACTIVE_2 = 9,
        ENUM_ACTIVE_0 = 10
    } state_t;

    state_t state, next_state;
    reg [2:0] timer;

    

  // Управляющий автомат.
  // (*) Здесь следует написать схему, основная часть которой - это
  //   типовая реализация управляющего символьного автомата,
  //   заставляющая схему main выполняться согласно условию.

  always @(posedge clk or posedge rst) begin
        if (!rst_n)
            state <= OFF_STATE;
        else
          if (timer == 0) 
            state <= next_state;
        	else 
            timer <= timer - 1;
    end

    always @(on) begin
        if (state == OFF_STATE) begin
          case (on)
            2'd1: begin
              state <= ENUM_ACTIVE_0;

            end
            2'd2: begin
              state <= COUNT_0;
            end

            2'd3: begin
              state <= UPD_0;
            end
          endcase
        end
    end

    always @* begin
      next_state = state;
      case(state)
        UPD_0: 
          next_state = UPD_1;

        UPD_1:
          next_state = UPD_2;

        UPD_2:
          next_state = OFF_STATE;

        COUNT_0, COUNT_1: begin
          if (start) begin
            if (s == 0) 
              next_state = COUNT_2;
            else
              next_state = COUNT_1;
          end
          else 
            next_state = OFF_STATE;
        end

        COUNT_2:
          if (start)
            next_state = COUNT_1;
          else
            next_state = OFF_STATE;

        ENUM_INACTIVE:
          if (start)
            next_state = ENUM_INACTIVE;
          else 
            next_state = ENUM_ACTIVE_6;

        ENUM_ACTIVE_6: begin
          next_state = ENUM_ACTIVE_2;
          timer = 1;
        end

        ENUM_ACTIVE_2: begin
          next_state = ENUM_ACTIVE_0;
          timer = 2;
        end

        ENUM_ACTIVE_0:
          next_state = OFF_STATE;
      endcase
    end
    

    always @* begin
      case(state)
        OFF_STATE: begin
          active <= 0;
          regime <= 0;
        end

        UPD_0: begin
          active <=       0;
          regime <=       3;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         1;
          s_zero <=       0;
          s_sub <=        0;
          s_step <=       0;
          s_en <=         0;

        end

        UPD_1: begin
          active <=       0;
          regime <=       3;
          y_upd <=        1;
          y_select_next <= 1;
          y_en <=         1;
          s_zero <=       0;
          s_sub <=        1;
          s_step <=       1;
          s_en <=         1;
        end

        UPD_2: begin
          active <=       0;
          regime <=       3;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       0;
          s_sub <=        0;
          s_step <=       0;
          s_en <=         0;
        end

        COUNT_0: begin
          active <=       0;
          regime <=       2;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       0;
          s_sub <=        1;
          s_step <=       1;
          s_en <=         1;
        end

        COUNT_1: begin
          active <=       0;
          regime <=       2;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       0;
          s_sub <=        1;
          s_step <=       1;
          s_en <=         1;
        end

        COUNT_2: begin
          active <=       0;
          regime <=       2;
          y_upd <=        0;
          y_select_next <= 2;
          y_en <=         1;
          s_zero <=       0;
          s_sub <=        1;
          s_step <=       1;
          s_en <=         1; 
        end

        ENUM_INACTIVE: begin
          active <=       0;
          regime <=       1;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       1;
          s_sub <=        1;
          s_step <=       2;
          s_en <=         0;
        end

        ENUM_ACTIVE_6: begin
          active <=       1;
          regime <=       1;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       1;
          s_sub <=        1;
          s_step <=       2;
          s_en <=         1;
        end

        ENUM_ACTIVE_2: begin
          active <=       1;
          regime <=       1;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       0;
          s_sub <=        1;
          s_step <=       2;
          s_en <=         1;
        end

        ENUM_ACTIVE_0: begin
          active <=       1;
          regime <=       1;
          y_upd <=        0;
          y_select_next <= 0;
          y_en <=         0;
          s_zero <=       1;
          s_sub <=        1;
          s_step <=       2;
          s_en <=         1;
        end
        


      endcase 
    end
endmodule
