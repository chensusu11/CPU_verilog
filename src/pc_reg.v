`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: siom
// Engineer: chenshuda
// 
// Create Date: 2024/06/27 10:16:27
// Design Name: 
// Module Name: pc_reg
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
 
module pc_reg(
    input wire                clk,
    input wire                rst,
    output reg[`InstAddrBus]  pc,    // 要读取的指令地址
    output reg                ce     // 指令寄存器使能信号
);
 
    always @(posedge clk) begin
        if(rst == `RstEnable)                 ce <= `ChipDisable;                   //复位时指令存储器禁用
        else                                  ce <= `ChipEnable;                    //复位结束后使能指令存储器
    end
 
    always @(posedge clk) begin
        if(ce == `ChipDisable)                pc <= 32'h00000000;                   //指令存储器禁用时，PC为0
        else                                  pc <= pc + 4'h4;                      //指令存储器使能时，PC的值每时钟周期加4
    end
 
endmodule