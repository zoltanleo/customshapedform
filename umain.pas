unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Windows, JwaWindows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, ComCtrls;

type

  { TfMain }

  TfMain = class(TForm)
    im: TImage;
    miClose: TMenuItem;
    pm: TPopupMenu;
    procedure FormShow(Sender: TObject);
    procedure imMouseDown(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);
    procedure imMouseMove(Sender: TObject; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure imMouseUp(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure miCloseClick(Sender: TObject);
  private
    DX, DY: Integer;
    MoveForm: Boolean;
    procedure MakeTransparentWindow;
    { private declarations }
  public
    { public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.lfm}

{ TfMain }

procedure TfMain.FormShow(Sender: TObject);
begin
  MakeTransparentWindow;
end;

procedure TfMain.MakeTransparentWindow;
var
  BlendFunction: TBlendFunction;
  Size: TSize;
  P: TPoint;
  ExStyle: DWORD;
begin
  ExStyle := GetWindowLongA(Handle, GWL_EXSTYLE);
  if (ExStyle and WS_EX_LAYERED = 0) then
    SetWindowLong(Handle, GWL_EXSTYLE, ExStyle or WS_EX_LAYERED);
  ClientWidth := im.picture.Bitmap.Width;
  ClientHeight := im.picture.Bitmap.Height;
  P.x := 0;
  P.y := 0;
  Size.cx := im.picture.Bitmap.Width;
  Size.cy := im.picture.Bitmap.Height;
  BlendFunction.BlendOp := AC_SRC_OVER;
  BlendFunction.BlendFlags := 0;
  BlendFunction.SourceConstantAlpha := 255;
  BlendFunction.AlphaFormat := AC_SRC_ALPHA;
  UpdateLayeredWindow(Handle, 0, nil, @Size, im.picture.Bitmap.Canvas.Handle, @P, 0, @BlendFunction, ULW_ALPHA);
end;

procedure TfMain.imMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DX := X;
  DY := Y;
  MoveForm := True;
end;

procedure TfMain.imMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 if not MoveForm then
   Exit;
 if (ssLeft in Shift) then
 begin
   fMain.Left := fMain.Left + (X - DX);
   fMain.Top := fMain.Top + (Y - DY);
  end;
end;

procedure TfMain.imMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MoveForm := False;
end;

procedure TfMain.miCloseClick(Sender: TObject);
begin
  Close;
end;

end.

