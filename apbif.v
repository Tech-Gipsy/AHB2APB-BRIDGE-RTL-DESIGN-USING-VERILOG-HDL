module apbif(
                PENABLEin,
                PWRITEin,
                PSELin,
                PADDRin,
                PWDATAin,
                PENABLE,
                PWRITE,
                PSEL,
                PADDR,
                PWDATA,
                PRDATA
            );

//input declaration

input PENABLEin,PWRITEin;
input[2:0] PSELin;
input [31:0] PADDRin,PWDATAin;

output  PENABLE,PWRITE;
output [2:0] PSEL;
output [31:0] PADDR,PWDATA;

output reg[31:0] PRDATA;

//port assigment
assign PENABLE=PENABLEin;
assign PWDATA=PWDATAin;
assign PWRITE=PWRITEin;
assign PSEL=PSELin;
assign PADDR=PADDRin;

//prdata generation

always@(*)
begin
if(PWRITEin==0)
    if(PENABLEin)
        PRDATA=$random();
else
    PRDATA=32'b0;

end
endmodule
