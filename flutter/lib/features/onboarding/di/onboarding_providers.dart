import 'package:profitnet/core/network/dio_provider.dart';
import 'package:profitnet/features/onboarding/data/onboarding_api.dart';
import 'package:profitnet/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_providers.g.dart';

/// Composition root of the feature: the only place where the presentation
/// layer's dependency on [OnboardingRepository] is bound to the data layer.
@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) =>
    OnboardingRepositoryImpl(OnboardingApi(ref.watch(dioProvider)));
