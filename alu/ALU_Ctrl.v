//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*)begin
if(ALUOp_i!=3'b0)
ALUCtrl_o<={1'b0,ALUOp_i};
else begin
	if(funct_i==6'b100000)
	ALUCtrl_o<=4'b0010;
	else if(funct_i==6'b100010)
	ALUCtrl_o<=4'b0110;
	else if(funct_i==6'b100100)
	ALUCtrl_o<=4'b0000;
	else if(funct_i==6'b100101)
	ALUCtrl_o<=4'b0001;
	else if(funct_i==6'b011000)
	ALUCtrl_o<=4'b0011;
	else if(funct_i==6'b101010)
	ALUCtrl_o<=4'b0111;
end
end
endmodule     





                    
                    