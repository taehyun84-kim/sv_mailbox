`include "seq_collection.sv"
`include "apb_driver.sv"
`include "apb_if.sv"
`include "def.svh"

class tb_env;
    apb_sequence            apb_seq;
    apb_driver              apb_drv;
    mailbox #(apb_item)     apb_drv_mbox;
    event                   apb_write_done;

    virtual apb_if          apb_vif;

    function new();
        apb_seq = new();
        apb_drv = new();
        apb_drv_mbox = new();

        apb_seq.drv_mbox   = apb_drv_mbox;
        apb_seq.write_done = apb_write_done;

        apb_drv.mbox       = apb_drv_mbox;
        apb_drv.write_done = apb_write_done;
     endfunction

    virtual task run_test();
        apb_drv.vif = apb_vif;

        fork
            apb_seq.run();
            apb_drv.run();
        join_any
    endtask

endclass
