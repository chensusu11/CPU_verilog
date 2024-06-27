`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: siom
// Engineer: chenshuda
// 
// Create Date: 2024/06/27 
// Design Name: 
// Module Name: regfile
// Project Name: suda_cpu
// Target Devices: 
// Tool Versions: 
// Description: 实现了32个32位通用整数寄存器，可以同时进行两个寄存器的读操作和一个寄存器的写操作
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module regfile(
    input wire clk,
    input wire rst,

    // 写端口
    input wire                  we,
    input wire [`RegAddrBus]    waddr,
    input wire [`RegBus]        wdata,

    // 读端口1
    input wire                  re1,
    input wire [`RegAddrBus]    raddr1,
    output reg [`RegBus]        rdata1,

    // 读端口2
    input wire                  re2,
    input wire [`RegAddrBus]    raddr2,
    output reg [`RegBus]        rdata2     

);

// 第一段：定义32个32位寄存器

    reg [`RegBus] regs [0: `RegNum-1];

// 第二段：写操作 时序逻辑
    always@(posedge clk) begin
        if(rst == `RstDisable) begin
            if((we == `WriteEnable) && (waddr != `RegNumLog2'h0))               regs[waddr] <= wdata;
        end    
    end 

// 第三段：读端口1的读操作 组合逻辑一旦输入的读取的寄存器地址raddr1或者raddr2发送变化
    always @(*) begin
        if(rst == `RstEnable)                                                           rdata1 <= `ZeroWord;
        else if(raddr1 == `RegNumLog2'h0)                                               rdata1 <= `ZeroWord;
        else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable))      rdata1 <= wdata;
        else if(re1 == `ReadEnable)                                                     rdata1 <= regs[raddr1];
        else                                                                            rdata1 <= `ZeroWord;        
    end

// 第四段：读端口2的读操作
    always@(*) begin
        if(rst == `RstEnable)                                                           rdata2 <= `ZeroWord;
        else if(raddr2 == `RegNumLog2'h0)                                               rdata2 <= `ZeroWord;            // 如果地址是0 rdata2 就赋值0
        else if((raddr2 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable))      rdata2 <= wdata;                // 如果地址是waddr 那就把数据 wdata给到rdata2
        else if(re2 == `ReadEnable)                                                     rdata2 <= regs[raddr2];         // 如果读使能有效，那么就把regs寄存器的数据给到rdata2
        else                                                                            rdata2 <= `ZeroWord;           
    end

endmodule