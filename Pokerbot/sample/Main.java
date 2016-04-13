package sample;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import jdk.nashorn.internal.ir.Block;

import javax.xml.bind.ValidationEventLocator;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        // Create a deck of cards
        FXMLLoader loader = new FXMLLoader(getClass().getResource("sample.fxml"));
        Parent root = loader.load();
        primaryStage.setTitle("Poker Bot");
        primaryStage.setScene(new Scene(root, 600, 120));
        primaryStage.show();
    }


    public static void main(String[] args) {
        System.setProperty("java.library.path", ".");
        launch(args);
    }
}
