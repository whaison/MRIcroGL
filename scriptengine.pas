unit scriptengine;
{$include opts.inc}
{$H+}
{$D-,O+,Q-,R-,S-}
interface
{$IFDEF FPC} {$mode delphi}{$H+} {$ENDIF}
uses
{$IFDEF FPC}LResources,
{$ELSE}
    Windows,
{$ENDIF}
{$IFDEF Unix} LCLIntf,  {$ENDIF}    //Messages,
 //{$IFNDEF USETRANSFERTEXTURE}  scaleimageintensity,{$ENDIF}
ClipBrd, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, define_types, Menus,
  uPSComponent,commandsu;

(*OVERLAYLOADCLUSTER (lFilename: string; lThreshold, lClusterMM3: single; lSaveToDisk: boolean): integer; Will add the overlay named filename, only display voxels with intensity greater than threshold with a cluster volume greater than clusterMM and return the number of the overlay.

142211*)

type

  { TScriptForm }
  TScriptForm = class(TForm)

    MRU10: TMenuItem;
    MRU9: TMenuItem;
    MRU8: TMenuItem;
    MRU7: TMenuItem;
    MRU6: TMenuItem;
    MRU5: TMenuItem;
    MRU4: TMenuItem;
    MRU3: TMenuItem;
    MRU2: TMenuItem;
    MRU1: TMenuItem;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Memo2: TMemo;
    ScriptMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Insert1: TMenuItem;
    Forms1: TMenuItem;
    clipformvisible1: TMenuItem;
    colorbarformvisible1: TMenuItem;
    contrastformvisible1: TMenuItem;
    cutoutformvisible1: TMenuItem;
    edgeenhanceformvisible1: TMenuItem;
    mosaicformvisible1: TMenuItem;
    overlayformvisible1: TMenuItem;
    scriptformvisible1: TMenuItem;
    toolformvisible1: TMenuItem;
    Colorbar1: TMenuItem;
    colorbarvisible1: TMenuItem;
    colorbarcoord1: TMenuItem;
    colorbartext1: TMenuItem;
    Contrast1: TMenuItem;
    setcolortable1: TMenuItem;
    changenode1: TMenuItem;
    addnode1: TMenuItem;
    contrastminmax1: TMenuItem;
    colorname1: TMenuItem;
    edgedetect1: TMenuItem;
    Dialogs1: TMenuItem;
    modalmessage1: TMenuItem;
    modelessmessage1: TMenuItem;
    Overlays1: TMenuItem;
    overlayload1: TMenuItem;
    overlaycloseall1: TMenuItem;
    overlaycolornumber1: TMenuItem;
    overlaycolorname1: TMenuItem;
    overlayminmax1: TMenuItem;
    overlaytransparencyonbackground1: TMenuItem;
    overlaytransparencyonoverlay1: TMenuItem;
    overlaycolorfromzero1: TMenuItem;
    overlayloadsmooth1: TMenuItem;
    overlaymaskedbybackground1: TMenuItem;
    overlayvisible1: TMenuItem;
    Shaders1: TMenuItem;
    shadername1: TMenuItem;
    shaderlightazimuthelevation1: TMenuItem;
    shaderadjust1: TMenuItem;
    shaderquality1to101: TMenuItem;
    shaderupdategradients1: TMenuItem;
    Sliceviews1: TMenuItem;
    orthoview1: TMenuItem;
    mosaic1: TMenuItem;
    slicetext1: TMenuItem;
    Render1: TMenuItem;
    azimuth1: TMenuItem;
    cameradistance1: TMenuItem;
    clip1: TMenuItem;
    clipazimuthelevation1: TMenuItem;
    cutout1: TMenuItem;
    edgeenhance1: TMenuItem;
    elevation1: TMenuItem;
    framevisible1: TMenuItem;
    maximumintensity1: TMenuItem;
    perspective1: TMenuItem;
    viewaxial1: TMenuItem;
    viewcoronal1: TMenuItem;
    viewsagittal1: TMenuItem;
    loadimage1: TMenuItem;
    savebmp1: TMenuItem;
    wait1: TMenuItem;
    backcolor1: TMenuItem;
    resetdefaults1: TMenuItem;
    Toosl1: TMenuItem;
    Compile1: TMenuItem;
    N2: TMenuItem;
    Stop1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PSScript1: TPSScript;
    extract1: TMenuItem;
    azimuthelevation1: TMenuItem;
    xbarcolor1: TMenuItem;
    xbarthick1: TMenuItem;
    overlayloadcluster1: TMenuItem;
    procedure Compile1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    function OpenScript(lFilename: string): boolean;
    function OpenParamScript: boolean;
    function OpenStartupScript: boolean;
    procedure Memo1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Stop1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure OpenSMRU(Sender: TObject);//open template or MRU
    procedure UpdateSMRU;
    procedure ToPascal(s: string);
    procedure InsertCommand(Sender: TObject);
    //procedure AdjustSelText;
    procedure PSScript1Compile(Sender: TPSScript);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure DemoProgram;
  private
    fn: string;
    gchanged: Boolean;
    function SaveTest: Boolean;
  public
    { Public declarations }
  end;
