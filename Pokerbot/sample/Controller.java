package sample;

import javafx.event.ActionEvent;
import javafx.scene.control.Button;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.*;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.lang.reflect.Array;
import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import sample.PokerBot;

public class Controller {

    public TextField raiseAmount;
    public Label handLabel;
    public Label stackLabel;
    public Label riverLabel;
    public Label turnLabel;
    public State state = new State();
    public Button checkButton;
    public Button raiseButton;
    public Button callButton;
    public Button foldButton;
    public Button startGameButton;
    public Label playerPotLabel;
    public Label aiPotLabel;
    private static final int BLIND = 2;

    private PokerBot bot = new PokerBot("PokerBot.clp");

    public void check(ActionEvent actionEvent) {
        this.state.lastMove.type = State.Type.CHECK;
        switch(this.state.gameState){
            case PREFLOP : { dealFlop(); }; break;
            case FLOP : { dealTurn(); }; break;
            case TURN : { dealRiver(); }; break;
            case RIVER: { showdown(); }; break;
        }
    }

    public void raise(ActionEvent actionEvent) {
        // raiseAmount.getText()
    }

    public void call(ActionEvent actionEvent) {
        Integer diff = this.state.aiPot - this.state.playerPot;
        this.state.playerStack -= diff;
        this.state.playerPot += diff;
        this.state.lastMove.type = State.Type.CALL;
        switch(this.state.gameState){
            case PREFLOP : { dealFlop(); }; break;
            case FLOP : { dealTurn(); }; break;
            case TURN : { dealRiver(); }; break;
            case RIVER: { showdown(); }; break;
        }
    }

    public void dealFlop(){
        try{
            this.state.deck.take();
            this.state.river.add(this.state.deck.take());
            this.state.deck.take();
            this.state.river.add(this.state.deck.take());
            this.state.deck.take();
            this.state.river.add(this.state.deck.take());
        }catch(Exception e){ System.out.println(e); }
        this.state.gameState = State.GameState.FLOP;
        getAiAction(this.state);
        persistAiMove();
        renderState();
    }

    public void dealTurn(){
        try{
            this.state.deck.take();
            this.state.river.add(this.state.deck.take());
        }catch(Exception e){ System.out.println(e); }
        this.state.gameState = State.GameState.TURN;
        getAiAction(this.state);
        persistAiMove();
        renderState();
    }

    public void dealRiver(){
        try{
            this.state.deck.take();
            this.state.river.add(this.state.deck.take());
        }catch(Exception e){ System.out.println(e); }
        this.state.gameState = State.GameState.RIVER;
        getAiAction(this.state);
        persistAiMove();
        renderState();
    }

    public void aiWins(){
        Alert alert = new Alert(AlertType.INFORMATION);
        alert.setTitle("Result");
        alert.setHeaderText("ai won");
        this.state.aiStack += this.state.aiPot + this.state.playerPot;
        alert.showAndWait();
    }

    public void playerWins(){
        Alert alert = new Alert(AlertType.INFORMATION);
        alert.setTitle("Result");
        alert.setHeaderText("player won");
        this.state.playerStack += this.state.aiPot + this.state.playerPot;
        alert.showAndWait();
    }

    public void showdown(){
        if(isPlayerWinner()){
            playerWins();
        }else{
            aiWins();
        }
        resetBoard();
        renderState();
        this.state.gameState = State.GameState.GAMEOVER;
        renderState();
    }

    public void fold(ActionEvent actionEvent) {
        aiWins();
        resetBoard();
        renderState();
        this.state.gameState = State.GameState.GAMEOVER;
        renderState();
    }

    public State getAiAction(State state){
        // Since Move is a class inside State, it can't be returned stand alone.
        // It has to be encapsulated inside State. So the returned state is the
        // same as the original state with a new Move in state.aiMove
        // so in order to get the Move just call bot.play(state).aiMove
        return bot.play(state);
    }

    public void renderState(){
        System.out.println("render called with state " + this.state.gameState.asString());
        if(this.state == null){
            return;
        }

        if(this.state.gameState != State.GameState.GAMEOVER){
            try{
                handLabel.setText(this.state.playerCard[0].toString() + "," +  this.state.playerCard[1].toString());
            }catch(Exception e){
                handLabel.setText("");
                System.out.println("sadad");
            }
            stackLabel.setText(this.state.playerStack + "");
            riverLabel.setText(
                    this.state.river.stream()
                            .map( c -> c.toString() )
                            .collect(Collectors.joining(","))
            );
            turnLabel.setText(this.state.turn ? "Your turn" : "AI Turn");
            playerPotLabel.setText(this.state.playerPot + "");
            aiPotLabel.setText(this.state.aiPot + "");

            checkButton.setDisable(this.state.aiMove.type != State.Type.CHECK);
            raiseButton.setDisable(!this.state.turn);
            callButton.setDisable(!this.state.turn);
            foldButton.setDisable(!this.state.turn);
        }
        startGameButton.setDisable(this.state.gameState != State.GameState.GAMEOVER);
    }

