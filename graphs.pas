unit Graphs;

interface

uses LinkedList, RandomInteger, SysUtils;

type
    NodeArray = array of integer;

type
    Pair = array[1..2] of Integer;

type
    EdgeArray = array of Pair;

type
    Graph = Record
        n, m : integer;
        Nodes : NodeArray;
        Edges : EdgeArray;
    end;

type
    List = PNode;

type
    ListArray = array of List;

type
    Matrix = array of array of integer;

type
    StringArray = array of string;

function ReadGraph (n, m : integer) : Graph;
function RandomGraph () : Graph;
procedure PrintGraph (InGraph : Graph);
procedure PrintAdjacencyList (InGraph : Graph);
procedure PrintAdjacencyMatrix (InGraph : Graph);
procedure WriteDotFile (InGraph : Graph; Filename : String);

implementation

function ReadNodes (n : integer) : NodeArray;
    var
        i : integer;
    begin
        ReadNodes := Nil;
        setlength (ReadNodes, n);
        for i := 0 to n - 1 do
            ReadNodes[i] := i + 1;
    end;

function ReadEdges (m : integer) : EdgeArray;
    var
        i : integer;
        Edge : Pair;
    begin
        ReadEdges := Nil;
        setlength (ReadEdges, m);
        for i := 1 to m do
            begin
                writeln ('Edge no.', i);
                readln (Edge[1], Edge[2]);
                ReadEdges[i - 1] := Edge
            end
    end;

function ReadGraph (n, m : integer) : Graph;
    begin
        ReadGraph.n := n;
        ReadGraph.m := m;
        ReadGraph.Nodes := ReadNodes (n);
        ReadGraph.Edges := ReadEdges (m)
    end;

function RandomGraph () : Graph;
    var
        n, m, i, j : integer;
        LocalGraph : Graph;
    begin
        n := RandInt (2, 12);
        LocalGraph.n := n;
        LocalGraph.Nodes := ReadNodes (n);
        setlength (LocalGraph.Edges, (n * (n - 1)) div 2);
        m := 0;
        for i := 0 to n - 2 do
            for j := i + 1 to n - 1 do
                if RandInt (0, 1) = 1 then
                    begin
                        LocalGraph.Edges[m][1] := i + 1;
                        LocalGraph.Edges[m][2] := j + 1;
                        m := m + 1
                    end;
        setlength (LocalGraph.Edges, m);
        LocalGraph.m := m;
        RandomGraph := LocalGraph
    end;

procedure PrintNodes (Nodes : NodeArray; n : integer);
    var
        i : integer;
    begin
        write ('{');
        for i := 0 to n - 1 do
            begin
                write(Nodes[i]);
                if i < n - 1 then
                    write(',')
            end;
        writeln ('}')
    end;

function AdjacencyList (InGraph : Graph) : ListArray;
    var
        i, v1, v2, idx1, idx2 : integer;
        AdjLis : array of List;
    begin
        AdjLis := Nil;
        setlength (AdjLis, InGraph.n);
        for i := 0 to InGraph.n - 1 do
            AdjLis[i] := Nil;
        for i := 0 to InGraph.m - 1 do
            begin
                v1 := InGraph.Edges[i][1];
                v2 := InGraph.Edges[i][2];
                idx1 := v1 - 1;
                idx2 := v2 - 1;
                AdjLis[idx1] := ListInsert(AdjLis[idx1], AdjLis[idx1], v2);
                AdjLis[idx2] := ListInsert(AdjLis[idx2], AdjLis[idx2], v1)
            end;
        AdjacencyList := AdjLis
    end;

function AdjacencyMatrix (InGraph : Graph) : Matrix;
    var
        i, v1, v2 : integer;
        AdjMat : Matrix;
    begin
        AdjMat := Nil;
        setlength (AdjMat, InGraph.n, InGraph.n);
        for i := 0 to InGraph.m - 1 do
            begin
                v1 := InGraph.Edges[i][1];
                v2 := InGraph.Edges[i][2];
                AdjMat[v1 - 1][v2 - 1] := 1;
                AdjMat[v2 - 1][v1 - 1] := 1
            end;
        AdjacencyMatrix := AdjMat
    end;

(* Welch-Powell Coloring Algorithm - Lipschutz Discrete Mathematics *)
function ColorNodes (InGraph : Graph) : StringArray;
    const
        Colors: array[0..6] of string = ('red','orange','yellow','green','blue','indigo','violet');
    var
        i : integer;
    begin
        ColorNodes := Nil;
        setlength (ColorNodes, InGraph.n);
        for i := 0 to InGraph.n - 1 do
            ColorNodes[i] := Concat (IntToStr(i + 1), ' [fillcolor=', Colors[i mod 7], ']');
    end;

procedure PrintEdges (Edges : EdgeArray; m : integer);
    var
        i : integer;
    begin
        write ('{');
        for i := 0 to m - 1 do
            begin
                write ('(',Edges[i][1],',',Edges[i][2],')');
                if i < m - 1 then
                    write (',')
            end;
        writeln ('}')
    end;

procedure PrintGraph (InGraph : Graph);
    begin
        writeln ('n = ', InGraph.n);
        PrintNodes (InGraph.Nodes, InGraph.n);
        writeln ('m = ', InGraph.m);
        PrintEdges (InGraph.Edges, InGraph.m)
    end;

procedure PrintAdjacencyList (InGraph : Graph);
    var
        i : integer;
        AdjLis : ListArray;
    begin
        AdjLis := AdjacencyList (InGraph);
        for i := 0 to InGraph.n - 1 do
            begin
                write (i + 1, ': ');
                PrintList (AdjLis[i])
            end;
        for i := 0 to InGraph.n -1 do
            AdjLis[i] := DestroyList (AdjLis[i])
    end;

procedure PrintAdjacencyMatrix (InGraph : Graph);
    var
        row, col : integer;
        AdjMat : Matrix;
    begin
        AdjMat := AdjacencyMatrix (InGraph);
        for row := 0 to InGraph.n - 1 do
            begin
                for col := 0 to InGraph.n - 1 do
                    write (AdjMat[row][col]:2);
                writeln
            end;
        writeln
    end;

procedure WriteDotFile (InGraph : Graph; Filename : String);
    var
        i, v1, v2 : integer;
        NodeColors : StringArray;
        Outfile : text;
    begin
        NodeColors := ColorNodes (InGraph);
        assign (Outfile, Filename);
        rewrite (Outfile);
        writeln (Outfile, 'graph {');
        writeln (Outfile, 'layout=circo;');
        (* writeln (Outfile, 'node [shape=point]'); *)
        writeln (Outfile, 'node [style=filled]');
        for i := 0 to InGraph.m - 1 do
            begin
                v1 := InGraph.Edges[i][1];
                v2 := InGraph.Edges[i][2];
                writeln (Outfile, v1, ' -- ', v2);
            end;
        for i := 0 to InGraph.n - 1 do
            writeln (Outfile, NodeColors[i]);
        writeln (Outfile, '}');
        close (Outfile);
        writeln ('graph dot data dumped to file ', Filename)
    end;
end.
