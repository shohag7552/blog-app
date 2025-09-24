abstract class PostCreateState {}

class PostCreateInitial extends PostCreateState {}
class PostCreateLoading extends PostCreateState {}
class PostCreateSuccess extends PostCreateState {}
class PostCreateFailure extends PostCreateState {
  final String message;
  PostCreateFailure(this.message);
}