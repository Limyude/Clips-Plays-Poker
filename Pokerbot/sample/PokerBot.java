package sample;

import net.sf.clipsrules.jni.*;
import sample.State;
import sample.State.Move;

public class PokerBot {
  private Environment clips;
  private String clipsFile;
  private String name;

  /*
  ; ; Clear the working memory of everything
  (clear)

  ; ; constants.clp -> CPP.clp order should be retained to properly export stuff (exports/imports happen at the end of CPP.clp)
  (load constants.clp)
  (load CPP.clp)

  ; ; Load all modules
  (load opponent-playstyle-determination.clp)
  (load own-hand-determination.clp)
  (load strategy-selection.clp)
  (load possible-move-determination.clp)
  (load move-selection.clp)

  ; ; Insert the facts and rules into working memory, and run it!
  (reset)
  (run)

  */

  public PokerBot(String filename){
    clipsFile = filename;
    clips = new Environment();
    loadResources();
    name = filename;
  }

  public void resetAi(String filename){
    clipsFile = filename;
    clips = new Environment();
    loadResources();
    name = filename;
  }

  public void loadResources(){
    // clips.load("PokerBot.clp");
    clips.load("bot_files/ALL.clp");
    // clips.load("bot_files/CPP.clp");
    // clips.load("bot_files/opponent-playstyle-determination.clp");
    // clips.load("bot_files/own-hand-determination.clp");
    // clips.load("bot_files/strategy-selection.clp");
    // clips.load("bot_files/possible-move-determination.clp");
    // clips.load("bot_files/move-selection.clp");
  }

  public State play(State gameState){
    System.out.println("PokerBot Play in Progress...");
    System.out.println("============================");
    clips.reset();
    assertFacts(gameState);
    System.out.println();
    System.out.println("Finding Best Play...");
    clips.run();
    String evalStr = "(find-fact ((?f move)) TRUE)";
    FactAddressValue fv = (FactAddressValue) ((MultifieldValue) clips.eval(evalStr)).get(0);
    gameState.aiMove.type = State.Type.FOLD;
    try{
      if(fv.getFactSlot("move_type").toString().equals("fold")){
        gameState.aiMove.type = State.Type.FOLD;
        gameState.aiMove.payload = (int) Double.parseDouble(fv.getFactSlot("current_bet").toString());
      }else if(fv.getFactSlot("move_type").toString().equals("check")){
        gameState.aiMove.type = State.Type.CHECK;
      }else if(fv.getFactSlot("move_type").toString().equals("call")){
        gameState.aiMove.type = State.Type.CALL;
        gameState.aiMove.payload = Integer.parseInt(fv.getFactSlot("current_bet").toString());
      }else if( fv.getFactSlot("move_type").toString().equals("raise") ||
                fv.getFactSlot("move_type").toString().equals("bet")){
        gameState.aiMove.type = State.Type.RAISE;
        gameState.aiMove.payload = (int) Double.parseDouble(fv.getFactSlot("current_bet").toString());
      }
      System.out.println("DONE.");
    }catch(Exception e){
      System.out.println("");
      System.out.println("FUCKK!!!!");
      // System.out.println(e.getStackTrace().getFileName() + " " +
      //                    e.getStackTrace().getClassName() + " " +
      //                    e.getStackTrace().getMethodName() + " " +
      //                    e.getStackTrace().getLineNumber()
      // );
      System.out.println(e.getMessage());
    }
    return gameState;
  }

  // CLIPS Facts
  private void assertFacts(State gameState){
    String selfFact = String.format("(self (player_id 0) (name \"%s\") (money %f) (bet %f) (position 0) (win_probability %f))",
      name,
      (double) gameState.aiStack,
      (double) gameState.aiPot,
      (double) gameState.aiWinProbability
    );
    String playerLastMove = "";
    switch(gameState.lastMove.type){
      case CHECK:
        // playerLastMove += "(move_type check)";
        playerLastMove = "check";
        break;
      case RAISE:
        // playerLastMove += "(move_type raise) (current_bet " + gameState.lastMove.payload + ")";
        playerLastMove = "raise";
        break;
      case CALL:
        // playerLastMove += "(move_type call) (current_bet " + gameState.lastMove.payload + ")";
        playerLastMove = "call";
        break;
      case FOLD:
        // playerLastMove += "(move_type fold) (current_bet " + gameState.lastMove.payload + ")";
        playerLastMove = "fold";
        break;
    }
    String playerFact = String.format("(player (player_id 1) (name \"Player 1\") (money %f) (bet %f) (position 1) (move %s))",
      (double) gameState.playerStack,
      (double) gameState.playerPot,
      playerLastMove
    );
    int round = 0;
    switch(gameState.gameState){
      case PREFLOP:
        round = 0;
        break;
      case FLOP:
        round = 1;
        break;
      case TURN:
        round = 2;
        break;
      case RIVER:
        round = 3;
        break;
    }
    String gameStateFact = String.format("(game (round %d) (pot %f) (current_bet %f) (min_allowed_bet %f) )",
      round,
      (double) (gameState.playerPot + gameState.aiPot),
      (double) (gameState.playerPot > gameState.aiPot ? gameState.playerPot : gameState.aiPot),
      (double) (gameState.playerPot > gameState.aiPot ? gameState.playerPot : gameState.aiPot)
    );

    System.out.println("Asserting Hole Cards...");
    clips.assertString(gameState.aiCard[0].toClipsString("hole"));
    clips.assertString(gameState.aiCard[1].toClipsString("hole"));
    System.out.println("Asserting Board Cards...");
    for(int i=0; i<gameState.river.size(); i++){
      clips.assertString(gameState.river.get(i).toClipsString("board"));
    }
    System.out.println("Asserting Self...");
    clips.assertString(selfFact);
    System.out.println("Asserting Players..");
    clips.assertString(playerFact);
    System.out.println("Asserting Game State...");
    clips.assertString(gameStateFact);
  }

  // Validation and Test Suite
  public static void main(String[] args){
    Environment clips = new Environment();
    System.out.println(clips.getVersion());
    if(args.length > 0){
      System.out.println("Attempting to load file " + args[0]);
      System.out.println("If there are no error messages below, the file is valid CLIPS.");
      System.out.println("--------------------------------------------------------------");
      clips.load(args[0]);
      clips.reset();
      clips.run();
    }
  }
}