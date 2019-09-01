program SSHCommandDemo;

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

    MyResult := MySSHCommander.SendCommand( '~/testcommand.sh', 'newline123' );
    if MyResult > 32 then Writeln('Command OK')
    else Writeln('Error Nr.: ' + MyResult.ToString);
    Writeln('Press Enter...');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
