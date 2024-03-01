import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../data.dart';

class FeatureRepositoryImpl extends FeatureRepository {

 final FeatureRemoteDataSource featureRemoteDataSource;
 final FeatureLocalDataSource featureLocalDataSource;
 final NetworkInfo networkInfo;

 FeatureRepositoryImpl({
   required this.featureLocalDataSource,
   required this.networkInfo,
   required this.featureRemoteDataSource,
 });
}
