import java.util.*;

int boardLength = 13;
int boardWidth = 13;
long totalMoves = 0;
int recursionDepth = 0;
int[][] solutions;
Timer t = new Timer();
KnightsTour kn = new KnightsTour(boardWidth,boardLength,0,0);
Board b = kn.getBoard();
boolean done = false;

void setup() {
  t.startTimer();
  solutions = new int[boardWidth][boardLength];
  for (int i = 0; i < boardWidth; i++) {
    for (int j = 0; j < boardLength; j++) {
      solutions[i][j] = -1;
    }
  }
  solutions[0][0] = 0;
  //kn.newMove(0,0,1);
  //kn.move();
  if (kn.move(0,0,1)) {
    println("found solution");
  } else {
    println("no solution found");
  }
  t.endTimer();
  println("total time elasped = " + t.getTotalTimeInSeconds() + " seconds");
  size(800, 800);
  
}

void draw() {
  background(255);
  b.displayBoardBySolutions(solutions); 
}


class Space {
  private ArrayList<int[]> possibleMoves;
  private int numInSeries;
  private int[] location;
  private ArrayList<Space> possibleSpaces;

  public Space(int x, int y) {
    this.possibleMoves = new ArrayList();
    this.numInSeries = 0;
    this.location = new int[] { x, y }; 
    this.possibleSpaces = new ArrayList<Space>();
  }
  public ArrayList<int[]> getPossibleMoves() {
    
    return this.possibleMoves;
  }
  public void addPossibleMove(int[] move) { 
    this.possibleMoves.add(move);
  }
  public void removePossibleMove(int[] move) { 
    for (int i = 0; i < this.possibleMoves.size(); i++) {
      if (move[0] == this.possibleMoves.get(i)[0] && move[1] == this.possibleMoves.get(i)[1]) {
        this.possibleMoves.remove(i);
      }
    }
  }
  public int getNumInSeries() { 
    return this.numInSeries;
  }
  public void setNumInSeries(int num) { 
    this.numInSeries = num;
  }
  public int getNumPossibleMoves() { 
    return this.possibleMoves.size();
  }
  public int[] getLocation() { return location; }
  public ArrayList<Space> getPossibleSpaces() { return this.possibleSpaces; }
  public Space[] getArrPossibleSpaces() { 
    Space[] spaces = new Space[this.possibleSpaces.size()];
    for (int i = 0; i < possibleSpaces.size(); i++) {
      spaces[i] = possibleSpaces.get(i);
    }
    return spaces;
  }
  public void addPossibleSpace(Space s) { possibleSpaces.add(s); } 
  public void setLocation(int[] loc) { this.location = loc; }
}

class Board {
  private Space[][] board;

