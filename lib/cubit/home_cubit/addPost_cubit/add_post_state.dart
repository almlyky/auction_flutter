part of 'add_post_cubit.dart';

class AddPostState extends Equatable {
  final List<File> newImages;
  final List<Images> currentImages;
  final List<int> deletedImageIds;
  final CategoryModel? selectedCategory;
  final Children? selectedChildCategory;
  final String selectedStatus;
  final String selectedCategoryText;
  final int? selectedCategoryId;
  final BaseState<List<PostModel>> status; // To track loading/success/error

  const AddPostState({
    this.newImages = const [],
    this.currentImages = const [],
    this.deletedImageIds = const [],
    this.selectedCategory,
    this.selectedChildCategory,
    this.selectedStatus = 'used',
    this.selectedCategoryText = "اختر الفئة",
    this.selectedCategoryId,
    this.status = const BaseInitial(),
  });

  AddPostState copyWith({
    List<File>? newImages,
    List<Images>? currentImages,
    List<int>? deletedImageIds,
    CategoryModel? selectedCategory,
    Children? selectedChildCategory,
    String? selectedStatus,
    String? selectedCategoryText,
    int? selectedCategoryId,
    BaseState<List<PostModel>>? status,
  }) {
    return AddPostState(
      newImages: newImages ?? this.newImages,
      currentImages: currentImages ?? this.currentImages,
      deletedImageIds: deletedImageIds ?? this.deletedImageIds,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedChildCategory:
          selectedChildCategory ?? this.selectedChildCategory,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedCategoryText: selectedCategoryText ?? this.selectedCategoryText,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        newImages,
        currentImages,
        deletedImageIds,
        selectedCategory,
        selectedChildCategory,
        selectedStatus,
        selectedCategoryText,
        selectedCategoryId,
        status,
      ];
}
