program Driver;

uses Graphs;

var
    (* n, m: Integer; *)
    RndGraph : Graph;

begin
    (* write ('no of vertices: ');
    readln (n);
    write('no. of edges: ');
    readln (m);
    MyGraph := ReadGraph (n, m);
    PrintGraph (MyGraph);
    PrintAdjacencyList (MyGraph);
    PrintAdjacencyMatrix (MyGraph);
    WriteDotFile (MyGraph, 'graph.gv'); *)
    Randomize;
    RndGraph := RandomGraph (3, 12);
    PrintGraph (RndGraph);
    PrintAdjacencyList (RndGraph);
    PrintAdjacencyMatrix (RndGraph);
    WriteDotFilePoint (RndGraph, 'point.gv');
    WriteDotFileColor (RndGraph, 'color.gv');
end.
