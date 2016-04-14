package sample;

/**
 * Created by MOTHERSHIP on 27/3/2016.
 */
public class Card implements Comparable<Card>{
    public final Suite s;
    public final Value v;

    public static final int MIN_VAL = 1;
    public static final int MAX_VAL = 52;


    Card(Suite s, Value v){
        this.s = s;
        this.v = v;
    }

    @Override
    public String toString() {
        return Value.asString(this.v) + Suite.asString(this.s);
    }

    @Override
    public int compareTo(Card o) {
        if(o.s == this.s) return o.v.compareTo(this.v);
        return o.s.compareTo(this.s);
    }

    public String toClipsString(String location){
        int cardValue = 0;
        switch(this.v){
            case TEN:
                cardValue = 10;
                break;
            case JACK:
                cardValue = 11;
                break;
            case QUEEN:
                cardValue = 12;
                break;
            case KING:
                cardValue = 13;
                break;
            case ACE:
                cardValue = 14;
                break;
            default:
                cardValue = Integer.parseInt(Value.asString(this.v));
                break;
        }
        return String.format("(card (suit %s) (value %d) (location %s) )",
            Suite.asString(this.s),
            cardValue,
            location);
    }

    public String getPath(){
        return String.format("%s_of_%s.png",
            Value.asFilenameFragment(this.v),
            Suite.asFilenameFragment(this.s)
        );
    }

    public int getValue() {
        return Value.value(v) * 4 + Suite.value(s);
    }
}
