package sample;

import java.util.ArrayList;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * Created by MOTHERSHIP on 28/3/2016.
 */
public class State {
    public enum GameState{
        PREFLOP, FLOP, TURN, RIVER, GAMEOVER;

        public String asString(){
           switch(this){
                case PREFLOP: return "PREFLOP";
                case FLOP: return "FLOP";
                case TURN: return "TURN";
                case RIVER: return "RIVER";
                case GAMEOVER: return "GAMEOVER";
           }
           return "";
        }
    }

    public enum Type {
        CHECK, RAISE, CALL, FOLD
    }

    public State(){
        lastMove = new Move(Type.CHECK);
        aiMove = new Move(Type.CHECK);
    }

    public class Move{

        public Type type;
        public int payload;

        Move(Type t){
            this.type = t;
            this.payload = 0;
        }

        Move(Type t, int p){
            this.type = t;
            this.payload = p;
        }
    }

    public BlockingQueue<Card> deck;
    public Card[] playerCard = new Card[2];
    public Card[] aiCard = new Card[2];
    public ArrayList<Card> river = new ArrayList<Card>();
    public boolean turn = false; // Is it the player's turn
    public GameState gameState = GameState.GAMEOVER;
    public int playerPot = 0;
    public int aiPot = 0;
    public int playerStack = 1000;
    public int aiStack = 1000;
    public Move lastMove;
    public Move aiMove;
    public double playerWinProbability = 0, aiWinProbability = 0;
}
