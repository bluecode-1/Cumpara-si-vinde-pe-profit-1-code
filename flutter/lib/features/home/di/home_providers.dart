import 'package:profitnet/core/network/dio_provider.dart';
import 'package:profitnet/features/home/data/logout_repository_impl.dart';
import 'package:profitnet/features/home/domain/logout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@Riverpod(keepAlive: true)
LogoutRepository logoutRepository(Ref ref) =>
    LogoutRepositoryImpl(ref.watch(dioProvider));
