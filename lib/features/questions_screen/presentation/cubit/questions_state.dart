abstract class QuestionsState {
  const QuestionsState();
}

class QuestionsAnswering extends QuestionsState {
  final int index;
  const QuestionsAnswering(this.index);
}

class QuestionsFinished extends QuestionsState {
  const QuestionsFinished();
}
