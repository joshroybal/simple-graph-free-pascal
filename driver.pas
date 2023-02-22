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
    RndGraph := RandomGraph ();
    PrintGraph (RndGraph);
    PrintAdjacencyList (RndGraph);
    PrintAdjacencyMatrix (RndGraph);
    WriteDotFile (RndGraph, 'randgraph.gv');
end.
