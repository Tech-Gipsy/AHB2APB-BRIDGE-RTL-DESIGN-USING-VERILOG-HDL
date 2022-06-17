module ahbmaster(
                    HCLK,
                    HRESETn,
                    HWRITE,
                    HREADYin,
                    HADDR,
                    HWDATA,
                    HRDATA,
                    HRESP,
                    HREADYout,
                    HTRANS
                );
//parameter declaration
parameter NONSEQ=2'b10,   SEQ=2'b11,
	      IDLE=2'b00,	  WAIT=2'b01;

//input declaration
input HCLK,HRESETn;
input HREADYout;
input [1:0]HRESP;
input [31:0] HRDATA;

//output declaration
output reg HREADYin,HWRITE;
output reg [1:0]HTRANS;
output reg [31:0] HADDR,HWDATA;

//delay task
task delay();
begin
    #1;
end
endtask

//single read

task singleread();
begin
   @(posedge HCLK);
   #1;
    HADDR=32'h8000_0001;
    HWRITE=1'b0;
    HTRANS=NONSEQ;
    HREADYin=1'b1;
    @(posedge HCLK)
    #1
    begin
       // HWRITE=1'b1;
        HTRANS=IDLE;
    end
end
endtask


//single write

task singlewrite();
begin
    @(posedge HCLK)
    #1;
    begin
    HADDR=31'h8000_1100;
    HWRITE=1'b1;
    HTRANS=NONSEQ;
    HREADYin=1'b1;
    end
    @(posedge HCLK)
    #1
    begin
        HTRANS=IDLE;
        HWDATA=$random()%100;
    end
end
endtask

endmodule