const
  kScriptExt = '.gls';
 kScriptFilter = 'NIfTI ('+kScriptExt+')|'+kScriptExt;
var
  ScriptForm: TScriptForm;

implementation
uses
    mainunit,userdir, prefs  ;
{$IFDEF FPC} {$R *.lfm}   {$ENDIF}
{$IFNDEF FPC}
{$R *.DFM}
{$ENDIF}
procedure TScriptForm.DemoProgram;
begin
Memo1.lines.clear;
//Memo1.lines.Add('PROGRAM Demo;');
Memo1.lines.Add('BEGIN');
Memo1.lines.Add('//Insert commands here...');
Memo1.lines.Add('');
Memo1.lines.Add('END.');
{$IFDEF UNIX}
Memo1.SelStart := 32;
{$ELSE}
Memo1.SelStart := 34;//windows uses CR+LF line ends, UNIX uses LF
{$ENDIF}
//p.X := 2;
//p.Y := 2;
//Memo1.CaretPos := p;
//Memo1.CaretPos := Point(2,2);
end;

procedure MyWriteln(const s: string);
begin
  ScriptForm.Memo2.lines.add(S);
end;

function ScriptDir: string;
begin
  result := AppDir+'script'
  //with latest versions of Darwin I store scripts in same folder
  //result := ExeDir+'script'
end;

procedure TScriptForm.OpenSMRU(Sender: TObject);//open template or MRU
//Templates have tag set to 0, Most-Recently-Used items have tag set to position in gMRUstr
begin
  if Sender = nil then begin
    if (gPrefs.PrevScriptName[1] <> '') and (Fileexists(gPrefs.PrevScriptName[1])) then
      OpenScript (gPrefs.PrevScriptName[1]);
  end else begin
    OpenScript (gPrefs.PrevScriptName[(Sender as TMenuItem).tag]);
    Compile1Click(Sender);
  end;
end;

procedure TScriptForm.UpdateSMRU;
const

     kMenuItems = 6;//with OSX users quit from application menu
var
  lPos,lN,lM : integer;
begin
 lN := File1.Count-kMenuItems;
 if lN > knMRU then
    lN := knMRU;
 lM := kMenuItems;
  for lPos :=  1 to lN do begin
      if gPrefs.PrevScriptName[lPos] <> '' then begin
          File1.Items[lM].Caption :=ExtractFileName(gPrefs.PrevScriptName[lPos]);//(ParseFileName(ExtractFileName(lFName)));
	  File1.Items[lM].Tag := lPos;
          File1.Items[lM].onclick :=  OpenSMRU; //Lazarus
          File1.Items[lM].Visible := true;
          if lPos < 10 then
          {$IFDEF Darwin}
                  File1.Items[lM].ShortCut := ShortCut(Word('1')+ord(lPos-1), [ssMeta]);
          {$ELSE}
                 File1.Items[lM].ShortCut := ShortCut(Word('1')+ord(lPos-1), [ssCtrl]);
          {$ENDIF}
      end else
          File1.Items[lM].Visible := false;
      inc(lM);
  end;//for each MRU