  Board(int n, int m) {
    this.board = new Space[n][m];
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        board[i][j] = new Space(i, j);
        board[i][j].setNumInSeries(0);
      }
    }
  }
  /*
  void testSortMoves() {
    ArrayList<Space> spaces = new ArrayList();
    spaces.add( new Space(1,1));
    spaces.add( new Space(2,1));
    spaces.add( new Space(3,1));
    spaces.add( new Space(4,1));
    spaces.add( new Space(4,2));
    spaces.add( new Space(3,3));
    spaces.add( new Space(4,4));
    spaces.add( new Space(7,7));
    Collections.sort(spaces, new SortSpaces());
    ArrayUtil.printSpacesArr(spaces);
  } */
  
  void addMoves() {
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[0].length; j++) {
        if (i+1 < board.length && j-2 > -1) {
          int[] move = new int[] {1, -2};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i+2 < board.length && j-1 > -1) {
          int[] move = new int[] {2, -1};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i+2 <  board.length && j+1 < board[0].length) {
          int[] move = new int[] {2, 1};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i+1 < board.length && j+2 < board[0].length) {
          int[] move = new int[] {1, 2};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i-1 > -1 && j+2 < board[0].length) {
          int[] move = new int[] {-1,2};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i-2 > -1 && j+1 < board[0].length) {
          int[] move = new int[] {-2, 1};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i-2 > -1 && j-1 > -1) {
          int[] move = new int[] {-2, -1};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        if (i-1 > -1 && j-2 > -1) {
          int[] move = new int[] {-1, -2};
          board[i][j].addPossibleMove(move);
          board[i][j].addPossibleSpace(board[i+move[0]][j+move[1]]);
        }
        Collections.sort(board[i][j].getPossibleSpaces(), new SortSpaces());
      }
    }
    
  }
 
  Space[][] getBoard() { 
    return this.board;
  }
  void displayBoard() {
    for (int i = 0; i <= this.board.length; i++) {
      line(0, i*(width/this.board.length), 800, i*(width/this.board.length));
    }
    for (int i = 0; i <= this.board[0].length; i++) {
      line(i*(height/this.board[0].length), 0, i*(height/this.board[0].length), 800);
    }
    for (int i = 0; i < this.board.length; i++) {
      for (int j = 0; j < this.board[0].length; j++) {
        //println("num in series = " + this.board[i][j].getNumInSeries());
        textSize(32);
        fill(0);
        text(board[i][j].getNumInSeries(), (i)*width/this.board.length + (height/this.board[0].length/1.5), (j+1)*height/this.board[0].length);
        text(board[i][j].getNumPossibleMoves(), (i)*width/this.board.length, (j+1)*height/this.board[0].length);
      }
    }
  }
  
  void displayBoardBySolutions(int[][] solutions) {
   for (int i = 0; i <= this.board.length; i++) {
     line(0, i*(width/this.board.length), 800, i*(width/this.board.length));
   }
   for (int i = 0; i <= this.board[0].length; i++) {
     line(i*(height/this.board[0].length), 0, i*(height/this.board[0].length), 800);
   }
   for (int i = 0; i < this.board.length; i++) {
     for (int j = 0; j < this.board[0].length; j++) {
       textSize(32);
       fill(0);
       text(solutions[i][j], (i)*width/this.board.length, (j+1)*height/this.board[0].length);
       }
     }
   }
   
}

