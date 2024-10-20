`include "def.svh"

class apb_driver;
    mailbox #(apb_item) mbox;
    virtual apb_if      vif;
    event               write_done;

    function new();
        mbox = new();
    endfunction

    task run();
       $display("@%0t [APB_DRIVER] write() starting ...", $time);
       forever begin
            apb_item write_item = new();
            mbox.get(write_item);
            @(posedge vif.pclk);
            $display("@%0t [APB_DRIVER] Received write item ...", $time);
            write_item.print();
            $display("@%0t [APB_DRIVER] Address state ...", $time);
            vif.psel    <= 1'b1;
            vif.penable <= 1'b0;
            vif.pwrite  <= 1'b1;
            vif.paddr   <= write_item.addr;
            @(posedge vif.pclk);
            $display("@%0t [APB_DRIVER] Enable state ...", $time);
            vif.penable <= 1'b1;
            vif.pwdata  <= write_item.data;
            wait(vif.pready);
            $display("@%0t [APB_DRIVER] Transaction is done ...", $time);
            @(posedge vif.pclk);
            vif.psel    <= 1'b0;
            vif.penable <= 1'b0;
            vif.pwrite  <= 1'b0;
            vif.paddr   <= '0;
            vif.pwdata  <= '0;
            -> write_done;
        end
    endtask
endclass
