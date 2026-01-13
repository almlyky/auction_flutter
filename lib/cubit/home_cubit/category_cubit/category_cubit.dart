import 'package:auction/core/api/links_api.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:hive/hive.dart';

part 'category_state.dart';

class CategoryCubit extends BaseCubit<List<CategoryModel>> {
  final SharedRepository sharedRepository;
  List<CategoryModel> categoriesModel = [];
  final categoryBox = Hive.box<CategoryModel>('categories');
  int selectedindex = 0;
  int selectedindexchildren = 0;
  CategoryCubit(this.sharedRepository) : super() {
    fetchCategories();
  }

  Map<int, dynamic> getCategoryById = {};

  Future<void> fetchCategories() async {
    await load(() async {
      if (categoryBox.isNotEmpty) {
        categoriesModel = categoryBox.values.toList();
        // getCategoryById = {

        for (var category in categoriesModel) {
          getCategoryById[category.id!] = category;
          if (category.children!.isNotEmpty) {
            for (var child in category.children!) {
              getCategoryById[child.id!] = child;
            }
            // getCategoryById[category.id!]!.children = category.children!;
          }
        }
        // };
        // print(getCategoryById[2].);
        return categoriesModel;
      }
      final data = await sharedRepository.getdata(LinksApi.endpointCategories);
      List<CategoryModel> fetchedCategories =
          (data as List).map((json) => CategoryModel.fromJson(json)).toList();
      categoriesModel = fetchedCategories;
      await categoryBox.clear();
      await categoryBox.addAll(categoriesModel);
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
