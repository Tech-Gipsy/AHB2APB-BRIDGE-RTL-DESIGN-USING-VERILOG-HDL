module fsm(
            HCLK,
            HRESETn,
            HADDR_1,
            HADDR_2,
            HWDATA_1,
            HWDATA_2,
            HWRITE,
            HWRITEreg,
            HTRANS,
            valid,
            TEMP_SEL,
            PADDR,
            PSEL,
            PWRITE,
            PENABLE,
            PWDATA,
            HREADYout
          );

//parameter declaration

parameter	ST_IDLE=3'b000,            ST_WWAIT=3'b001,
            ST_READ=3'b010,            ST_WRITE=3'b011,
            ST_WRITEP=3'b100,          ST_RENABLE=3'b101,
            ST_WENABLE=3'b110,         ST_WENABLEP=3'b111;

//input declaration
input HCLK,HRESETn;
input valid,HWRITE,HWRITEreg;
input [1:0] HTRANS;
input [2:0] TEMP_SEL;
input [31:0] HADDR_1,HADDR_2,HWDATA_1,HWDATA_2;


//output declaration

output reg PWRITE,PENABLE,HREADYout;
output reg [31:0] PADDR,PWDATA;
output reg [2:0] PSEL;

//TEMP variables
reg [2:0] state,nstate;
reg [31:0] tmpaddr;
//reset state
always@(posedge HCLK,negedge HRESETn)
begin 
    if(~HRESETn)
    begin
        state <= ST_IDLE;
    end
    else
    begin
        state<=nstate;
    end
end

// state transistion conditions

always@(*)
 begin

      nstate=ST_IDLE;
	PSEL = 0;
	PENABLE = 0;
	HREADYout = 0;
        PWRITE = 0;
	case(state)

         ST_IDLE:begin
	      //    PSEL=0;
		//  PENABLE=0;
		  HREADYout=1'b1;

		  if(~valid)
		    nstate=ST_IDLE;
		  else if(valid && HWRITE)
		    nstate=ST_WWAIT;
		  else 
		    nstate=ST_READ;
		end

	 ST_WWAIT:begin
		  
		  HREADYout=1'b1;
	//	  PSEL=0;
		//  PENABLE=0;
                 

		  if(~valid)
		    nstate=ST_WRITE;
		  else if(valid)
		    nstate=ST_WRITEP;
		end


	ST_READ: begin
		 PSEL=TEMP_SEL;
		// PENABLE=1'b0;
		 PADDR=HADDR_1;
		// PWRITE=1'b1;
		HREADYout=1'b0;
		 
		 nstate=ST_RENABLE;
		end


	ST_WRITE:begin
		 PSEL=TEMP_SEL;
		 PADDR=HADDR_1;
		 PWRITE=1'b1;
		 PWDATA=HWDATA_1;
		 PENABLE=1'b0;
		  if(~valid)
		      nstate=ST_WENABLE;
		  else if(valid)
		      nstate=ST_WENABLEP;
		 end


	ST_WRITEP: begin
		//	if()
		//	   PADDR=HADDR_2;
		//
			PADDR=HADDR_1;
			
		
			PSEL=TEMP_SEL;
			PENABLE=1'b0;
			PWRITE=1'b1;
			PWDATA=HWDATA_1;
		HREADYout=1'b0;

			nstate=ST_WENABLEP;
                    end


	ST_RENABLE: begin
		     PENABLE=1'b1;
		     PSEL=TEMP_SEL;
		    // PWRITE=1'b0;
		     HREADYout=1'b1;
			PADDR=HADDR_1;
		      if(~valid)
			nstate=ST_IDLE;
		      else if(valid && ~HWRITE)
			nstate=ST_READ;
		      else if(valid && HWRITE)
			nstate=ST_WWAIT;
		   end

	ST_WENABLE: begin
		      PENABLE=1'b1;
		      PSEL=TEMP_SEL;
		      PWRITE=1'b1;
		      HREADYout=1'b1;
				PADDR=HADDR_1;
			PWDATA=HWDATA_1;

			if(valid && ~HWRITE)
			nstate=ST_READ;
		      else if(~valid)
			nstate=ST_IDLE;
		      else if(valid && HWRITE)
			nstate=ST_WWAIT;
		    end

	ST_WENABLEP: begin
			
		       PSEL=TEMP_SEL;
		       PENABLE=1'b1;
		       PWRITE=1'b1;
		       HREADYout=1'b1;
				PADDR=HADDR_1;
				PWDATA=HWDATA_1;
				HREADYout=1'b0;

		       
		       if(~HWRITEreg)
			nstate=ST_READ;
		       else if(~valid && HWRITEreg)
			nstate=ST_WRITE;
		       else if(valid && HWRITEreg)
			nstate=ST_WRITEP;
		     end
		 default:nstate=ST_IDLE;
		endcase
             end
          
endmodule		    
		



