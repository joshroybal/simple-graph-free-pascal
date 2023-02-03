unit LinkedList;

interface

type 
  Node = Record
    Data: Integer;
    Next : ^Node
  end;
  PNode = ^Node;

function ListAdd (Head : PNode; Payload : Integer) : PNode;
function ListAppend (Head, Next : PNode; Payload : Integer) : PNode;
function ListInsert (Head, Next : PNode; Payload : Integer) : PNode;
function ListPop (var Head : PNode) : Integer;
function ReverseList (Head, Prev : PNode) : PNode;
function DestroyList (Head : PNode) : PNode;
procedure PrintList (Head : PNode);

implementation

function InitializeNode (Payload : Integer) : PNode;
  var
    Node : PNode;
  begin
    New (Node);
    Node^.Data := Payload;
    Node^.Next := Nil;
    InitializeNode := Node
  end;

function ListAdd (Head : PNode; Payload : Integer) : PNode;
  var
    NewNode : PNode;
  begin
    NewNode := InitializeNode (Payload);
    NewNode^.Next := Head;
    ListAdd := NewNode
  end;

function ListAppend (Head, Next : PNode; Payload : Integer) : PNode;
  begin
    if Head = Nil then
      begin
        Head := InitializeNode (Payload);
        exit (Head)
      end;
    if Next^.Next = Nil then
      begin
        Next^.Next := InitializeNode (Payload);
        exit (Head)
      end;
    ListAppend := ListAppend (Head, Next^.Next, Payload)
  end;

function ListInsert (Head, Next : PNode; Payload : Integer) : PNode;
  var
    NewNode, Tag : PNode;
  begin
    if (Head = Nil) or (Payload < Head^.Data) then (* head node *)
      begin
        NewNode := InitializeNode (Payload);
        NewNode^.Next := Head;
        exit (NewNode)
      end;
    if Next^.Next = Nil then (* tail node *)
      begin
        NewNode := InitializeNode (Payload);
        Next^.Next := NewNode;
        exit (Head)
      end;
    if Payload < Next^.Next^.Data then
      begin
        Tag := Next^.Next;
        NewNode := InitializeNode (Payload);
        Next^.Next := NewNode;
        NewNode^.Next := Tag;
        exit (Head)
      end;
      ListInsert := ListInsert (Head, Next^.Next, Payload)
  end;

function ListPop (var Head : PNode) : Integer;
  var
    Item : Integer;
    OldHead : PNode;
  begin
    OldHead := Head;
    Item := OldHead^.Data;
    Head := OldHead^.Next;
    dispose (OldHead);
    ListPop := Item
  end;

function ReverseList (Head, Prev : PNode) : PNode;
  var
    Body : PNode;
  begin
    if Head = Nil then
      exit (Prev);
    Body := Head^.Next;
    Head^.Next := Prev;
    ReverseList := ReverseList (Body, Head)
  end;

function DestroyList (Head : PNode) : PNode;
  var
    Tag : PNode;
  begin
    if Head = Nil then
      exit (Nil);
    Tag := Head^.Next;
    Dispose (Head);
    DestroyList := DestroyList (Tag)
  end;

procedure PrintList (Head : PNode);
  begin
    if Head^.Next = Nil then
      begin
        writeln (Head^.Data);
        exit
      end;
    write (Head^.Data, ', ');
    PrintList (Head^.Next)
  end;
end.
