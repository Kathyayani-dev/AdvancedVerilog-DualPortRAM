# code for dual_port_tb.v
  ...
     module dual_port_tb();
        reg clock,resetn;
   reg [7:0]data_in;
        reg we_enb,re_enb;
        reg [4:0]rd_addr,wr_addr;
        wire [7:0]data_out;
        reg [7:0]ref_ram[15:0];

        parameter THOLD=2,
                TSETUP=2,
                CYCLE=20;

        dual_port_ram DUT(clock,resetn,data_in,we_enb,re_enb,rd_addr,wr_addr,data_out);

        initial
        begin
                clock=1;
                rd_addr=0;
                wr_addr=0;
                while(1)
                #(CYCLE/2) clock=~clock;
        end

        task reset;
                begin
                        resetn=0;
                        repeat(3)
                        @(posedge clock);
                        #(THOLD);
                        if(data_out !== 1)
                        begin
                                $display($time,"\t RESET IS A FAILURE");
                                $stop;
                        end
                        $display($time,"\tRESET IS A SUCCESS");
                        resetn=1'bx;
                        #(CYCLE-THOLD-TSETUP);
                end
        endtask

        task write_t(input w,input [3:0]wa,input [7:0]i);
                begin
                        resetn=1'b1;
                        we_enb=w;
                        data_in=i;
                        wr_addr=wa;
                        @(posedge clock);
                        #(THOLD);
                        resetn=1'bx;
                        we_enb=1'bx;
                        data_in=1'bx;
                        wr_addr=1'bx;
                        #(CYCLE-THOLD-TSETUP);
                end
        endtask

        task read_t(input r,input [3:0]ra);
                begin
                        re_enb=r;
                        rd_addr=ra;
                        @(posedge clock);
                        #(THOLD);
                        if(data_out !== ref_ram[rd_addr[3:0]])
                        begin
                                $display($time,"\t DATA MISMATCH");
                                $stop;
                                $display($time,"\t READ IS A SUCCESS");
                                re_enb=1'bx;
                                rd_addr=1'bx;
                                #(CYCLE-THOLD-TSETUP);
                        end
                end
                endtask

                always@(posedge clock)
                begin
                        if(we_enb)
                        ref_ram[wr_addr[3:0]]<=data_in;
                end

                initial
                begin
                        reset;
                        repeat(40)
                                begin
                                        write_t(1,$random%16,$random%16);
                                end
                        write_t(0,$random%16,$random%16);
                        repeat(16)
                                begin
                                        read_t(1,$random%16);
                                end
                        read_t(0,$random%16);
                end
endmodule
...
