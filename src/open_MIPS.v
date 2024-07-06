`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: siom
// Engineer: chenshuda
// 
// Create Date: 2024/06/27 10:16:27
// Design Name: 
// Module Name: open_MIPS
// Project Name: suda_cpu
// Target Devices: 
// Tool Versions: 
// Description: 顶层模块
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module open_MIPS(
    input           rst,
    input           clk,

    input [31:0]    rom_data_i,                 // 从 指令存储器 取得的指令，只读存储器 不能写
    input [31:0]    ram_data_i,                 // 从 数据存储器 读取的数据，可读可写  
    input [2:0]     int_i,                      // 6个中断信号

    output          timer_int_o,                // 定时器中断信号
    output          rom_ce_o,                   // 指令存储器使能信号

    output [31:0]   rom_addr_o,                 // 输出到 指令存储器 的地址
    output [31:0]   ram_addr_o,                 // 要访问 数据存储器 的地址    
    
    output [31:0]   ram_data_o,                 // 要写入 数据存储器 的数据
    output [3:0]    ram_sel_o,                  // 字节选择信号
    output          ram_we_o,                   // 是否是对 数据存储器的写操作，为1表示是写操作
    output          ram_ce_o                    // 数据存储器使能信号        
);




endmodule