end;  //UpdateMRU

procedure TScriptForm.PSScript1Compile(Sender: TPSScript);
var
   i: integer;
begin
  //Sender.AddFunction( @TScriptForm.MyWriteln,'procedure Writeln(const s: string);');
  Sender.AddFunction(@MyWriteln, 'procedure Writeln(s: string);');
  for i := 1 to knFunc do
      Sender.AddFunction(kFuncRA[i].Ptr,'function '+kFuncRA[i].Decl+kFuncRA[i].Vars+';');
  for i := 1 to knProc do
      Sender.AddFunction(kProcRA[i].Ptr,'procedure '+kProcRA[i].Decl+kProcRA[i].Vars+':');
end;

procedure TScriptForm.Compile1Click(Sender: TObject);
var
  i: integer;
  compiled: boolean;
begin
  Memo2.Lines.Clear;
  PSScript1.Script.Text := Memo1.Lines.Text;
  //PSScript1.Script.Text := Memo1.Lines.GetText; //<- this will leak! requires StrDispose
  Compiled := PSScript1.Compile;
  for i := 0 to PSScript1.CompilerMessageCount -1 do
    MyWriteln( PSScript1.CompilerMessages[i].MessageToString);
  if Compiled then
    MyWriteln('Successfully Compiled Script');
  if Compiled then begin
    if PSScript1.Execute then
      MyWriteln('Succesfully Executed')
    else
      MyWriteln('Error while executing script: '+
    PSScript1.ExecErrorToString);
    VideoEnd;
  end;
end;



procedure TScriptForm.FormCreate(Sender: TObject);
begin
  //writeln('Create scriptForm');
  fn := '';
  gchanged := False;
  DemoProgram;
  FillMRU (gPrefs.PrevScriptName, ScriptDir+pathdelim,kScriptExt,True);
  //FillMRU (gPrefs.PrevScriptName, ScriptDir+pathdelim,kScriptExt,True);
  UpdateSMRU;
  OpenSMRU(nil);
  OpenDialog1.InitialDir := ScriptDir;
  SaveDialog1.InitialDir := ScriptDir;
 {$IFDEF Darwin}
        Cut1.ShortCut := ShortCut(Word('X'), [ssMeta]);
        Copy1.ShortCut := ShortCut(Word('C'), [ssMeta]);
        Paste1.ShortCut := ShortCut(Word('V'), [ssMeta]);

        Stop1.ShortCut := ShortCut(Word('H'), [ssMeta]);
         Compile1.ShortCut := ShortCut(Word('R'), [ssMeta]);
 {$ENDIF}
end;

function TScriptForm.SaveTest: Boolean;
begin
  result := True;
(*  if changed then
  begin
    case MessageDlg('File is not saved, save now?', mtWarning, mbYesNoCancel, 0) of
      mrYes:
        begin
          Save1Click(nil);
          Result := not changed;
        end;
      mrNo: Result := True;
    else
      Result := False;
    end;
  end
  else
    Result := True;
*)
end;


function TScriptForm.OpenScript(lFilename: string): boolean;
begin
  result := false;
  GLForm1.StopTimers;
  ScriptForm.Stop1Click(nil);
  if not fileexists (lFilename) then begin
    Showmessage('Can not find '+lFilename);
    exit;
  end;
  ScriptForm.Hint := parsefilename(extractfilename(lFilename));
  ScriptForm.Caption := 'Script loaded: '+ScriptForm.Hint;
  Memo1.Lines.LoadFromFile(lFileName);
    gchanged := False;
    Memo2.Lines.Clear;
    fn := lFileName;
   (* Add2MRU(gPrefs.PrevScriptName,fn);
    UpdateSMRU;*)
    result := true;

