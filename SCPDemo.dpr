program SCPDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  SSHCommand;

var
  MySSHCommander : TSSHCommand;
  MyResult : integer;
begin
  try
    MySSHCommander.HostName := 'www.example.com';
    MySSHCommander.PortNum := 12322;
    MySSHCommander.UserName := 'myuser';
    MySSHCommander.KeyFile := '~/.ssh/myuserkey';

    MyResult := MySSHCommander.SCPFromRemote( '/home/bill/list*.*', 'c:\tools\' );
    if MyResult > 32 then Writeln('Copy from remote  OK')
    else Writeln('Error Nr.: ' + MyResult.ToString);

    MyResult := MySSHCommander.SCPToRemote( 'c:\tools\liste2.txt' , '/home/bill/' );
    if MyResult > 32 then Writeln('Copy to remote  OK')
    else Writeln('Error Nr.: ' + MyResult.ToString);

    Writeln('Press Enter...');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
