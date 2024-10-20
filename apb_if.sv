interface apb_if(input logic pclk, input logic presetn);
    logic            psel;
    logic            penable;
    logic            pwrite;
    logic    [11:0]  paddr;
    logic    [31:0]  pwdata;
    logic            pready;
    logic    [31:0]  prdata;
    logic    [1:0]   pslverr; 
endinterface
