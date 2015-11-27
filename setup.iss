; ��� ����������
#define   Name       "Chat"
; ������ ����������
; �����-�����������
#define   Publisher  "TA"
; ��� ������������ ������
#define   ExeName    "Chat.exe"

#define Version GetFileVersion("C:\Users\admin\Desktop\Chat\Chat\bin\Debug\Chat.exe")

;------------------------------------------------------------------------------
;   ��������� ���������
;------------------------------------------------------------------------------

[Setup]

; ���������� ������������� ����������, 
;��������������� ����� Tools -> Generate GUID
AppId={{AC03F9D1-C6E2-4036-97D1-782EC48454D0}

; ������ ����������, ������������ ��� ���������
AppName={#Name}
AppVerName={#ExeName} {#Version}
AppVersion={#Version}

; ���� ��������� ��-���������
DefaultDirName={pf}\{#Name}
; ��� ������ � ���� "����"
DefaultGroupName={#Name}

; �������, ���� ����� ������� ��������� setup � ��� ������������ �����
OutputDir={#SourcePath}
OutputBaseFileName=setup

; ���� ������
;SetupIconFile=D:\icon.ico

; ��������� ������
Compression=lzma
SolidCompression=yes

;------------------------------------------------------------------------------
;   ������������� ����� ��� �������� ���������
;------------------------------------------------------------------------------
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; 

;------------------------------------------------------------------------------
;   ����������� - ��������� ������, ������� ���� ��������� ��� ���������
;------------------------------------------------------------------------------
[Tasks]
; �������� ������ �� ������� �����
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]

; ����������� ����
Source: "C:\Users\admin\Desktop\Chat\Chat\bin\Debug\Chat.exe"; DestDir: "{app}"; Flags: ignoreversion

; ������������� �������
Source: "C:\Users\admin\Desktop\Chat\Chat\bin\Debug\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; .NET Framework
;Source: "D:\NDP453-KB2969351-x86-x64-AllOS-ENU.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Check: not IsRequiredDotNetDetected

;[Icons]

;Name: "{group}\{{Chat}"; Filename: "{app}\{{Chat.exe}"

;Name: "{commondesktop}\{{Chat}"; Filename: "{app}\{{Chat.exe}"; Tasks: desktopicon

;------------------------------------------------------------------------------
;   ������ ���� ���������� �� ���������� �����
;------------------------------------------------------------------------------

[Code]

function IsDotNetDetected(version: string; release: cardinal): boolean;

var 
    reg_key: string;
    success: boolean;
    release45: cardinal;
    key_value: cardinal;
    sub_key: string;

begin 
    success := false;
    reg_key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\';

    if Pos('v4.5', version) = 1 then
      begin 
        sub_key := 'v4\Full';
        reg_key := reg_key + sub_key;
        success := RegQueryDWordValue(HKLM, reg_key, 'Release', release45);
        success := success and (release45 >= release);
      end;

    result := success;
  end;

function IsRequiredDotNetDetected(): boolean;
begin
    result := IsDotNetDetected('v4.5 Full Profile', 0);
end;

function GetUninstallString: string;
var
  sUnInstPath: string;
  sUnInstallString: String;
begin
  Result := '';
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{{AC03F9D1-C6E2-4036-97D1-782EC48454D0}_is1'); //Your App GUID/ID
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade: Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

function InitializeSetup(): boolean;
var
  V: Integer;
  iResultCode: Integer;
  sUnInstallString: string;
begin
  Result := True; 
  if RegValueExists(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Uninstall\{AC03F9D1-C6E2-4036-97D1-782EC48454D0}_is1', 'UninstallString') then  //Your App GUID/ID
  begin
    V := MsgBox(ExpandConstant('Hey! An old version of app was detected. Do you want to uninstall it?'), mbInformation, MB_YESNO); 
    if V = IDYES then
    begin
      sUnInstallString := GetUninstallString();
      sUnInstallString :=  RemoveQuotes(sUnInstallString);
      Exec(ExpandConstant(sUnInstallString), '', '',  SW_SHOW, ewWaitUntilTerminated, iResultCode);
      Result := True; 
    end
    else
      Result := False; 
    end;
    if not IsDotNetDetected('v4.5 Full Profile', 0) then
      begin
        MsgBox('{#Name} requires Microsoft .NET Framework 4.5 Full Profile.'#13#13
             'The installer will attempt to install it', mbInformation, MB_OK);
      end;   

  result := true;
end;
[Run]
;------------------------------------------------------------------------------
;   ������ ������� ����� �����������
;------------------------------------------------------------------------------
Filename: {tmp}\NDP453-KB2969351-x86-x64-AllOS-ENU.exe; Parameters: "/q:a /c:""install /l /q"""; Check: not IsRequiredDotNetDetected; StatusMsg: Microsoft Framework 4.0 is installed. Please wait...