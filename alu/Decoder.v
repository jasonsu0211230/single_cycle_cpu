//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MenRead,
	MenWrite,
	MenToReg,
	jump,
	BranchType
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output 			MenToReg;
output [1:0]	BranchType;
output 			jump;
output 			MenRead;
output 			MenWrite;

 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg 				MenToReg;
reg 	[2-1:0]  BranchType;
reg				jump;
reg				MenRead;
reg 				MenWrite;


//Parameter


//Main function
always @(*)begin
if(instr_op_i==6'b000110)
BranchType<=2'b01;
else if(instr_op_i==6'b000101)
BranchType<=2'b11;
else if(instr_op_i==6'b000001)
BranchType<=2'b10;
else
BranchType<=2'b00;
end

always @(*)begin
if(instr_op_i==6'b000000)
ALU_op_o<=3'b000;
else if(instr_op_i==6'b001000)
ALU_op_o<=3'b010;
else if(instr_op_i==6'b001010)
ALU_op_o<=3'b111;
else if(instr_op_i==6'b000100)
ALU_op_o<=3'b110;
else if(instr_op_i==6'b100011)
ALU_op_o<=3'b010;
else if(instr_op_i==6'b101011)
ALU_op_o<=3'b010;
end

always @(*)begin
if(instr_op_i==6'b000000)
RegDst_o<=1'b1;
else
RegDst_o<=1'b0;
end

always @(*)begin
if(instr_op_i==6'b000000)
ALUSrc_o<=1'b0;
else if(instr_op_i==6'b000100)
ALUSrc_o<=1'b0;
else
ALUSrc_o<=1'b1;
end

always @(*)begin
if(instr_op_i==6'b000100)
Branch_o<=1'b1;
else
Branch_o<=1'b0;
end

always @(*)begin
if(instr_op_i==6'b000100)
RegWrite_o<=1'b0;
else if(instr_op_i==6'b101011)
RegWrite_o<=1'b0;
else if(instr_op_i==6'b000010)
RegWrite_o<=1'b0;
else
RegWrite_o<=1'b1;
end

always@(*)begin
if(instr_op_i==6'b100011)
MenWrite<=0;
else if(instr_op_i==6'b101011)
MenWrite<=1;
else 
MenWrite<=0;
end

always@(*)begin
if(instr_op_i==6'b101011)
MenRead<=0;

else 
MenRead<=1;
end




always@(*)begin
if(instr_op_i==6'b000010)
jump<=1;
else 
jump<=0;
end

always @(*)begin
if(instr_op_i==6'b100011)
MenToReg<=1'b1;
else
MenToReg<=1'b0;
end



endmodule 




                    
                    