part of 'post_cubit.dart';



final class PostImageSelected extends BaseState<List<PostModel>> {
  final List<File> images;

  const PostImageSelected(this.images);

  @override
  List<Object> get props => [images];
}

final class PostCategorySelected extends BaseState<List<PostModel>> {
  final CategoryModel parent;
  final Children? child;

  const PostCategorySelected(this.parent, this.child);

  @override
  List<Object> get props => [parent, child ?? ''];
}
