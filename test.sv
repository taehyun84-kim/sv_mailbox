`include "def.svh"
`include "apb_driver.sv"

class test;
    apb_driver          apb_drv;
    mailbox #(apb_item) drv_mbox;
    event               write_done;
    virtual apb_if      vif;

    function new();
        apb_drv  = new();
        drv_mbox = new();

        apb_drv.mbox       = drv_mbox;
        apb_drv.write_done = write_done;
    endfunction

    virtual task run_test();
    begin
        apb_drv.vif = vif;
        fork
        apb_drv.run();
        bus_task();
        join_any
   end
   endtask

    virtual task bus_task();
        apb_item bus_item = new();
        bus_item.addr = 12'h123;
        bus_item.data = 32'h4567_89AB;
        #1 drv_mbox.put(bus_item);
     endtask
endclass