end;

function EndsStr( const Needle, Haystack : string ) : Boolean;
//http://www.delphibasics.co.uk/RTL.asp?Name=AnsiEndsStr
var
  szN,szH: integer;
  s : string;
begin
  result := false;
  szH := length(Haystack);
  szN := length(Needle);
  if szN > szH then exit;
  s := copy ( Haystack,  szH-szN + 1, szN );
  if comparestr(Needle,s) = 0 then result := true;
end;

function isNewLine(s: string): boolean;
var
  sz: integer;
begin
  result := false;
  sz := length(s);
  if sz < 1 then exit;
  result := true;
  if s[sz] = ';' then exit;
  if EndsStr('var', s) then exit;
  if EndsStr('begin', s) then exit;
  result := false;
end;

procedure TScriptForm.ToPascal(s: string);
var
  i: integer;
  l: string;
begin
  if length(s) < 1 then exit;
  Memo1.lines.Clear;
  l := '';
  for i := 1 to length(s) do begin
      l := l + s[i];
      if isNewLine(l) then begin
        Memo1.lines.Add(l);
        l := '';
      end;
  end;
  Memo1.lines.Add(l);
end;

function TScriptForm.OpenParamScript: boolean;
begin
     result := false;
     if gPrefs.initScript = '' then  exit;
     //FillMRU (gPrefs.PrevScriptName, ScriptDir+pathdelim,kScriptExt,True);
     if FileExists(gPrefs.initScript) or (UpCaseExt(gPrefs.initScript) = uppercase(kScriptExt))  then begin
       if not FileExists(gPrefs.initScript) then
          gPrefs.initScript := ScriptDir +pathdelim+gPrefs.initScript;
       result := OpenScript(gPrefs.initScript);
       if not result then
          writeln('Unable to find '+ gPrefs.initScript);
     end else begin
       ToPascal(gPrefs.initScript);//Memo1.Lines.Add(gPrefs.initScript);
       result := true;
     end;

end;

function TScriptForm.OpenStartupScript: boolean;
var
  lF: string;
begin
  result := false;
  lF := ScriptDir +pathdelim+'startup'+kScriptExt;
  if fileexists(lF) then
    result := OpenScript(lF);
  //if result then
  //  Compile1Click(nil);

end;

procedure TScriptForm.Open1Click(Sender: TObject);
var
   lS: string;
begin
  if not SaveTest then
    exit;
  lS :=  GetCurrentDir;
  if not OpenDialog1.Execute then
    exit;
   SetCurrentDir(lS);
  OpenScript(OpenDialog1.FileName);
end;


procedure TScriptForm.Save1Click(Sender: TObject);
begin
  if fn = '' then
    Saveas1Click(nil)
  else begin
    Memo1.Lines.SaveToFile(fn);
    gchanged := False;
    Add2MRU(gPrefs.PrevScriptName,fn);
    UpdateSMRU;
  end;
end;

procedure TScriptForm.SaveAs1Click(Sender: TObject);
begin
  SaveDialog1.FileName := '';
  if not SaveDialog1.Execute then
    exit;
  fn := SaveDialog1.FileName;
  Memo1.Lines.SaveToFile(fn);
  gchanged := False;
  Add2MRU(gPrefs.PrevScriptName,fn);
  UpdateSMRU;
end;

procedure TScriptForm.Memo1Change(Sender: TObject);
begin
     inherited;
  gchanged := True;
end;

procedure TScriptForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := SaveTest;
end;

procedure TScriptForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TScriptForm.Stop1Click(Sender: TObject);
begin
  if PSScript1.Running then
    PSScript1.Stop;
end;

procedure TScriptForm.New1Click(Sender: TObject);
begin
  GLForm1.StopTimers;
  ScriptForm.Stop1Click(nil);
  if not SaveTest then
    exit;
  Memo2.Lines.Clear;
  fn := '';
  DemoProgram;
