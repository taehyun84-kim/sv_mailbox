`include "def.svh"

class apb_sequence;
    mailbox #(apb_item) drv_mbox;
    event               write_done;
    int                 num = 50;

    function new();
        num      = 50;
        drv_mbox = new();
    endfunction
    
    virtual task run();
        for (int i = 1; i <= num; i++) begin
            apb_item bus_item = new(); 
            if (bus_item.randomize() == 0) begin
                $display("@%0t [APB_SEQ] Randomization has an error", $time);
                $finish;
            end
            $display("@%0t [APB_SEQ] Loop : %0d / %0d created", $time, i, num);
            drv_mbox.put(bus_item);
            @(write_done);
            $display("@%0t [APB_SEQ] Loop : %0d / %0d written", $time, i, num);
        end
        $display("@%0t [APB_SEQ] sequence is done ...", $time);
        $finish;
    endtask

endclass
