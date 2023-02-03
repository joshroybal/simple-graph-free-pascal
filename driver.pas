program Driver;

uses LinkedList, RandomInteger;

type 
  AdjacencyList = array[1..8] of PNode;

var
  n, i, j : Integer;
  Graph : AdjacencyList;
  OutFile : Text;
  
begin
  Randomize;
  n := RandomInteger.RandomInteger (3, 8);
  for i := 0 to n - 1 do
    begin
      Graph[i] := Nil;
      for j := 0 to n - 1 do
        if j <> i then
          Graph[i] := ListAdd(Graph[i], j);
      Graph[i] := ReverseList (Graph[i], Nil)
    end;
  for i := 0 to n - 1 do
  begin
      write (i, ': ');
      PrintList (Graph[i])
    end;
  for i := 0 to n - 1 do
    Graph[i] := DestroyList (Graph[i]);
  assign (OutFile, 'graph.gv');
  rewrite (OutFile);
  writeln (OutFile, 'graph { layout=circo;');
  writeln (OutFile, ' node [ shape=point ]');
  for i := 1 to n - 1 do
    for j := i + 1 to n do
      writeln (OutFile, i, ' -- ', j);
  writeln (OutFile, '}');
  close (OutFile)
end.