    public void startGame(ActionEvent actionEvent) {

        ArrayList<Card> cards = new ArrayList<Card>();
        BlockingQueue<Card> deck = new ArrayBlockingQueue<Card>(52);

        for(Suite suite : Suite.values()){
            for(Value val : Value.values()){
                cards.add(new Card(suite, val));
            }
        }

        // Fisher yates shuffling
        Random rand = new Random();
        while(cards.size() != 0){
            int randInt = rand.nextInt(cards.size());
            try{
                deck.put(cards.remove(randInt));
            }catch(Exception e){ System.out.print(e.getStackTrace());}
        }

        try{
            this.state.playerCard[0] = deck.take();
            this.state.playerCard[1] = deck.take();
            this.state.aiCard[0] = deck.take();
            this.state.aiCard[1] = deck.take();
        }catch(Exception e){ System.out.print(e.getStackTrace());}

        this.state.deck = deck;
        this.state.gameState = State.GameState.PREFLOP;
        this.state.aiStack -= BLIND;
        this.state.playerStack -= BLIND;
        this.state.aiPot = BLIND;
        this.state.playerPot = BLIND;
        getAiAction(this.state);
        persistAiMove();
        this.state.turn = true;
        renderState();
    }

    public void persistAiMove(){
        switch(this.state.aiMove.type){
            case RAISE: {
                this.state.aiStack -= this.state.aiMove.payload;
                this.state.aiPot += this.state.aiMove.payload;
            }
            break;
            case FOLD: {
                playerWins();
                resetBoard();
                renderState();
                this.state.gameState = State.GameState.GAMEOVER;
                renderState();
            }
        }
    }

    public void resetBoard(){
        this.state.aiPot = 0;
        this.state.playerPot = 0;
        this.state.playerCard = new Card[2];
        this.state.aiCard = new Card[2];
        this.state.river = new ArrayList<>();
    }

    public boolean isPlayerWinner(){
        HandType playerResult = makeHand(this.state.playerCard, this.state.river);
        HandType botResult = makeHand(this.state.aiCard, this.state.river);
        System.out.println("Player: " + playerResult.asString());
        System.out.println("Bot: " + botResult.asString());
        return botResult.compareTo(playerResult) < 0;
    }

    // Royal flush is just a variation of a straight flush, no need for a seprate enum
    public enum PokerHand{
        KICKER, PAIR, TWOPAIR, TRIPS, STRAIGHT, FLUSH, FULLHOUSE, QUADS, STRAIGHTFLUSH;
        public String asString(){
            switch(this){
                case KICKER: return "KICKER";
                case PAIR: return "PAIR";
                case TWOPAIR: return "TWOPAIR";
                case TRIPS: return "TRIPS";
                case STRAIGHT: return "STRAIGHT";
                case FLUSH: return "FLUSH";
                case FULLHOUSE: return "FULLHOUSE";
                case QUADS: return "QUADS";
                case STRAIGHTFLUSH: return "STRAIGHTFLUSH";
            }
            return "";
        }
    }

    public class HandType implements Comparable<HandType>{
        public PokerHand hand;
        public ArrayList<Card> context = new ArrayList<>();

        HandType(PokerHand ph, ArrayList<Card> context){
            this.hand = ph;
            this.context = context;
        }

        @Override
        public int compareTo(HandType o) {
            if(this.hand == o.hand){
                Collections.sort(this.context);
                Collections.sort(o.context);
                return this.context.get(0).compareTo(o.context.get(0));
            }
            return this.hand.compareTo(o.hand);
        }

        public String asString(){
            return this.hand.asString();
        }
    }

