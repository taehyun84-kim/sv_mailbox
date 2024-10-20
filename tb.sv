`include "tb_env.sv"

module tb;
    timeunit 1ns;
    timeprecision 1ps;

    logic pclk;

    always #10 pclk = ~pclk;
    initial begin
        pclk = 1'b0;
    end

    logic presetn;
    initial begin
        presetn = 1'b0;
        #11 presetn = 1'b1;
    end

    apb_if    apb_mif(pclk, presetn);

    apb_slave u_dut (
        .pclk     ( pclk ),
        .presetn  ( presetn ),
        .psel     ( apb_mif.psel ),
        .penable  ( apb_mif.penable ),
        .pwrite   ( apb_mif.pwrite ),
        .paddr    ( apb_mif.paddr ),
        .pwdata   ( apb_mif.pwdata ),
        .pready   ( apb_mif.pready ),
        .prdata   ( apb_mif.prdata ),
        .pslverr  ( apb_mif.pslverr )
    );

    tb_env  env;

    initial begin
        $display("@%0t [TB] Test is started ... ", $time);
        wait(presetn);
        $display("@%0t [TB] PRESETn is released ... ", $time);
        env = new();
        env.apb_vif = apb_mif;
        $display("@%0t [TB] Test sequence is started ... ", $time);
        env.run_test();
    end
endmodule
