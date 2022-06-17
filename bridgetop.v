module bridgetop(   HCLK,
                    HRESETn,
                    HADDR,
                    HWDATA,
                    HWRITE,
                    HTRANS,
                    HREADYin,
                    HREADYout,
                    HRDATA,
                    HRESP,
                    PENABLE,
                    PWRITE,
                    PSEL,
                    PWDATA,
                    PRDATA,
                    PADDR
                );


input HCLK,HRESETn;
input HWRITE,HREADYin;
input [1:0] HTRANS;
input [31:0] HADDR,HWDATA,PRDATA;

output PWRITE,PENABLE,HREADYout;
output [2:0]PSEL;
output  [1:0]HRESP;
output [31:0] PADDR,PWDATA,HRDATA;

wire [31:0] addr1,addr2,data1,data2;
wire writereg,vld;
wire [2:0] sel;

ahbslave AHBSLAVE(
                    .HCLK(HCLK),
                    .HRESETn(HRESETn),
                    .HADDR(HADDR),
                    .HADDR_1(addr1),
                    .HADDR_2(addr2),
                    .HWDATA(HWDATA),
                    .HWDATA_1(data1),
                    .HWDATA_2(data2),
                    .HWRITE(HWRITE),
                    .HWRITEreg(writereg),
                    .HRESP(HRESP),
                    .HRDATA(HRDATA),
                    .PRDATA(PRDATA),
                    .TEMP_SEL(sel),
                    .valid(vld),
                    .HTRANS(HTRANS),
                    .HREADYin(HREADYin)  
                );
fsm FSM(
            .HCLK(HCLK),
            .HRESETn(HRESETn),
            .HADDR_1(addr1),
            .HADDR_2(addr2),
            .HWDATA_1(data1),
            .HWDATA_2(data2),
            .HWRITE(HWRITE),
            .HWRITEreg(writereg),
            .HTRANS(HTRANS),
            .valid(vld),
            .TEMP_SEL(sel),
            .PADDR(PADDR),
            .PSEL(PSEL),
            .PWRITE(PWRITE),
            .PENABLE(PENABLE),
            .PWDATA(PWDATA),
            .HREADYout(HREADYout)
          );

endmodule