    public HandType makeHand(Card[] hand, ArrayList<Card> ccards){
        ArrayList<Card> cards = makeCopy(ccards);
        cards.add(hand[0]);
        cards.add(hand[1]);

        // Straight flush (Also gets royal flush as well)
        if(getFlush(cards).size() > 0){
            if(getStraight(getStraight(cards)).size() > 0 ){
                return new HandType(PokerHand.STRAIGHTFLUSH, getStraight(getStraight(cards)));
            }
        }

        if(getQuads(cards).size() > 0){
            return new HandType(PokerHand.QUADS, getQuads(cards));
        }

        if(getTrips(cards).size() > 0){
            ArrayList<Card> temp = makeCopy(cards);
            temp.removeAll(getTrips(cards));
            if(getPair(temp).size() > 0){
                temp.addAll(getTrips(cards));
                return new HandType(PokerHand.FULLHOUSE, temp);
            }
        }

        if(getFlush(cards).size() > 0){
            return new HandType(PokerHand.FLUSH, cards);
        }

        if(getStraight(cards).size() > 0){
            return new HandType(PokerHand.STRAIGHT, cards);
        }

        if(getTrips(cards).size() > 0){
            return new HandType(PokerHand.TRIPS, cards);
        }

        if(getPair(cards).size() > 0){
            ArrayList<Card> temp = makeCopy(cards);
            temp.removeAll(getPair(cards));
            if(getPair(temp).size() > 0){
                temp.addAll(getPair(cards));
                return new HandType(PokerHand.TWOPAIR, temp);
            }
        }

        if(getPair(cards).size() > 0){
            return new HandType(PokerHand.PAIR, cards);
        }

        return new HandType(PokerHand.KICKER, cards);
    }

    public static <T> ArrayList<T> makeCopy(ArrayList<T> something){
        ArrayList<T> holder = new ArrayList<>();
        for(T i : something){
            holder.add(i);
        }
        return holder;
    }

    public HashMap<Suite, ArrayList<Card>> groupBySuite(final ArrayList<Card> cards){
        HashMap<Suite, ArrayList<Card>> holder = new HashMap<>();
        for(Suite s : Suite.values()){
            holder.put(s, new ArrayList<>());
        }

        for(Card c : cards){
            holder.get(c.s).add(c);
        }

        return holder;
    }

    public HashMap<Value, ArrayList<Card>> groupByValue(final ArrayList<Card> cards){
        HashMap<Value, ArrayList<Card>> holder = new HashMap<>();

        for(Value v : Value.values()){
            holder.put(v, new ArrayList<>());
        }

        for(Card c : cards){
            holder.get(c.v).add(c);
        }

        return holder;
    }

    public ArrayList<Card> getFlush(final ArrayList<Card> cards){
        HashMap<Suite, ArrayList<Card>> suiteGroups = groupBySuite(cards);

        for(Suite s : suiteGroups.keySet()){
            if(suiteGroups.get(s).size() >= 5){
                ArrayList<Card> holder = new ArrayList<>();
                for(Object cc : cards.stream().filter( c -> c.s == s).sorted().limit(5).toArray()){
                    holder.add((Card)cc);
                }
                return holder;
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<Card> getStraight(final ArrayList<Card> cards){
        if(cards.size() < 5){
            return new ArrayList<>();
        }
        for(int i = 0; i <= cards.size() - 5; i++){
            if(
                    Value.getNext(cards.get(i).v) == cards.get(i + 1).v &&
                    Value.getNext(cards.get(i + 1).v) == cards.get(i + 2).v &&
                    Value.getNext(cards.get(i + 2).v) == cards.get(i + 3).v &&
                    Value.getNext(cards.get(i + 3).v) == cards.get(i + 4).v
                    ){
                ArrayList<Card> holder = new ArrayList<>();
                for(int j = 0; j < 5; j++){
                    holder.add(cards.get(i + j));
                }
                return holder;
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<Card> getQuads(final ArrayList<Card> cards){
        HashMap<Value, ArrayList<Card>> valueGroups = groupByValue(cards);

        for(Value v : valueGroups.keySet()){
            if(valueGroups.get(v).size() == 4){
                return valueGroups.get(v);
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<Card> getTrips(final ArrayList<Card> cards){
        HashMap<Value, ArrayList<Card>> valueGroups = groupByValue(cards);

        for(Value v : valueGroups.keySet()){
            if(valueGroups.get(v).size() == 3){
                return valueGroups.get(v);
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<Card> getPair(final ArrayList<Card> cards){
        HashMap<Value, ArrayList<Card>> valueGroups = groupByValue(cards);

        for(Value v : valueGroups.keySet()){
            if(valueGroups.get(v).size() == 2){
                return valueGroups.get(v);
            }
        }

        return new ArrayList<>();
    }

}