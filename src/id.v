`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: siom
// Engineer: chenshuda
// 
// Create Date: 2024/06/27 
// Design Name: 
// Module Name: id
// Project Name: suda_cpu
// Target Devices: 
// Tool Versions: 
// Description: 对指令进行译码，最终得到运算的类型、子类型、源操作数1、源操作数2、要写入的目的寄存器地址等信息
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"


module id(
        input                       rst,
        
        input [`InstAddrBus]        pc_i,               // (InstAddrBus 31:0)
        input [`InstBus]            inst_i,             // (InstBus 31:0)       输入指令

        // 读取的 Regfile的值
        input [`RegBus]             reg1_data_i,        // (RegBus 31:0)
        input [`RegBus]             reg2_data_i,  
        
        // 输出到 Regfile的信息
        output reg                  reg1_read_o,
        output reg                  reg2_read_o,

        output reg [`RegAddrBus]    reg1_addr_o,        // regAddrBus 31:0
        output reg [`RegAddrBus]    reg2_addr_o,

        // 送到执行阶段的信息
        output reg [`AluOpBus]      aluop_o,            //  AluOpBus  7:0                 
        output reg [`AluSelBus]     alusel_o,           //  AluSelBus 2:0   
        output reg [`RegBus]        reg1_o,             //  RegBus    31:0
        output reg [`RegBus]        reg2_o,             //  
        output reg [`RegAddrBus]    wd_o,               //  RegAddrBus 4:0
        output reg                  wreg_o              //  

);

    // 取得指令的指令码，功能码
    // 对于ori指令只需通过判断第26-31 bit 的值，即可判断是否是ori指令
    wire [5:0] op = inst_i  [31:26];
    wire [4:0] op2 = inst_i [10:6];
    wire [5:0] op3 = inst_i [5:0];
    wire [4:0] op4 = inst_i [20:16];

    // 保存指令执行需要的立即数
    reg [`RegBus]       imm;

    // 指示指令是否有效
    reg instvalid;

    // 第一段：对指令进行译码
    always@(*) begin
        if(rst == `RstEnable) begin
            aluop_o             <= `EXE_NOP_OP;     // 8'b00100101
            alusel_o            <= `EXE_RES_NOP;    //
            wd_o                <= `NOPRegAddr;
            wreg_o              <= `WriteDisable;
            instvalid           <= `InstValid;
            reg1_read_o         <= 1'b0;
            reg2_read_o         <= 1'b0;
            reg1_addr_o         <= `NOPRegAddr;
            reg2_addr_o         <= `NOPRegAddr;
            imm                 <= 32'h0;        
        end else begin
            aluop_o             <=  `EXE_NOP_OP;     // 8'b00100101
            alusel_o            <=  `EXE_RES_NOP;    //
            wd_o                <=  `NOPRegAddr;
            wreg_o              <=  `WriteDisable;
            instvalid           <=  `InstValid;
            reg1_read_o         <=  1'b0;
            reg2_read_o         <=  1'b0;
            reg1_addr_o         <=  inst_i[25:21];   // 默认通过Regfile读端口1读取的寄存器地址
            reg2_addr_o         <=  inst_i[20:16];   // 默认通过Regfile读端口2读取的寄存器地址
            imm                 <=  `ZeroWord;  
            
            case (op)
                `EXE_ORI:   begin           // 依据op的值判断是否是ori指令
                    // ori指令需要将结果写入目的寄存器，所以wreg_o 为 WriteEnable
                    wreg_o      <= `WriteEnable;
                    
                    // 运算的子类型是 逻辑或
                    aluop_o     <= `EXE_OR_OP;
                    
                    // 运算类型是逻辑运算
                    alusel_o    <= `EXE_RES_LOGIC;

                    // 需要通过Regfile的读端口1读取寄存器
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    
                    // 指令执行需要的立即数
                    imm         <= {16'h0, inst_i[15:0]};

                    // 指令执行要写的目的寄存器地址
                    wd_o        <= inst_i[20:16];

                    // ori指令是有效指令
                    instvalid   <= `InstValid;

                end 
                default:; 
            endcase        // case op
        end
    end 

    // 第二段：确定进行运算的源操作数1
    always@(*) begin
        if(rst == `RstEnable)           reg1_o <= `ZeroWord;
        else if(reg1_read_o == 1'b1)    reg1_o <= reg1_data_i;
        else if(reg1_read_o == 1'b0)    reg1_o <= imm;
        else                            reg1_o <= `ZeroWord;
    end

    // 第三段：确定进行运算的源操作数2
    always@(*) begin
        if(rst == `RstEnable)           reg2_o <= `ZeroWord;
        else if(reg2_read_o == 1'b1)    reg2_o <= reg2_data_i;
        else if(reg2_read_o == 1'b0)    reg2_o <= imm;
        else                            reg2_o <= `ZeroWord;
    end



endmodule