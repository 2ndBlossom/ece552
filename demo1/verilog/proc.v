/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output wire err;//Matt's reg is exchanged to wire

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */






   //fetch 
   wire [15:0]PC_cur;//current PC
   wire [15:0]ext_result;
   wire HALT;
   wire [15:0]alu_result;
   wire JR;  
   wire bcomp_en;
   wire Jump;
   wire fetch_err;
   
   wire [15:0]PC_nxt;
   wire [15:0]PC_2_JAL;
   wire [15:0]full_instr;


   
   //decode decode signal declaration
   //control signal input
   wire [15:0]Writeback_data;
   //control signal 
   wire [2:0]RegDst;//RegDst as the selection for the write back address
   wire Branch;//
   wire MemRead;//
   wire MemReg;//
   wire MemWrite;
   wire ALUsrc;//ALU inB from Rd'0' or from extended imm_number'1' 
   wire [7:0]ALU_op;//Be used as the control signal of ALU in Excution stage
   wire ALU_en;
   wire RegWrite;
   wire LBI_flag;//for LBI flag write back avoid the ex/mem period
   wire SLBI_flag;//for SLBI shift <<8
   wire BTR_flag;//for swipe from the MSB to LSB
   wire JAL;//for JAL; JALR; when we need to write back the PC+2 into R7
   wire [4:0]Op_code;
   wire [1:0]Op_func;
   wire [2:0]ext_sel;

   //module Register
   wire [15:0]Read_rg_data_1;
   wire [15:0]Read_rg_data_2;
   wire decode_err;
   wire [2:0]RegWrite_addr;


  //excute
   wire Zero;
   wire Ofl;
   wire en;




   //memory
   wire [15:0]MemRead_data;
   wire [15:0]MemWrite_data;


   //module wb
























   //fetch connection

   fetch fetch(.clk(clk), .rst(rst), .PC_cur(PC_nxt_asyn), .ext_result(ext_result), .HALT(HALT), .alu_result(alu_result), .JR(JR), 
   .bcomp_en(bcomp_en), .Jump(Jump), .PC_nxt_asyn(PC_nxt), .PC_2_JAL(PC_2_JAL), .full_instr(full_instr), .fetch_err(fetch_err));

   //decode connection
   decode decode(   //control signal input
   .full_instr(full_instr),
   .rst(rst),
   .clk(clk),
   .Writeback_data(Writeback_data),
   //control signal output 
   .RegDst(RegDst),//RegDst as the selection for the write back address
   .HALT(HALT),//Halt be 1 when halt
   .Jump(Jump),//'PC+2' or 'PC+2+ext(I)' or 'PC+2+ext(D)'
   .Branch(Branch),//
   .MemRead(MemRead),//
   .MemReg(MemReg),//
   .MemWrite(MemWrite),
   .ALUsrc(ALUsrc),//ALU inB from Rd'0' or from extended imm_number'1' 
   .ALU_op(ALU_op),//Be used as the control signal of ALU in Excution stage
   .ALU_en(ALU_en),
   .RegWrite(RegWrite),
   .JR(JR),//JR, JALR, when we need to control PC in fetch
   .LBI_flag(LBI_flag),//for LBI flag write back avoid the ex/mem period
   .SLBI_flag(SLBI_flag),//for SLBI shift <<8
   .BTR_flag(BTR_flag),//for swipe from the MSB to LSB
   .JAL(JAL),//for JAL, JALR, when we need to write back the PC+2 into R7
   .Op_code(Op_code),
   .Op_func(Op_func),
   .ext_sel(ext_sel),
   .ext_result(ext_result),
   .RegWrite_addr(RegWrite_addr),
   //module Register
   .Read_rg_data_1(Read_rg_data_1),
   .Read_rg_data_2(Read_rg_data_1),
   .decode_err(decode_err),
   //module branch Comparator
   .bcomp_en(bcomp_en)
   );


   

   //excute connection //////////// NEED TO BE COMPLETE
   execute execute(
   .Read_rg_data_1(Read_rg_data_1),
   .Read_rg_data_2(Read_rg_data_2),
   .ext_result(ext_result),
   .ALU_op(ALU_op),
   .ALU_en(ALU_en),
   .ALUsrc(ALUsrc),
   .alu_result(alu_result),
   .Zero(Zero),
   .Ofl(Ofl)
);

   //memory
   memory memory(
   .clk(clk), 
   .rst(rst),
   .HALT(HALT),
   .MemRead(MemRead),
   .MemWrite(MemWrite),
   .MemWrite_data(MemWrite_data),
   .alu_result(alu_result),
   .MemRead_data(MemRead_data)
   );


   //wb connection
   wb wb(
      .alu_result(alu_result),
      .MemRead_data(MemRead_data),
      .MemReg(MemReg),
      .PC_2_JAL (PC_2_JAL),
      .JAL (JAL),
      .ext_result(ext_result),
      .LBI_flag(LBI_flag),
      .Writeback_data(Writeback_data)
   );

   //err
   /*
   wire err_asycn;
   assign err_asycn = fetch_err| decode_err;
   dff dff_errs(.d(err_asycn), .q(err), .clk(clk) ,.rst(rst));
*/

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0
