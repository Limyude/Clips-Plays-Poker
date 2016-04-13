package sample;

import java.util.ArrayList;

public class PokerProbability {

  /*
   * Calculate the poker's winning probability
   * Input:
   *    Array of player's cards,
   *    Array of community cards
   *    Number of opponents
   * Output:
   *    winning probability (0-1)
   * */

  public static double calculateWinningProbability(Card[] playerCards, ArrayList<Card> publicCards,
      int numOpponents) {

    double handStrength = calculateHandStrength(playerCards, publicCards, numOpponents);
    double[] handPotential = calculateHandPotential(playerCards, publicCards, numOpponents);
    double PPot = handPotential[0];
    double NPot = handPotential[1];

    double winningProbability = handStrength * (1 - NPot) + (1 - handStrength) * PPot;

    return winningProbability;
  }


  /*
   * Calculate the poker's hand strength
   *
   * Input:
   *    Array of player's cards
   *    Array of community cards
   *    Number of opponents
   * Output:
   *    Hand strength (0-1)
   *
   * */

  private static double calculateHandStrength(Card[] playerCards, ArrayList<Card> publicCards,
      int numOpponents) {
    double handStrength = oneOpponentHandStrength(playerCards, publicCards);
    return Math.pow(handStrength, numOpponents);
  }

  private static double oneOpponentHandStrength(Card[] playerCards, ArrayList<Card> publicCards) {
    double handStrength = 0;

    // fill in code

    return handStrength;
  }


  /*
   * Calculate the poker's hand potential
   *
   * Input:
   *    Array of player's cards
   *    Array of community cards
   *    Number of opponents
   * Output:
   *    An array of doubles of PPot and NPot
   *    PPot: probability that your hand is bad but turns out better in the future (0-1)
   *    NPot: probability that your hand is good but turns out worse in the future (0-1)
   *
   * */

  private static double[] calculateHandPotential(Card[] playerCards, ArrayList<Card> publicCards,
      int numOpponents) {
    double[] handPotential = oneOpponentHandPotential(playerCards, publicCards);
    double PPot = Math.pow(handPotential[0], numOpponents);
    double NPot = Math.pow(handPotential[1], numOpponents);

    return new double[] {PPot, NPot};
  }

  private static double[] oneOpponentHandPotential(Card[] playerCards, ArrayList<Card> publicCards) {
    double PPot = 0.0f, NPot = 0.0f;

    // fill in code

    return new double[] {PPot, NPot};
  }


  /*
   * Rank player's card
   *
   * Input:
   *    An array of all seen cards
   * Output:
   *    rank (an integer)
   *
   * Algorithm:
   *    TwoPlusTwoEvaluator
   * */
  private static int rank(Card[] seenCards) {
    int rank = 0;

    return rank;
  }
}