class KnightsTour {
  private Board board;
  private Space currentSpace;
  //private int[] currentSpaceLocation;
  //private ArrayList<int[]> prevMoves;
  //private ArrayList<int[]> prohibitedMoves;
  KnightsTour(int n, int m, int x, int y) {
    this.board = new Board(n, m);
    this.board.addMoves();
    this.currentSpace = this.board.getBoard()[x][y];
    this.currentSpace.setNumInSeries(1);
    //this.currentSpaceLocation = new int[] {x, y};
    //this.prevMoves = new ArrayList();
    //this.prohibitedMoves = new ArrayList();
  }
  /*
  void move() {
    recursionDepth++;
    totalMoves++;
    ArrayList<int[]> moves = this.currentSpace.getPossibleMoves();
    //ArrayUtil.printArr(moves);
    //best index is the "Space" with the lowest possible moves
    int bestIndex = -1;
    int bestMoveCount = 8;
    Space bestSpace = null;
    int[] bestSpaceLocation = null;
    for (int i = 0; i < moves.size(); i++) {
      bestSpaceLocation = new int[] { currentSpaceLocation[0] + moves.get(i)[0], currentSpaceLocation[1] + moves.get(i)[1] };
      bestSpace = this.board.getBoard()[bestSpaceLocation[0]][bestSpaceLocation[1]];
      int moveCount = bestSpace.getNumPossibleMoves();
      int moveNumInSeries = bestSpace.getNumInSeries();

      if (moveCount <= bestMoveCount) {
        if ( moveNumInSeries  < 1 ) {
          //println(moveNumInSeries);
          bestMoveCount = moveCount;
          bestIndex = i;
        }
      }
    }
    int pastNumInSeries = this.currentSpace.getNumInSeries();
    //print("moving to position x = " + (currentSpaceLocation[0] + moves.get(bestIndex)[0]));
    //println(", y = " + (currentSpaceLocation[1] + moves.get(bestIndex)[1]));
    if (bestIndex == -1) {
      if(currentSpace.getNumInSeries() == this.board.getBoard().length * this.board.getBoard()[0].length) {
        done = true;
        return;
      }
      //println("Num move = " + currentSpace.getNumInSeries());
      int[] prevMove = new int[] {prevMoves.get(prevMoves.size()-1)[0], prevMoves.get(currentSpace.getNumInSeries()-2)[1]};
      this.currentSpace.setNumInSeries(0);
      
      //println("moving backward from " + currentSpaceLocation[0] + ", " + currentSpaceLocation[1] + " to " + (currentSpaceLocation[0]-prevMoves.get(prevMoves.size()-1)[0]) + ", " + (currentSpaceLocation[1]-prevMoves.get(prevMoves.size()-1)[1]));
      this.currentSpaceLocation = new int[] { currentSpaceLocation[0]-prevMoves.get(prevMoves.size()-1)[0], currentSpaceLocation[1]-prevMoves.get(prevMoves.size()-1)[1] };
      this.currentSpace = this.board.getBoard()[currentSpaceLocation[0]][currentSpaceLocation[1]];
      this.currentSpace.removePossibleMove(prevMove);
      this.prohibitedMoves.add(new int[] { currentSpaceLocation[0], currentSpaceLocation[1], prevMove[0], prevMove[1] });
      //ArrayUtil.printArr(currentSpace.getPossibleMoves());
      this.prevMoves.remove(prevMoves.size()-1);
    } else {
      //println("Num move = " + currentSpace.getNumInSeries());
      //println("moving forward from " + currentSpaceLocation[0] + ", " + currentSpaceLocation[1] + " to " + (currentSpaceLocation[0] + moves.get(bestIndex)[0]) + ", " + (currentSpaceLocation[1]+ moves.get(bestIndex)[1]));
      this.prevMoves.add(moves.get(bestIndex));
      this.currentSpaceLocation = new int[] { currentSpaceLocation[0]+moves.get(bestIndex)[0], currentSpaceLocation[1]+moves.get(bestIndex)[1] };
      this.currentSpace = this.board.getBoard()[currentSpaceLocation[0]][currentSpaceLocation[1]];
      this.currentSpace.setNumInSeries(pastNumInSeries+1);
      
      for (int i = 0; i < this.prohibitedMoves.size()-5; i++) {
        int[] location = new int[] { prohibitedMoves.get(i)[0], prohibitedMoves.get(i)[1] };
        int[] move = new int[] { prohibitedMoves.get(i)[2], prohibitedMoves.get(i)[3] };
        this.board.getBoard()[location[0]] [location[1]].addPossibleMove(move);
        prohibitedMoves.remove(i);
        i--;
      }
      //ArrayUtil.printArr(prevMoves);
      
    }
    if(totalMoves % 100 == 0) {
      //println(totalMoves);
    }
    println(recursionDepth);
    this.move();
    recursionDepth--;
  }
  */
  boolean move(int x, int y, int numInSeries) {
    //this.board.getBoard()[x][y].setNumInSeries(numInSeries);
    //solutions[x][y] = numInSeries;
    
    totalMoves++;
    //if (totalMoves%100000 == 0) {
    //  println("total moves = " + totalMoves);
    //} 
    if (numInSeries == boardWidth*boardLength) {
      println("total moves = " + totalMoves);
      return true;
    }
    //try every possible move from the current space
    for (Space space : board.getBoard()[x][y].getPossibleSpaces()) {
      if(solutions[space.getLocation()[0]][space.getLocation()[1]] == -1) { //test if location has been moved to
        solutions[space.getLocation()[0]][space.getLocation()[1]] = numInSeries; //set numInSeries for solutions array
          if (move(space.getLocation()[0], space.getLocation()[1], numInSeries+1)) { 
            // the only way for one to return true is if the numInSeries = the boardWidth * boardHeight
            // this only happens when the tour is solved, so the tour will end the recursion when true happens once
            return true;
          } else {
            // the path did not produce good results... reset solution numInSeries
            solutions[space.getLocation()[0]][space.getLocation()[1]] = -1;
          }
      }
     
    }
    // no possible solution
    return false;
  }
  Board getBoard() { 
    return this.board;
  }
}

