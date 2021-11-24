See An [Gurux](http://www.gurux.org/ "Gurux") for an overview.

Join the Gurux Community or follow [@Gurux](https://twitter.com/guruxorg "@Gurux") for project updates.

Gurux.DLMS.Delphi library is a high-performance Delphi component that helps you to read you DLMS/COSEM compatible electricity, gas or water meters. We have try to make component so easy to use that you do not need understand protocol at all.
We have made it with [Embarcadero](http://www.embarcadero.com) XE5 combiler.

For more info check out [Gurux.DLMS](http://www.gurux.fi/index.php?q=Gurux.DLMS "Gurux.DLMS").

We are updating documentation on Gurux web page. 

Read should read [DLMS/COSEM FAQ](http://www.gurux.org/index.php?q=DLMSCOSEMFAQ) first to get started. Read Instructions for making your own [meter reading application](http://www.gurux.org/index.php?q=DLMSIntro) or build own 
DLMS/COSEM [meter/simulator/proxy](http://www.gurux.org/index.php?q=OwnDLMSMeter).

If you have problems you can ask your questions in Gurux [Forum](http://www.gurux.org/forum).

Example supports only TCP/IP connection at the moment, but you can easily add serial or teminal port connection if you need it.


Simple example
=========================== 
Before use you must set following device parameters. 
Parameters are manufacturer spesific.


```delphi

Client := TGXDLMSClient.Create(
  // Is used Logican Name or Short Name referencing.
    True, 
  //Client ID
    16, 
  //Server ID
    1,
  //Authentication Level.
    TAuthentication.None, 
  //PassWord
    Nil, 
  //Communication profile.
  TInterfaceType.HDLC);

```

After you have set parameters you can try to connect to the meter.
First you should send SNRM request and handle UA response.
After that you will send AARQ request and handle AARE response.


```delphi

data := Client.SNRMRequest;
if (data <> nil) then
begin
  if Trace then
    writeln('Send SNRM request: ');

  reply := ReadDLMSPacket(data);
  if Trace then
    writeln('Parsing UA reply: ');
  Client.ParseUAResponse(reply);
  writeln('Parsing UA reply succeeded.');
end;

for data in Client.AARQRequest() do
begin
  if Trace then
    writeln('Send AARQ request: ');
  reply := ReadDLMSPacket(data);
end;

if Trace then
  writeln('Parsing AARE reply: ');

Client.ParseAAREResponse(reply);
writeln('Connection succeeded.');

```

If parameters are right connection is made.
Next you can read Association view and show all objects that meter can offer.

```delphi
/// Read Association View from the meter.
reply := ReadDataBlock(Client.GetObjectsRequest());
Client.ParseObjects(reply, True);
Result := Client.Objects;

```
Now you can read wanted objects. After read you must close the connection by sending
disconnecting request.

```delphi
ReadDLMSPacket(Client.DisconnectRequest());
socket.Close();

```

```delphi

//Read DLMS packet from the meter.
procedure TGXProgram.ReadDLMSPacket(data: TBytes; reply: TGXReplyData);
var
  error: Integer;
  pos, cnt: Integer;
  eop: Variant;
  Description : string;
  stream: TWinSocketStream;
  Result: TBytes;
begin
  if (data = nil) then
      Exit;
  try
    stream := TWinSocketStream.Create(socket.Socket, WaitTime);
    WriteTrace('<- ' + TimeToStr(Time) + '\t' + TGXByteBuffer.ToHexString(data));

    //Send data.
    stream.Write(data, 0, Length(data));
    pos := 0;
    eop := (Byte(126));
    if Client.InterfaceType = TInterfaceType.WRAPPER then
      eop := VarEmpty;

    repeat
      //Wait new data.
      if stream.WaitForData(WaitTime) = false then
        raise Exception.Create('Failed to received reply from the meter.');

      cnt := socket.Socket.ReceiveLength;
      if cnt <> 0 then
      begin
        SetLength(Result, pos + cnt);
        socket.Socket.ReceiveBuf(Result[pos], cnt);
        pos := pos + cnt;
        //If all data is received.
         //Loop until whole COSEM packet is received.
        if Client.GetData(Result, reply) Then
          break;
      end;
    Until Length(Result) > 2000;
    WriteTrace('-> ' + TimeToStr(Time) + '\t' + TGXByteBuffer.ToHexString(Result));

    if reply.Error <> 0 Then
      raise TGXDLMSException.Create(reply.Error);
  finally
    FreeAndNil(stream);
  end;
end;

```

Using authentication


When authentication (Access security) is used server(meter) can allow different rights to  the client.
Example without authentication (None) only read is allowed.
Gurux DLMS for Delphi component supports five different authentication level:

+ None
+ Low

In default Authentication level None is used. If other level is used password must also give.
Used password depends from the meter.

```delphi
client.Authentication := TAuthentication.Low;
FGXDLMSClient.Password := TEncoding.ASCII.GetBytes('12345678');
``` 


Writing values

Writing values to the meter is very simple. You just Update Object's propery and then write it.
In this example we want to update clock time of the meter.


Note!
 Data type must be correct or meter returns usually error.
 If you are reading byte value you can't write UIn16.



```delphi
//Write computer time to meter.
if it.ClassType = TGXDLMSClock then
begin
try
  (it as TGXDLMSClock).Time := TGXDateTime.Create(Date());
  Write(it, 2);
except
on E: TGXDLMSException do
begin
  WriteTrace('Error! Index: ' + IntToStr(pos) + ' ' + E.Message);
end;
on Ex : Exception do
begin
WriteTrace('Error! Index: ' + IntToStr(pos) + ' ' + Ex.Message);
end;
end;
end;

``` 