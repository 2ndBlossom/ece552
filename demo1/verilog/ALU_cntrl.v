`default_nettype none
module ALU_cntrl (ALU_mode, ALU_en, ALU_op);
input wire [3:0]ALU_mode;
input wire ALU_en;
output reg [7:0]ALU_op;

//ALU work mode:
//4'd0(7): signed add----JR,JALR,ADDI,LD,ST,STU,ADD
//4'd1(2): signed sub----SUBI,SUB
//4'd2(2): unsigned XOR--XORI XOR
//4'd3:(2): unsigned andn--ANDN, ANDNI
//4'd4(2): Left shift----SLL, SLLI
//4'd5(2): Right shift----SRL, SRLI
//4'd6(2): Left rotate----ROL, ROLI
//4'd7(2): Right rotate----ROR, RORI

//4'd8(11): IDLE, donothing, For the distinction with the sll, set 'signed' to 1
//HALT, NOP, siic, NOP/RTI, J
//JAL, BEQZ, BLTZ, BNEZ, BGEZ
//LBI,
//4'd9(1):(RS left shift 8 )and I----SBLI
//4'd10(1):unsigned add----SCO
//4'd11(1):BTR ALL swipe----BTR
//4'd12,13,14(3):compare and set 1/0----SEQ, SLT, SLE, 


/*  ALU_op[7:0]:
    [7]:Cin, only be 1 when we start a subtraction
    [3:6]:ALU oper, from 000 to 111, include shift, add, or, and, xor
    [2]:invA   set 1 in SUB and SUBI
    [1]:invB   set 1 in ANDN and ANDNI
    [0]:signed or unsigned   */




always@(*) begin
case({ALU_en,ALU_mode})
    5'b0xxxx:begin//mode 8, IDLE, dis_enable,ALU do nothing
    ALU_op=0_0000_0_0_1;//Cin_opercode_invA_invB_sign 
    end
    
    5'b10000:begin//mode 0,signed add----JR,JALR,ADDI,LD,ST,STU,ADD
    ALU_op=0_0100_0_0_1;
    end
    
    5'b10001:begin//mode 1, signed sub----SUBI,SUB
    ALU_op=1_0100_1_0_1;
    end

    5'b10010:begin//mode 2, unsigned XOR--XORI XOR
    ALU_op=0_0111_0_0_0;
    end

    5'b10011:begin//mode 3, unsigned andn--ANDN, ANDNI
    ALU_op=0_0101_0_1_0;
    end

    5'b10100:begin//mode 4, Left shift----SLL, SLLI
    ALU_op=0_0000_0_0_0;
    end

    5'b10101:begin//mode 5, Right shift----SRL, SRLI
    ALU_op=0_0001_0_0_0;
    end

    5'b10110:begin//mode 6, Left rotate----ROL, ROLI
    ALU_op=0_0010_0_0_0;
    end

    5'b10111:begin//mode 7, Right rotate----ROR, RORI
    ALU_op=0_0011_0_0_0;
    end
    
    5'b11001:begin//mode 9, (RS left shift 8 )and I----SLBI, use the oper 'or' in alu
    ALU_op=0_0110_0_0_0;    
    end

    5'b11010: begin//mode 10, unsigned add----SCO
    ALU_op=0_1100_0_0_0;    
    end

    5'b11011: begin//mode 11, ALL swipe----BTR
    ALU_op=0_1000_0_0_0;    
    end

    5'b11011: begin//mode 12, compare and set 1/0----SEQ   
    ALU_op=0_1001_0_0_0;    
    end

    5'b11100: begin//mode 13, compare and set 1/0----SLT
    ALU_op=0_1010_0_0_0;    
    end
    
    5'b11101: begin//mode 14, compare and set 1/0----SLE
    ALU_op=0_1011_0_0_0;    
    end
//oper 0-7 for normal
//oper 8 forBTR
//oper 9 for SEQ
//oper 10 for SLT
//oper 11 for SLE
    default: begin// same as the IDLE, ALU do nothing
    ALU_op=0_0000_0_0_1;//Cin_opercode_invA_invB_sign       
    end
endcase
end


endmodule