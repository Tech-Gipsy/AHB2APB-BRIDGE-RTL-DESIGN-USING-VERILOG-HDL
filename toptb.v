module toptb();
reg HCLK;
reg HRESETn=0;
wire [31:0]pwdata,prdata,paddr;
wire [2:0] psel;
wire pwrite,penable;
wire [31:0]pwdatao,prdatao,paddro;
wire [2:0] pselo;
wire pwriteo,penableo;
wire [1:0]Hresp;
wire hwrite;

parameter cycle=10;
ahbmaster MASTER(
                    .HCLK(HCLK),
                    .HRESETn(HRESETn),
                    .HWRITE(hwrite),
                    .HREADYin(BRIDGETOP.HREADYin),
                    .HADDR(BRIDGETOP.HADDR),
                    .HWDATA(BRIDGETOP.HWDATA),
                    .HRDATA(BRIDGETOP.HRDATA),
                    .HRESP(Hresp),
                    .HREADYout(BRIDGETOP.HREADYout),
                    .HTRANS(BRIDGETOP.HTRANS)
);

bridgetop BRIDGETOP(    .HCLK(HCLK),
                        .HRESETn(HRESETn),
                        .HADDR(MASTER.HADDR),
                        .HWDATA(MASTER.HWDATA),
                        .HWRITE(MASTER.HWRITE),
                        .HTRANS(MASTER.HTRANS),
                        .HREADYin(MASTER.HREADYin),
                        .HREADYout(MASTER.HREADYout),
                        .HRDATA(MASTER.HRDATA),
                        .HRESP(Hresp),
                        .PENABLE(penable),
                        .PWRITE(pwrite),
                        .PSEL(psel),
                        .PWDATA(pwdata),
                        .PRDATA(prdatao),
                        .PADDR(paddr)
                );

apbif APBINTERFACE(
                        .PENABLEin(penable),
                        .PWRITEin(pwrite),
                        .PSELin(psel),
                        .PADDRin(paddr),
                        .PWDATAin(pwdata),
                        .PENABLE(penableo),
                        .PWRITE(pwriteo),
                        .PSEL(pselo),
                        .PADDR(paddro),
                        .PWDATA(pwdatao),
                        .PRDATA(prdatao)
            );

//testing
//clock generation
always
begin
    #5;
    HCLK=1'b1;
    #5;
    HCLK=~HCLK;
end

//reset task
task rst();
begin
    HRESETn=1'b0;
    #5;
    HRESETn=1'b1;
end
endtask

initial
begin
    #20;
    rst();
    MASTER.singleread();
#100 $finish();
end
endmodule
