unit uTest;

interface
uses
  DUnitX.TestFramework,
  SSHCommand;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [TEST]
    procedure TestParameterLineCommandStandardPort;
    [TEST]
    procedure TestParameterLineCommandOtherPort;
    [TEST]
    procedure TestParameterLineSCPToRemoteStandardPort;
    [TEST]
    procedure TestParameterLineSCPFromRemoteStandardPort;
  end;

implementation

procedure TMyTestObject.Setup;
begin
end;

procedure TMyTestObject.TearDown;
begin
end;

procedure TMyTestObject.TestParameterLineSCPFromRemoteStandardPort;
var
  LSSHCommander : TSSHCommand;
  LGoodLine : string;
begin
  LSSHCommander.HostName := 'example.com';
  LSSHCommander.UserName := 'myuser';
  LSSHCommander.KeyFile := '~/.ssh/mykey';
  LSSHCommander.Source := '/home/myuser/list1.txt';
  LSSHCommander.Destination := 'c:\Users\bill\';
  // scp -P 22 -i keyfile user@remotehost:/home/myuser/file1.csv c:\tools\
  LGoodLine := '-P 22 -i ~/.ssh/mykey myuser@example.com:/home/myuser/list1.txt c:\Users\bill\';
  Assert.AreEqual(LGoodLine, LSSHCommander.GetSCPFromRemoteParameterLine, 'Parameterlist scp from remote standardport incorrect');
end;

procedure TMyTestObject.TestParameterLineSCPToRemoteStandardPort;
var
  LSSHCommander : TSSHCommand;
  LGoodLine : string;
begin
  LSSHCommander.HostName := 'example.com';
  LSSHCommander.UserName := 'myuser';
  LSSHCommander.KeyFile := '~/.ssh/mykey';
  LSSHCommander.Source := 'c:\Users\bill\list1.txt';
  LSSHCommander.Destination := '/home/myuser/list2.txt';
  // scp -P 22 -i keyfile c:\Users\bill\list1.txt user@remotehost:/home/myuser/file1.csv
  LGoodLine := '-P 22 -i ~/.ssh/mykey c:\Users\bill\list1.txt myuser@example.com:/home/myuser/list2.txt';
  Assert.AreEqual(LGoodLine, LSSHCommander.GetSCPToRemoteParameterLine, 'Parameterlist scp to remote standardport incorrect');
end;

procedure TMyTestObject.TestParameterLineCommandOtherPort;
var
  LSSHCommander : TSSHCommand;
  LGoodLine : string;
begin
  LSSHCommander.HostName := 'example.com';
  LSSHCommander.UserName := 'myuser';
  LSSHCommander.PortNum := 12322;
  LSSHCommander.KeyFile := '~/.ssh/mykey';
  LSSHCommander.Command := 'MyCommand';
  LSSHCommander.CommandParameter := 'DoNothing';
  // ssh remotehost -p 12322 -i keyfile -l user -t "command commandparameter"
  LGoodline := 'example.com -p 12322 -i ~/.ssh/mykey -l myuser -t "MyCommand DoNothing"';
  Assert.AreEqual(LGoodLine, LSSHCommander.GetCommandParameterLine, 'Parameterlist Command other port incorrect');
end;

procedure TMyTestObject.TestParameterLineCommandStandardPort;
var
  LSSHCommander : TSSHCommand;
  LGoodLine : string;
begin
  LSSHCommander.HostName := 'example.com';
  LSSHCommander.UserName := 'myuser';
  LSSHCommander.KeyFile := '~/.ssh/mykey';
  LSSHCommander.Command := 'MyCommand';
  LSSHCommander.CommandParameter := 'DoNothing';
  // ssh remotehost -p 22 -i keyfile -l user -t "command commandparameter"
  LGoodline := 'example.com -p 22 -i ~/.ssh/mykey -l myuser -t "MyCommand DoNothing"';
  Assert.AreEqual(LGoodLine, LSSHCommander.GetCommandParameterLine, 'Parameterlist Command standardport incorrect');
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
