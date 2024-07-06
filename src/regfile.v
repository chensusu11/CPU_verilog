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
// Description: 实现了32个32位通用整数寄存器，可以同时进行两个寄存器的读操作和一个寄存器的写操作。因为RAM和ROM，只有一个可写，两个都可读
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
    input wire                  we,                     // 写使能有效
    input wire [`RegAddrBus]    waddr,                  // RegAddrBus 4:0 要写入的寄存器地址，因为是5位对应着32个
    input wire [`RegBus]        wdata,                  // RegBus     31:0

    // 读端口1
    input wire                  re1,                    // 读寄存器1使能有效
    input wire [`RegAddrBus]    raddr1,                 // 寄存器1 要读取的寄存器地址        
    output reg [`RegBus]        rdata1,                 // 寄存器1 输出的寄存器值

    // 读端口2
    input wire                  re2,                    // 读寄存器2使能有效
    input wire [`RegAddrBus]    raddr2,                 // 寄存器2 要读取的寄存器地址    
    output reg [`RegBus]        rdata2                  // 寄存器2 输出的寄存器值    

);

// 第一段：定义32个32位寄存器

    reg [`RegBus] regs [0: `RegNum-1];  // 前面是位宽32 后面是32个 RegNum 32, 就是32个32位的寄存器组

// 第二段：写操作 时序逻辑， 如果写使能有效和写地址 不为1，就把wdata数据写到 regs 寄存器里面；（RegNumLog2：5）
    always@(posedge clk) begin
        if(rst == `RstDisable) begin
            if((we == `WriteEnable) && (waddr != `RegNumLog2'h0))                       regs[waddr] <= wdata;
        end    
    end 

// 第三段：读端口1的读操作 组合逻辑一旦输入的读取的寄存器地址raddr1或者raddr2发送变化
    always @(*) begin
        if(rst == `RstEnable)                                                           rdata1 <= `ZeroWord;
        // 规定寄存器0的值只能是0
        else if(raddr1 == `RegNumLog2'h0)                                               rdata1 <= `ZeroWord;  
        // 如果要写入的寄存器地址正好是读的寄存器，且即读又写，写的数据wdata数据直接给 rdata1
        else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable))      rdata1 <= wdata;
        // 如果读使能有效，就将寄存器组的值 赋值给rdata1
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