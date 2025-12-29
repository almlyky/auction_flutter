import 'package:auction/core/api/links_api.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';

part 'category_state.dart';

class CategoryCubit extends BaseCubit<List<CategoryModel>> {
  final SharedRepository sharedRepository;
  List<CategoryModel> categoriesModel = [];
  int selectedindex = 0;
  int selectedindexchildren = 0;
  CategoryCubit(this.sharedRepository) : super() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    await load(() async {
      final data = await sharedRepository.getdata(LinksApi.endpointCategories);
      List<CategoryModel> fetchedCategories =
          (data as List).map((json) => CategoryModel.fromJson(json)).toList();
      categoriesModel = fetchedCategories;
      return fetchedCategories;
    });
  }

  void changeSelectedIndex(int index, String type) {
    if (type == "parent") {
      selectedindexchildren = 0;
      selectedindex = index;
    } else if (type == "child") {
      selectedindexchildren = index;
    }
    // Re-emit loaded state with current data to trigger UI update if needed
    // Since BaseCubit handles state, we might just want to emit BaseSuccess with current data
    emit(BaseSuccess(data: categoriesModel));
  }
}
