module Master(clk, reset,start, slaveSelect, masterDataToSend, masterDataReceived,SCLK, CS, MOSI, MISO);
input clk,reset,start,MISO;
input [1:0]slaveSelect;
input [7:0]masterDataToSend;
output reg [7:0]masterDataReceived;
output reg SCLK;
output reg[2:0]CS;
output reg MOSI;
integer i;
always@(posedge start)
begin
i<=0;
CS<=(slaveSelect==2'b00)?3'b011:(slaveSelect==2'b01)?3'b101:(slaveSelect==2'b10)?3'b110:3'b111;
end
always@(posedge clk or posedge reset)
begin

if(reset)begin
masterDataReceived <=8'b00000000;
i<=0;
end
else if(i<=7)
begin
MOSI <= masterDataToSend[i];
i=i+1;
end
else //8-bitfinsh
CS<=3'b111;
if(&CS==1'b0)
SCLK<=clk;
else
SCLK<=1'bz;
end


always@(negedge clk or posedge reset) begin
if(reset)begin
masterDataReceived <=8'b00000000;
i<=0;
end
else if(&CS==1'b0)
masterDataReceived <= {MISO,masterDataReceived[7:1]};
if(&CS==1'b0)
SCLK<=clk;
else
SCLK<=1'bz;
end
endmodule



module MasterTB();
reg clk,reset,start,MISO;
reg [1:0]slaveSelect;
reg [7:0]masterDataToSend,recieved,senttomaster;
wire [7:0]masterDataReceived;
wire SCLK,CS,MOSI;
integer i =0;
Master M(clk, reset,start, slaveSelect, masterDataToSend, masterDataReceived,SCLK, CS, MOSI, MISO);

initial
begin
clk=1'b0;
reset=1'b1;
start=1'b0;
recieved=8'b00000000;
masterDataToSend=8'b11010011;
#10
reset=1'b0;
start=1'b1;
slaveSelect=2'b00;
MISO=1'b0;
#10
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b0;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b0;

#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#10
if(masterDataReceived == 8'b11100110) $display("Master Recieved:success");
else
begin
$display("Master Recieved Failure (Expected: %b, Received: %b)",8'b11100110, masterDataReceived);
end

if(recieved == masterDataToSend) $display("Master sent:success");
else
begin
$display("Master sent Failure (Expected: %b, Received: %b)",masterDataToSend, recieved);
end

reset=1'b1;
start=1'b0;
masterDataToSend=8'b11110000;
#10
reset=1'b0;
start=1'b1;
slaveSelect=2'b10;
MISO=1'b0;
#10
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b0;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b0;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#5
MISO=1'b1;
#5
recieved={MOSI,recieved[7:1]};
#10
if(masterDataReceived == 8'b11110100) $display("Master Recieved:success");
else
begin
$display("Master Recieved Failure (Expected: %b, Received: %b)",8'b11110100, masterDataReceived);
end
if(recieved == masterDataToSend) $display("Master sent:success");
else
begin
$display("Master sent Failure (Expected: %b, Received: %b)",masterDataToSend, recieved);
end
reset=1'b1;
start=1'b0;
#10
reset=1'b0;
start=1'b1;

slaveSelect=2'b11;
end
always 
#5 clk = ~clk;
endmodule

