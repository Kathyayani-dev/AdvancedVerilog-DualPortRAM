# code for dual_port_ram.v
  ...
     module dual_port_ram #(parameter WIDTH=8,DEPTH=16,ADDR=5)
                      (input clock,resetn,
                       input [WIDTH-1:0]data_in,
                       input we_enb,re_enb,
                       input [ADDR-1:0]rd_addr,wr_addr,
                       output reg [WIDTH-1:0]data_out);

   //Internal memory declaration
   reg [WIDTH-1:0]ram[DEPTH-1:0] ;

   //Memory read & write operation
   always@(posedge clock)
      begin
         if(~resetn)
            data_out <= 1;
         else if(we_enb)
            ram[wr_addr[3:0]] <= data_in;
         else if(re_enb)
            data_out <= ram[rd_addr[3:0]];
      end

endmodule
...
