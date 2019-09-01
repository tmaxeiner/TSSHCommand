unit SSHCommand;
{
  unit     : SSHCommand.pas
  Author   : tmaxeiner <tmaxeiner@maxeiner-computing.de>
  License  : MIT, see License file
  Version  : 0.1
}

interface


uses
  System.SysUtils,
  shellapi,
  Winapi.Windows;

type
  TSSHCommand = record
  strict private
    FSSHClient : string;
    FHostName : string;
    FPortNum : integer;
    FUserName : string;
    FKeyFile : string;
    FCommand : string;
    FCommandParameter : string;
    FSource : string;
    FDestination : string;
    FSCPParameterLine : string;
    function GetPortNum : integer;
    procedure SetHostName( const Value : string );
    procedure SetKeyFile( const Value : string );
    procedure SetPortNum( const Value : integer );
    procedure SetSSHClient( const Value : string );
    procedure SetUserName( const Value : string );
  private
    procedure SetCommand(const Value: string);
    procedure SetCommandParameter(const Value: string);
    procedure SetDestination(const Value: string);
    procedure SetSource(const Value: string);
  public
    /// <summary>
    ///   Set a ssh client exe. Can be in application directory.
    ///   Don't use original path in windows wich is
    ///   c:\windows\system32\Openssh because it won't work with this wrapper!
    ///   Leave blank if ssh.exe is in your application directory or in other searchpath.
    /// </summary>
    property SSHClient : string read FSSHClient write SetSSHClient;
    /// <summary>
    ///   Hostname like www.excample.com or IP address.
    /// </summary>
    property HostName : string read FHostName write SetHostName;
    /// <summary>
    ///   Leave blank if you use standard port 22.
    /// </summary>
    property PortNum : integer read GetPortNum write SetPortNum;
    /// <summary>
    ///   Username on remote host. Needs login access rights.
    /// </summary>
    property UserName : string read FUserName write SetUserName;
    /// <summary>
    ///   Full path of your private key file.
    /// </summary>
    property KeyFile : string read FKeyFile write SetKeyFile;
    /// <summary>
    ///   Command to be run on remote host.
    /// </summary>
    property Command : string read FCommand write SetCommand;
    /// <summary>
    ///   Command line parameter fpr the command to be run on remote host.
    /// </summary>
    property CommandParameter : string read FCommandParameter write SetCommandParameter;
    /// <summary>
    ///   Destination for scp.
    ///   This property is there for testing purpose.
    /// </summary>
    property Source : string read FSource write SetSource;
    /// <summary>
    ///   Destination for scp.
    ///   This property is there for testing purpose.
    /// </summary>
    property Destination : string read FDestination write SetDestination;
    /// <summary>
    ///   Gives the parameter line for command execution.
    ///   Can be used for testing.
    ///   Set properties Source and Destionation first.
    /// </summary>
    function GetCommandParameterLine : string;
    /// <summary>
    ///   Gives the parameter line for copy from remote action.
    ///   Set properties Source and Destionation first.
    ///   Can be used for testing.
    /// </summary>
    function GetSCPToRemoteParameterLine : string;
    /// <summary>
    ///   Gives the parameter line for copy to remote action.
    ///   Set properties Source and Destionation first.
    ///   Can be used for testing.
    /// </summary>
    function GetSCPFromRemoteParameterLine : string;
    /// <summary>
    ///   Send ACommand with AParameter to the remote host.
    ///   All remote settings need to be set first.
    /// </summary>
    function SendCommand( const ACommand : string; const AParameter : string) : integer;
    /// <summary>
    ///   Copy a local ASource to the remote host to ADestination.
    ///   Uses scp. All remote settings need to be set first.
    ///   If ADestination has trailing / then last part is a directory und filename of sourceparameter will copy into it.
    ///   If ADestination has no trailing / then last part will be the new filename as copy destination.
    ///   ASource can contain wildcards. Then give a trailing / as ADestination.
    /// </summary>
    function SCPToRemote( const ASource : string; const ADestination : string)  : integer;
    /// <summary>
    ///   Copy from ASource at remote host to a local ADestination
    ///   All remote settings need to be set first.
    ///   If ADestination has trailing / then last part is a directory und filename of sourceparameter will copy into it.
    ///   If ADestination has no trailing / then last part will be the new filename as copy destination.
    ///   ASource can contain wildcards. Then give a trailing / as ADestination.
    /// </summary>
    function SCPFromRemote( const ASource : string; const ADestination : string) : integer;
  end;



