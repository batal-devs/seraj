import 'package:athar/app/core/l10n/l10n_service.dart';
import 'package:get_it/get_it.dart';

extension GetItX on GetIt {
  // Blocs
  // AuthBloc get authBloc => get<AuthBloc>();
  // Services
  L10nService get l10nSvc => get<L10nService>();
  // Repositories
  // AuthRepository get authRepo => get<AuthRepository>();
}
