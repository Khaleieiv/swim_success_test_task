import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swim_success/features/user_list/data/models/user.dart';
import 'package:swim_success/features/user_list/data/user_repository.dart';

class MockDio extends Mock implements Dio {}
class MockResponse extends Mock implements Response<dynamic> {}

void main() {
  group('UserRepository Tests', () {
    late MockDio mockDio;
    late UserRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = UserRepositoryImpl(mockDio);
    });

    test('fetchUsers returns a list of User objects when status code is 200', () async {
      final mockResponse = MockResponse();
      final List<Map<String, dynamic>> mockData = [
        {
          'id': 1,
          'name': 'John Doe',
          'username': 'johndoe',
          'email': 'john@example.com',
          'phone': '123-456-7890',
          'website': 'example.com',
          'address': {
            'street': 'Main St',
            'suite': 'Apt 1',
            'city': 'Metropolis',
            'zipcode': '12345',
            'geo': {'lat': '1.0', 'lng': '2.0'}
          },
          'company': {
            'name': 'Acme Corp',
            'catchPhrase': 'Think Big',
            'bs': 'SaaS'
          }
        }
      ];

      when(() => mockResponse.data).thenReturn(mockData);
      when(() => mockResponse.requestOptions).thenReturn(RequestOptions(path: '/users'));
      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);

      final result = await repository.fetchUsers();

      expect(result, isA<List<User>>());
      expect(result.length, 1);
      expect(result.first.name, 'John Doe');
      expect(result.first.address.city, 'Metropolis');
      expect(result.first.company.name, 'Acme Corp');
      verify(() => mockDio.get('/users')).called(1);
    });

    test('fetchUsers throws Exception when response is not a list', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.data).thenReturn('Not a list');
      when(() => mockResponse.requestOptions).thenReturn(RequestOptions(path: '/users'));
      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);

      expect(() => repository.fetchUsers(), throwsA(isA<DioException>()));
    });
  });
}
