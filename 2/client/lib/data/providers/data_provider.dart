import '../../logic/models/sorting_value.dart';

abstract class DataProvider<T> {
  const DataProvider();
  Future<List<T>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  });
  Future<T?> getById(int id);
  Future<T?> create(T data);
  Future<T?> update(int id, T newData);
  Future<String> delete(int id);
}
