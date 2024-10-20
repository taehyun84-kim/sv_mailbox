`ifndef __TB_DEV_SVH__
`define __TB_DEV_SVH__
class apb_item;
    rand bit [11:0] addr;
    rand bit [31:0] data;

    function void print(string tag = "");
        $display("@%0t ADDR 0x%0h, DATA 0x%0h", $time, tag, addr, data);
    endfunction
endclass
`endif