static class ArrayUtil {
  static void printArr(ArrayList<int[]> arr) {
    String r = "";
    for (int i = 0; i < arr.size(); i++) {
      for (int j = 0; j < 2; j++) {
        r += arr.get(i)[j] + ", ";
      }
      r+= "\n";
    }
    println(r);
  }
  static void printIntArr(int[] arr) {
    String r = "";
    for(int i = 0; i < arr.length; i++) {
      r+= arr[i] + ", ";
    }
    println(r);
  }
  static void printSpacesArr(ArrayList<Space> arr) {
    for (int i = 0; i < arr.size(); i++) {
      println("x = " + arr.get(i).getLocation()[0] + ", y = " + arr.get(i).getLocation()[1] + "\n");
    }
  }
}
class SortSpaces implements Comparator<Space> {
  //chooses move that has the fewest possible moves and is closest to the corner
  public int compare(Space a, Space b) {
    if (a.getNumPossibleMoves() - b.getNumPossibleMoves() == 0) {
      double[] distFromCornerA = new double[4];
      double[] distFromCornerB = new double[4];
      distFromCornerA[0] = Math.sqrt((0-a.getLocation()[0])*(0-a.getLocation()[0]) + (0-a.getLocation()[1])*(0-a.getLocation()[1])); 
      distFromCornerA[1] = Math.sqrt((boardWidth-1-a.getLocation()[0])*(boardWidth-1-a.getLocation()[0]) + (0-a.getLocation()[1])*(0-a.getLocation()[1])); 
      distFromCornerA[2] = Math.sqrt((0-a.getLocation()[0])*(0-a.getLocation()[0]) + (boardLength-1-a.getLocation()[1])*(boardLength-1-a.getLocation()[1])); 
      distFromCornerA[3] = Math.sqrt((boardWidth-1-a.getLocation()[0])*(boardWidth-1-a.getLocation()[0]) + (boardLength-1-a.getLocation()[1])*(boardLength-1-a.getLocation()[1])); 
      distFromCornerB[0] = Math.sqrt((0-b.getLocation()[0])*(0-b.getLocation()[0]) + (0-b.getLocation()[1])*(0-b.getLocation()[1])); 
      distFromCornerB[1] = Math.sqrt((boardWidth-1-b.getLocation()[0])*(boardWidth-1-b.getLocation()[0]) + (0-b.getLocation()[1])*(0-b.getLocation()[1])); 
      distFromCornerB[2] = Math.sqrt((0-b.getLocation()[0])*(0-b.getLocation()[0]) + (boardLength-1-b.getLocation()[1])*(boardLength-1-b.getLocation()[1])); 
      distFromCornerB[3] = Math.sqrt((boardWidth-1-b.getLocation()[0])*(boardWidth-1-b.getLocation()[0]) + (boardLength-1-b.getLocation()[1])*(boardLength-1-b.getLocation()[1])); 
      int bestIndexA = 0;
      for(int i = 1; i < distFromCornerA.length; i++) {
        if (Math.abs(distFromCornerA[bestIndexA]) > Math.abs(distFromCornerA[i])) {
          bestIndexA = i;
        }
      }
      int bestIndexB = 0;
      for(int i = 1; i < distFromCornerB.length; i++) {
        if (Math.abs(distFromCornerB[bestIndexB]) > Math.abs(distFromCornerB[i])) {
          bestIndexB = i;
        }
      }
      int dist = (int)(distFromCornerA[bestIndexA] - distFromCornerB[bestIndexB]);
      return dist;
    } else {
      return a.getNumPossibleMoves()-b.getNumPossibleMoves();
    }
  }
}

class Timer {
  private double startTimeInSeconds, endTimeInSeconds, totalTimeInSeconds;
  
  Timer() {
    this.totalTimeInSeconds = 0.0;
  }
  void startTimer() { this.startTimeInSeconds = millis()/1000.0; }
  void endTimer() { 
    this.endTimeInSeconds = millis()/1000.0;
    this.totalTimeInSeconds = endTimeInSeconds - startTimeInSeconds;
  }
  double getTotalTimeInSeconds() { return this.totalTimeInSeconds; }
}
