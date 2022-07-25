module Slave(reset,slaveDataToSend, slaveDataReceived,SCLK, CS, MOSI, MISO);
input reset,SCLK,CS,MOSI;
input [7:0]  slaveDataToSend;
output reg [7:0] slaveDataReceived;
output reg MISO;
integer i;
always@(posedge SCLK or posedge reset)
begin
if(reset) begin
slaveDataReceived<=8'b00000000;
i<=0;
end//end reset
else if(!CS)begin //enabled
if(i<=7) begin //else if reset=0
MISO<=slaveDataToSend[i];
i<=i+1;
end//else if
end//end enbled
else begin  //CS
i<=0;
MISO<=1'bz;
end
end //end always

always@(negedge SCLK or posedge reset)
begin
if(reset) //reset
begin  
slaveDataReceived<=8'b00000000;
i<=0;
end
else if(!CS) //enabled
slaveDataReceived<={MOSI,slaveDataReceived[7:1]};
end//end alwyas
endmodule

module Slave_tb();
reg reset,SCLK,CS,MOSI;
reg [7:0]  slaveDataToSend=8'b10101010;
wire [7:0] slaveDataReceived;
reg [7:0] checkdatatosend;
wire MISO;
//integer i;
Slave S1(reset,slaveDataToSend, slaveDataReceived,SCLK, CS, MOSI, MISO);
initial begin
reset=1'b1;
CS=1'b0;
SCLK=1'b0;
#10 reset=1'b0;
MOSI=1'b1;
#10 checkdatatosend[0]=MISO;
 MOSI=1'b1;
#10 checkdatatosend[1]=MISO;
MOSI=1'b0;
#10 checkdatatosend[2]=MISO;
 MOSI=1'b1;
#10 checkdatatosend[3]=MISO;
MOSI=1'b1;
#10 checkdatatosend[4]=MISO;
MOSI=1'b0;
#10 checkdatatosend[5]=MISO;
MOSI=1'b0;
#10 checkdatatosend[6]=MISO;
MOSI=1'b1;
#10 checkdatatosend[7]=MISO;
CS=1'b1;
//for(i=0;i<8;i=i+1)
//checkdatatosend[i]=MISO;
if((slaveDataReceived==8'b10011011)&&(checkdatatosend==slaveDataToSend))
$display("Test Succeeded for recieving data and sending it");
else
$display("Test failed");
#10 $finish;
end
always
#5 SCLK=~SCLK;
endmodule