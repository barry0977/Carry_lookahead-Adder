/*
    ans:
    00000000000000000000000000000011
*/

`include "adder.v"

module top_module();
    wire [3:0] answer;
	wire 		carry;
	reg  [3:0] a, b;
	reg	 [4:0] res;

    adder_4bit adder(
        .a(a),
        .b(b),
        .S(answer),
        .Co(carry)
    );

    integer i;
	initial begin
		for(i=1; i<=100; i=i+1) begin
			a[3:0] = $random;
			b[3:0] = $random;
			res		= a + b;
			
			#1;
			$display("TESTCASE %d: %d + %d = %d carry: %d", i, a, b, answer, carry);

			if (answer !== res[3:0] || carry != res[4]) begin
				$display("Wrong Answer!");
			end
		end
		$display("Congratulations! You have passed all of the tests.");
		$finish;
	end
endmodule