module apb_slave (
    input  logic            pclk,
    input  logic            presetn,
    input  logic            psel,
    input  logic            penable,
    input  logic            pwrite,
    input  logic    [11:0]  paddr,
    input  logic    [31:0]  pwdata,
    output logic            pready,
    output logic    [31:0]  prdata,
    output logic    [1:0]   pslverr
);

logic [31:0] mem [0:4095]; // 16KB
logic [11:0] paddr_d1;

always_ff @ (posedge pclk or negedge presetn) begin
    if (!presetn) begin
        paddr_d1 <= 12'd0;
    end else if (psel) begin
        paddr_d1 <= paddr[11:0];
    end
end

always_ff @ (posedge pclk) begin
    if (psel & penable & pwrite)
        mem[paddr_d1[11:0]] <= pwdata;
end

always_ff @ (posedge pclk or negedge presetn) begin
    if (!presetn) begin
        prdata <= 32'd0;
    end else if (psel & ~penable & ~pwrite) begin
        prdata <= mem[paddr[11:0]];
    end
end

assign pready = 1'b1;
assign pslverr = 2'd0;

endmodule
