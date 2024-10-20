`include "test.sv"

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

    test    test0;

    initial begin
        $display("@%0t [TB] Test is started ... ", $time);
        wait(presetn);
        $display("@%0t [TB] PRESETn is released ... ", $time);
        test0 = new();
        test0.vif = apb_mif;
        $display("@%0t [TB] Test sequence is started ... ", $time);
        test0.run_test();
        #100 $finish;
    end
endmodule
