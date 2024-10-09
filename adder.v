module adder_1bit(
    input a,
    input b,
    input c,//进位

    output Gi,//生成信号Gi = ai & bi
    output Pi,//传播信号Pi = ai ^ bi
    output Si//输出结果
);

assign Gi = a & b;
assign Pi = a | b;
assign Si = a ^ b ^ c; 
endmodule

module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input c,

    output [3:0] S,//所有位的输出
    output Co,//最后一位的进位
    output Go,//四位加法器的等效生成信号
    output Po//四位加法器的等效传播信号
);

wire [3:0] Gi;
wire [3:0] Pi;
wire [3:0] Ci;//处理进位

adder_1bit adder_1(
    .a(a[0]),
    .b(b[0]),
    .c(c),

    .Gi(Gi[0]),
    .Pi(Pi[0]),
    .Si(S[0])
);

adder_1bit adder_2(
    .a(a[1]),
    .b(b[1]),
    .c(Ci[1]),

    .Gi(Gi[1]),
    .Pi(Pi[1]),
    .Si(S[1])
);

adder_1bit adder_3(
    .a(a[2]),
    .b(b[2]),
    .c(Ci[2]),

    .Gi(Gi[2]),
    .Pi(Pi[2]),
    .Si(S[2])
);

adder_1bit adder_4(
    .a(a[3]),
    .b(b[3]),
    .c(Ci[3]),

    .Gi(Gi[3]),
    .Pi(Pi[3]),
    .Si(S[3])
);

assign Ci[1] = Gi[0] | Pi[0] & c;
assign Ci[2] = Gi[1] | Pi[1] & (Gi[0] | Pi[0] & c);
assign Ci[3] = Gi[2] | Pi[2] & (Gi[1] | Pi[1] & (Gi[0] | Pi[0] & c));
assign Co = Gi[3] | Pi[3] & (Gi[2] | Pi[2] & (Gi[1] | Pi[1] & (Gi[0] | Pi[0] & c)));
assign Go = Gi[3] | Pi[3] & Gi[2] | Pi[3] & Pi[2] & Gi[1] | Pi[3] & Pi[2] & Pi[1] & Gi[0];
assign Po = Pi[3] & Pi[2] & Pi[1] & Pi[0];
endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input c,

    output [15:0] S,
    output Co
);

wire [3:0] Ci;
wire [3:0] Gi;
wire [3:0] Pi;
 
adder_4bit adder_5(
    .a(a[3:0]),
    .b(b[3:0]),
    .c(c),

    .S(S[3:0]),
    .Go(Gi[0]),
    .Po(Pi[0])
);

adder_4bit adder_6(
    .a(a[7:4]),
    .b(b[7:4]),
    .c(Ci[1]),

    .S(S[7:4]),
    .Go(Gi[1]),
    .Po(Pi[1])
);

adder_4bit adder_7(
    .a(a[11:8]),
    .b(b[11:8]),
    .c(Ci[2]),

    .S(S[11:8]),
    .Go(Gi[2]),
    .Po(Pi[2])
);

adder_4bit adder_8(
    .a(a[15:12]),
    .b(b[15:12]),
    .c(Ci[3]),

    .S(S[15:12]),
    .Go(Gi[3]),
    .Po(Pi[3])
);

assign Ci[1] = Gi[0] | Pi[0] & c;
assign Ci[2] = Gi[1] | Pi[1] & (Gi[0] | Pi[0] & c);
assign Ci[3] = Gi[2] | Pi[2] & (Gi[1] | Pi[1] & (Gi[0] | Pi[0] & c));
assign Co = Gi[3] | Pi[3] & (Gi[2] | Pi[2] & (Gi[1] | Pi[1] & (Gi[0] | Pi[0] & c)));
endmodule

module Add(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum,
    output carry
);
wire temp;
adder_16bit adder_9(
    .a(a[15:0]),
    .b(b[15:0]),
    .c(1'b0),

    .S(sum[15:0]),
    .Co(temp)
);

adder_16bit adder_10(
    .a(a[31:16]),
    .b(b[31:16]),
    .c(temp),

    .S(sum[31:16]),
    .Co(carry)
);
endmodule