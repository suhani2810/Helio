import 'dart:math';

class SentencePool {
  static const List<String> sentences = [
    "Each morning is a new opportunity to build the life you deserve.",
    "Discipline is the bridge between goals and accomplishment.",
    "The secret of getting ahead is getting started.",
    "Your future is created by what you do today, not tomorrow.",
    "Win the morning to win the day.",
    "Focus on being productive instead of busy.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Success is not overnight. It is when everyday you get a little better.",
    "Great things never came from comfort zones.",
    "The only limit to our realization of tomorrow is our doubts of today.",
    "Habit is what keeps you going. Motivation is what gets you started.",
    "Rise up, start fresh, and see the bright opportunity in each day.",
    "Do not count the days, make the days count.",
    "Action is the foundational key to all success.",
    "Believe you can and you are halfway there.",
    "Your focus determines your reality.",
    "The best way to predict the future is to create it.",
    "Today is another chance to get stronger and better.",
    "Small daily improvements over time lead to stunning results.",
    "You do not have to be great to start, but you have to start to be great.",
    "Discipline equals freedom.",
    "Concentrate all your thoughts upon the work at hand.",
    "Energy and persistence conquer all things.",
    "Make each day your masterpiece.",
    "Rise and shine. Your potential is limitless."
  ];

  static String getRandomSentence() {
    final random = Random();
    return sentences[random.nextInt(sentences.length)];
  }
}