implementation

{ TSSHCommand }

{################################################################################################}

function TSSHCommand.GetPortNum : integer;
begin
  result := FPortNum;
end;

{################################################################################################}

function TSSHCommand.GetSCPFromRemoteParameterLine: string;
begin
  if FPortNum = 0 then FPortNum := 22;
  // scp -P 12322 -i keyfile user@remotehost:/home/user/file1.csv c:\tools\
  result := '-P ' +
            FPortNum.ToString +
            ' -i ' +
            FKeyFile +
            ' ' +
            FUserName +
            '@' +
            FHostName +
            ':' +
            FSource +
            ' ' +
            FDestination;
end;

{################################################################################################}

function TSSHCommand.GetSCPToRemoteParameterLine: string;
begin
  if FPortNum = 0 then FPortNum := 22;
  // scp -P 12322 -i keyfile ASource user@remotehost:ADestination
  result := '-P ' +
            FPortNum.ToString +
            ' -i ' +
            FKeyFile +
            ' ' +
            FSource +
            ' ' +
            FUserName +
            '@' +
            FHostName +
            ':' +
            FDestination;
end;

{################################################################################################}

function TSSHCommand.GetCommandParameterLine : string;
begin
  if FPortNum = 0 then FPortNum := 22;
  // ssh remotehost -p 12322 -i keyfile -l user -t "command commandparameter"
  result := FHostName +
            ' -p ' +
            FPortNum.ToString +
            ' -i ' +
            FKeyFile +
            ' -l ' +
            FUserName +
            ' -t "' +
            FCommand +
            ' ' +
            FCommandParameter + '"';
end;

{################################################################################################}

function TSSHCommand.SCPFromRemote(const ASource, ADestination: string): integer;
var
  LSCPParameterLine : string;
begin
  if FSSHClient.IsEmpty then FSSHClient := 'scp.exe';
  FSource := ASource;
  FDestination := ADestination;
  LSCPParameterLine := GetSCPFromRemoteParameterLine;
  result := ShellExecute( 0, 'open', PCHar( FSSHClient ), PCHar( LSCPParameterLine ), nil, SW_HIDE );
end;

{################################################################################################}

function TSSHCommand.SCPToRemote(const ASource, ADestination: string): integer;
var
  LSCPParameterLine : string;
begin
  if FSSHClient.IsEmpty then FSSHClient := 'scp.exe';
  FSource := ASource;
  FDestination := ADestination;
  LSCPParameterLine := GetSCPToRemoteParameterLine;
  result := ShellExecute( 0, 'open', PCHar( FSSHClient ), PCHar( LSCPParameterLine ), nil, SW_HIDE );
end;

{################################################################################################}

function TSSHCommand.SendCommand ( const ACommand : string; const AParameter : string) : integer;
var
  LCommandWithParameter : string;
begin
  if FSSHClient.IsEmpty then FSSHClient := 'ssh.exe';
  FCommand := ACommand;
  FCommandParameter := AParameter;
  LCommandWithParameter := GetCommandParameterLine;
  result := ShellExecute( 0, 'open', PCHar( FSSHClient ), PCHar( LCommandWithParameter ), nil, SW_HIDE );
end;

{################################################################################################}

procedure TSSHCommand.SetCommand(const Value: string);
begin
  FCommand := Value;
end;

{################################################################################################}
 
procedure TSSHCommand.SetCommandParameter(const Value: string);
begin
  FCommandParameter := Value;
end;

{################################################################################################}

procedure TSSHCommand.SetDestination(const Value: string);
begin
  FDestination := Value;
end;

{################################################################################################}

procedure TSSHCommand.SetHostName( const Value : string );
begin
  FHostName := Value;
end;

{################################################################################################}

procedure TSSHCommand.SetKeyFile( const Value : string );
begin
  FKeyFile := Value;
end;

{################################################################################################}

procedure TSSHCommand.SetPortNum( const Value : integer );
begin
  FPortNum := Value;
end;

{################################################################################################}

procedure TSSHCommand.SetSource(const Value: string);
begin
  FSource := Value;
end;

procedure TSSHCommand.SetSSHClient( const Value : string );
begin
  FSSHClient := Value;
end;

{################################################################################################}

procedure TSSHCommand.SetUserName( const Value : string );
begin
  FUserName := Value;
end;


end.
