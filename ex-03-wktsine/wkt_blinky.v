module wkt_blinky(input i_clk, output [7:0] o_led);

    parameter       WIDTH = 28;
    reg [WIDTH:0] ctr = 0;
    wire [15:0] slow_ctr;
    assign slow_ctr= ctr[WIDTH-5:WIDTH-20];

    // Outputs
    reg [7:0] led_reg = 8'b00010000;
    assign o_led = led_reg;

    always@(posedge i_clk) begin
      ctr <= ctr + 1'b1;
      case(slow_ctr)
        0:     led_reg <= 8'b00010000;
        2856:  led_reg <= 8'b00100000;
        5960:  led_reg <= 8'b01000000;
        9868:  led_reg <= 8'b10000000;
        22918: led_reg <= 8'b01000000;
        26826: led_reg <= 8'b00100000;
        29929: led_reg <= 8'b00010000;
        32785: led_reg <= 8'b00001000;
        35641: led_reg <= 8'b00000100;
        38745: led_reg <= 8'b00000010;
        42652: led_reg <= 8'b00000001;
        55702: led_reg <= 8'b00000010;
        59610: led_reg <= 8'b00000100;
        62714: led_reg <= 8'b00001000;
	default: begin
	end
      endcase
    end

endmodule
