module ahbslave(
    HCLK,
    HRESETn,
    HADDR,
    HADDR_1,
    HADDR_2,
    HWDATA,
    HWDATA_1,
    HWDATA_2,
    HWRITE,
    HWRITEreg,
    HRESP,
    HRDATA,
    PRDATA,
    TEMP_SEL,
    valid,
    HTRANS,
    HREADYin
    
);
//slave memory map
parameter slave0_0=32'h8000_0000,slave0_1=32'h8400_0000;
parameter slave1_0=32'h8400_0001,slave1_1=32'h8800_0000;
parameter slave2_0=32'h8800_0001,slave2_1=32'h8c00_0000;
parameter   IDLE=2'b00,WAIT=2'b01,
	        NONSEQ=2'b10,SEQ=2'b11;

//Input declaration
input HCLK,HRESETn;
input HREADYin,HWRITE;
input [1:0] HTRANS;

input [31:0] HADDR,HWDATA,PRDATA;

//Output declaration
//reg internal register
output reg HWRITEreg,valid;
output reg [1:0]HRESP;
output reg [2:0] TEMP_SEL;
output reg [31:0] HADDR_1,HADDR_2,HWDATA_1,HWDATA_2;
output [31:0]HRDATA;
//assigning prdata = hr data

assign HRDATA=PRDATA;

//pipelining

always@(posedge HCLK,negedge HRESETn)
begin
    HRESP=0;
    if(~HRESETn)
    begin
        HADDR_1<=0;
        HADDR_2<=0;
        HWDATA_1<=0;
        HWDATA_2<=0;
    end
    else
    begin
        HADDR_1<=HADDR;
        HADDR_2<=HADDR_1;
        HWDATA_1<=HWDATA;
        HWDATA_2<=HWDATA_1;
    end
end

//hwritereg transfer

always@(*)
begin
    
     if((HADDR>=slave0_0 && HADDR<= slave2_1) && (HTRANS!=IDLE && HTRANS!=WAIT) && (HREADYin==1'b1))
        valid = 1'b1;
    else
        valid=1'bx;
    
end


// tempsel output generation
always@(*)
begin
	if(slave0_1>=HADDR>=slave0_0) 
			TEMP_SEL=3'b001;
	else if(slave1_1>=HADDR>=slave1_0) 
			TEMP_SEL=3'b010;
	else if(slave2_1>=HADDR>=slave2_0) 
		TEMP_SEL=3'b100;
	else
		TEMP_SEL=3'b100;

end
// hwritereg transfer

always@(posedge HCLK,negedge HRESETn)
begin
	if(~HRESETn)
		HWRITEreg <= 0;
	else
		HWRITEreg<= HWRITE;
end


endmodule