end;

procedure CleanStr (var lStr: string);
//remove symbols, set upcase...
var
  lLen,lPos: integer;
  lS: string;
begin
  lLen := length(lStr);
  if lLen < 1 then
    exit;
  lS := '';
  for lPos := 1 to lLen do
    if lStr[lPos] in ['0'..'9','a'..'z','A'..'Z'] then
      lS := lS + upcase(lStr[lPos]);
    lStr := lS;
end;


function TypeStr (lType: integer): string;
var
  lTStr,lStr : string;
  i,n,len,lLoop,lT: integer;//1=boolean,2=integer,3=float,4=string[filename]

begin
  result := '';
  if lType = 0 then
    exit;
  lTStr := inttostr(lType);
  lStr := '(';
  len := length(lTStr);
  i := 1;
  while i <= len do begin
    if i = len then
      n := 1
    else begin
      n := strtoint(lTStr[i]);
      inc(i);
    end;
    lT := strtoint(lTStr[i]);
    inc(i);
    for lLoop := 1 to n do begin
      case lT of
        1:  lStr := lStr +'true';
        2:  lStr := lStr +'1';
        3:  begin
            if lLoop <= 3 then //for Cutout view, we need six values - make them different so this is a sensible cutout
              lStr := lStr +'0.5'
            else
              lStr := lStr +'1.0';
            end;
        4:  lStr := lStr +'''filename''';
        5: lStr := lStr + '''0.2 0.4 0.6; 0.8 S 0.5''';
        6: begin //byte
            if lLoop <= 3 then //for Cutout view, we need six values - make them different so this is a sensible cutout
              lStr := lStr +'1'
            else
              lStr := lStr +'255';
            end;
        7: lStr := lStr +'5';//kludge - make integer where 1 is not a good default, e.g. shaderquality
        else lStr := lStr + '''?''';
      end;//case
      if lLoop < n then
        lStr := lStr+', ';
    end;//for each loop
    if i < len then
        lStr := lStr+', ';
  end;
  lStr := lStr + ')';
  result := lStr;
end;

procedure TScriptForm.InsertCommand(Sender: TObject);
var
  lStr: string;
begin
  lStr := (Sender as TMenuItem).Hint;
  if lStr <> '' then begin
          Memo2.Lines.Clear;

          Memo2.Lines.Add(lStr);
  end;
  lStr := (Sender as TMenuItem).Caption;
  CleanStr(lStr);
  lStr := lStr+TypeStr((Sender as TMenuItem).Tag)+ ';';
  Clipboard.AsText := lStr;
  {$IFDEF UNIX}
  Memo1.SelText := (lStr)+ UNIXeoln;
  {$ELSE}
  Memo1.SelText := (lStr)+ #13#10;
  {$ENDIF}
end;


procedure TScriptForm.Memo1Click(Sender: TObject);
var lPos : TPoint;
begin
  inherited;
  lPos := Memo1.CaretPos; //+1 as indexed from zero
  caption := ScriptForm.Hint +'  '+inttostr(lPos.Y+1)+':'+inttostr(lPos.X+1);
end;

procedure TScriptForm.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Memo1Click(nil);
    inherited;
end;

procedure TScriptForm.Copy1Click(Sender: TObject);
begin
  if length(Memo1.SelText) < 1 then
    Memo1.SelectAll;
  //Clipboard.AsText := Memo1.SelText;
  Memo1.CopyToClipboard;
end;

procedure TScriptForm.Cut1Click(Sender: TObject);
begin
  if length(Memo1.SelText) < 1 then
    Memo1.SelectAll;
  Memo1.CutToClipboard;
end;

procedure TScriptForm.Paste1Click(Sender: TObject);
begin
  Memo1.PasteFromClipboard;
end;

initialization
{$IFDEF FPC}
 //   {$I scriptengine.lrs}
{$ENDIF}
end.
