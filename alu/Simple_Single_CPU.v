//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
      clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire clk_i;
wire rst_i;
wire jump;
wire MenRead;
wire MenWrite;
wire MenToReg;
wire [31:0] pc_in_i;
wire [31:0] pc_out_o;
wire [31:0] instr_o;
wire RegWrite_o;
wire [2:0] ALU_op_o ;
wire ALUSrc_o ; 
wire RegDst_o ;  
wire Branch_o ;
wire [4:0] Mux_Write_Reg_o;
wire Mux_PC_Source_1;
wire [31:0] RSdata_o;
wire [31:0] RTdata_o;
wire [31:0] SE_o;
wire [31:0] Mux_ALUSrc_o;
wire [3:0] ALUCtrl_o;
wire zero_o;
wire [31:0] ALU_o;
wire [31:0] Shifter_o;
wire [31:0] Adder_1_o;
wire [31:0] Adder_2_o;
wire [31:0] Mux_PC_Source_o;
wire [31:0] jump_addr;
wire [31:0] Men_o;
wire [31:0] men_out_o;
wire nor_o;
wire not1_o;
wire not2_o;
wire Mux4_o;
wire [1:0] BranchType;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in_i) ,   
	    .pc_out_o(pc_out_o)
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out_o),     
	    .sum_o(Adder_1_o)    
	    );
	
Instr_Memory IM(
        .addr_i(pc_out_o),  
	    .instr_o(instr_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst_o),
        .data_o(Mux_Write_Reg_o)
        );	
	
nor nor1(nor_o,zero_o,ALU_o[31]);
not not1(not1_o,zero_o);
not not2(not2_o,ALU_o[31]);
	
MUX_4to1 #(.size(1)) Mux_Branch(
        .data0_i(zero_o),
        .data1_i(nor_o),
		  .data2_i(not2_o),
		  .data3_i(not1_o),
        .select_i(BranchType),
        .data_o(Mux4_o)
        );
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(Mux_Write_Reg_o) ,  
        .RDdata_i(men_out_o)  , 
        .RegWrite_i (RegWrite_o),
        .RSdata_o(RSdata_o) ,  
        .RTdata_o(RTdata_o)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),   
		.Branch_o(Branch_o),
      .jump(jump)	,
      .MenRead(MenRead),
      .MenWrite(MenWrite),
		.MenToReg(MenToReg)
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALU_op_o),   
        .ALUCtrl_o(ALUCtrl_o) 
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(SE_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_o),
        .data1_i(SE_o),
        .select_i(ALUSrc_o),
        .data_o(Mux_ALUSrc_o)
        );	
		
ALU ALU(
        .src1_i(RSdata_o),
	    .src2_i(Mux_ALUSrc_o),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(ALU_o),
		.zero_o(zero_o)
	    );
		
Adder Adder2(
        .src1_i(Adder_1_o),     
	    .src2_i(Shifter_o),     
	    .sum_o(Adder_2_o)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(SE_o),
        .data_o(Shifter_o)
        ); 

Shift_Left_Two_32 Shifter2(
        .data_i({6'b000000,instr_o[25:0]}),
        .data_o(jump_addr)
        );		  
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(Adder_1_o),
        .data1_i(Adder_2_o),
        .select_i(Mux_PC_Source_1),
        .data_o(Mux_PC_Source_o)
        );	
		  
MUX_2to1 #(.size(32)) Mux_PC_Source2(
        .data0_i(Mux_PC_Source_o),
        .data1_i({Adder_1_o[31:28],jump_addr[27:0]}),
        .select_i(jump),
        .data_o(pc_in_i)
        );	
MUX_2to1 #(.size(32)) mem_out(
        .data0_i(ALU_o),
        .data1_i(Men_o),
        .select_i(MenToReg),
        .data_o(men_out_o)
        );	
and AND_1(Mux_PC_Source_1,Branch_o,Mux4_o);

Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(ALU_o),
		.data_i(RTdata_o),
		.MemRead_i(MenRead),
		.MemWrite_i(MenWrite),
		.data_o(Men_o) );
		
endmodule
		  


