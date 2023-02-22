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
function RandomGraph (MinNodes, MaxNodes : integer) : Graph;
procedure PrintGraph (InGraph : Graph);
procedure PrintAdjacencyList (InGraph : Graph);
procedure PrintAdjacencyMatrix (InGraph : Graph);
procedure WriteDotFilePoint (InGraph : Graph; Filename : String);
procedure WriteDotFileColor (InGraph : Graph; Filename : String);

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

function RandomGraph (MinNodes, MaxNodes : integer) : Graph;
    var
        n, m, i, j : integer;
        LocalGraph : Graph;
    begin
        n := RandInt (MinNodes, MaxNodes);
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

procedure DestroyAdjacencyList (AdjLis : ListArray; n : integer);
    var
        i : integer;
    begin
        for i := 0 to n - 1 do
            AdjLis[i] := DestroyList (AdjLis[i]);
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

function Degree (v : integer; AdjLis : ListArray) : integer;
    begin
        Degree := ListLength (Adjlis[v - 1])
    end;

function Neighbors (v : integer; AdjLis : ListArray) : List;
    begin
        Neighbors := AdjLis[v - 1]
    end;

function Adjacent (v1, v2 : integer; AdjLis : ListArray) : boolean;
    begin
        Adjacent := ListFind (AdjLis[v1 - 1], v2)
    end;

function AnyAdjacent (v : integer; Nodes : List; AdjLis : ListArray) : boolean;
    var
        Curr : List;
    begin
        Curr := Nodes;
        while (Curr <> Nil) do
            begin
                if Adjacent (v, Curr^.Data, AdjLis) then
                    begin
                        AnyAdjacent := True;
                        exit
                    end;
                Curr := Curr^.Next
            end;
        AnyAdjacent := False
    end;

(* Welch-Powell Coloring Algorithm - Lipschutz Discrete Mathematics *)
(* Very inefficient, but built by myself. *)
(* "I should rather do something poorly by myself than have it done for
* me well." -Grover Cleveland *)
function ColorNodes (InGraph : Graph) : StringArray;
    const
        Colors: array[0..6] of string = ('red','orange','yellow','green','blue','indigo','violet');
    var
        i, n, Node, ColorIdx : integer;
        ColorQueue, NodeList, NonAdjacent, ThisColor, Curr : List;
        AdjLis : ListArray;
    begin
        n := InGraph.n;
        AdjLis := AdjacencyList (InGraph);
        ColorNodes := Nil;
        setlength (ColorNodes, n);
        NodeList := Nil;
        for i := 1 to n do
            NodeList := ListAppend (NodeList, NodeList, i);
        ColorQueue := Nil;
        for i := 0 to 6 do
            ColorQueue := ListAppend(ColorQueue, ColorQueue, i);
        while (ColorQueue <> Nil) and (NodeList <> Nil) do
            begin
                (* writeln ('ColorQueue');
                PrintList (ColorQueue);
                writeln ('NodeList');
                PrintList (NodeList); *)
                ColorIdx := ListPop (ColorQueue);
                (* find non-neighbor nodes *)
                Node := NodeList^.Data;
                ThisColor := Nil;
                NonAdjacent := Nil;
                NonAdjacent := ListAppend(NonAdjacent, NonAdjacent, Node);
                Curr := NodeList;
                while (Curr <> Nil) do
                    begin
                        if not Adjacent (Node, Curr^.Data, AdjLis) then
                            NonAdjacent := ListAppend (NonAdjacent, NonAdjacent, Curr^.Data);
                        Curr := Curr^.Next
                    end;
                NonAdjacent := ListRemove (NonAdjacent, NonAdjacent, Node);
                (* now check if can be assigned to Node non-neighbors *)
                (* writeln ('NonAdjacent');
                PrintList (NonAdjacent); *)
                Curr := NonAdjacent;
                while (Curr <> Nil) do
                    begin
                        if not AnyAdjacent (Curr^.Data, ThisColor, AdjLis) then
                            ThisColor := ListAppend (ThisColor, ThisColor, Curr^.Data);
                        Curr := Curr^.Next
                    end;
                (* writeln ('ThisColor');
                PrintList (ThisColor); *)
                (* Now assign current color to nodes and remove said
                * nodes *)
                Curr := ThisColor;
                while (Curr <> Nil) and (NodeList <> Nil) do
                    begin
                        ColorNodes[Curr^.Data - 1] := Colors[ColorIdx];
                        NodeList := ListRemove(NodeList, Nodelist, Curr^.Data);
                        Curr := Curr^.Next
                    end;
                ThisColor := DestroyList (ThisColor);
                NonAdjacent := DestroyList (NonAdjacent);
            end;

        if (ColorQueue <> Nil) then
            ColorQueue := DestroyList (ColorQueue);
        DestroyAdjacencyList (AdjLis, n);
        (* writeln ('ColorNodes');
        for i := 0 to n - 1 do
            writeln (i + 1, ': ', ColorNodes[i]); *)

        for i := 0 to n - 1 do
            ColorNodes[i] := Concat (IntToStr(i + 1), ' [fillcolor=', ColorNodes[i], ']');
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

procedure WriteDotFilePoint (InGraph : Graph; Filename : String);
    var
        i, v1, v2 : integer;
        Outfile : text;
    begin
        assign (Outfile, Filename);
        rewrite (Outfile);
        writeln (Outfile, 'graph {');
        writeln (Outfile, 'layout=circo;');
        writeln (Outfile, 'node [shape=point]');
        for i := 0 to InGraph.m - 1 do
            begin
                v1 := InGraph.Edges[i][1];
                v2 := InGraph.Edges[i][2];
                writeln (Outfile, v1, ' -- ', v2);
            end;
        writeln (Outfile, '}');
        close (Outfile);
        writeln ('graph dot data dumped to file ', Filename)
    end;

procedure WriteDotFileColor (InGraph : Graph; Filename : String);
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
