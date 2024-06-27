`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: siom
// Engineer: chenshuda
// 
// Create Date: 2024/06/27 10:16:27
// Design Name: 
// Module Name: if_id
// Project Name: suda_cpu
// Target Devices: 
// Tool Versions: 
// Description: 取指阶段取出指令存储器中的指令，同时PC值递增，准备取下一条指令，包括PC、IF/ID两个模块
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module if_id(
    input wire clk,
    input wire rst,

    // 来自取值阶段的信号，其中宏定义InstBus表示指令宽度，为32
    input wire[`InstAddrBus]    if_pc,
    input wire[`InstBus]        if_inst,

    // 对应译码阶段的信号
    output reg[`InstAddrBus]    id_pc,
    output reg[`InstBus]        id_inst    

);

    always@(posedge clk) begin
        if(rst == `RstEnable) begin
            id_pc <= `ZeroWord;     // 复位的时候id_pc 为0
            id_inst <= `ZeroWord;   // 复位的时候指令也是0 实际上就是空指令                
        end 
        else begin
            id_pc <= if_pc;             // 其余时刻向下传递取值阶段的值
            id_inst <= if_inst;
        end 


    end





endmodule