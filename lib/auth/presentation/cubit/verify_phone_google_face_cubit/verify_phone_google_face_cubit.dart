import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/registerBy_Google_use_case.dart';
import '../../../register/domain/useCase/registerBy_facebook_usecase.dart';
import '../../../register/domain/useCase/register_apple_useCase.dart';
import 'verify_phone_google_face_states.dart';


class VerifyPhoneGoogleFaceCubit extends Cubit<VerifyPhoneGoogleFaceStates> {
  RegisterByGoogleUseCase? registerByGoogleUseCase;
  RegisterWithFacebookUseCase? registerWithFacebookUseCase;
  RegisterAppleUseCase? registerAppleUseCase;

  VerifyPhoneGoogleFaceCubit(
    this.registerByGoogleUseCase,
    this.registerWithFacebookUseCase,
    this.registerAppleUseCase
  ):super(InitialRegisterByGoogleState());

  static VerifyPhoneGoogleFaceCubit get(context) => BlocProvider.of(context);

  String? errorMessage;
///////////////////////////////////////////////////////////////////////////////// register by google
  registerByGoogle(
      {required String token,
      required String email,
      required String mobile,
      required String countryCode,
      required int sourceId}) async {
    emit(RegisterByGoogleStateLoading());
    debugPrint('Hassan ' + token);
    final result = await registerByGoogleUseCase!(token, email, mobile, countryCode, sourceId);
    result.fold(
        (failure) {
          errorMessage = failure.errorMessage;
          emit(RegisterByGoogleStateFailure(failure.errorMessage));
        },
        (registerGoogle) {
      if (registerGoogle.isSuccess == true) {
        print('Success = true');
        emit(RegisterByGoogleStateSuccess(registerGoogle));
      } else {
        errorMessage = registerGoogle.errors?.first.message;
        print('Success = false');
        emit(RegisterByGoogleStateError(registerGoogle));
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////// register by facebook
  registerByFacebook(
      {required String token,
        required String email,
        required String mobile,
        required String countryCode,
        required int sourceId}) async {
    emit(RegisterFacebookLoading());
    final result = await registerWithFacebookUseCase!(token, email, mobile, countryCode, sourceId);
    result.fold(
            (failure) {
              errorMessage = failure.errorMessage;
              emit(RegisterFacebookFailure(failure.errorMessage));
            },
            (registerFacebook) {
          if (registerFacebook.isSuccess == true) {
            print('Success = true');
            emit(RegisterFacebookSuccess(registerFacebook));
          } else {
            print('Success = false');
            errorMessage = registerFacebook.errors?.first.message;
            print(registerFacebook.errors?.first.message);
            emit(RegisterFacebookError(registerFacebook));
          }
        }
    );
  }
/////////////////////////////////////////////////////////////////////////////////// register by apple
  registerByApple(
      {required String token,
        required String email,
        required String mobile,
        required String countryCode,
        required int sourceId}
  ) async {
    emit(RegisterAppleLoading());
    final result = await registerAppleUseCase!(token, email, mobile, countryCode, sourceId);
    result.fold((failure) {
          errorMessage = failure.errorMessage;
          emit(RegisterAppleFailure(failure.errorMessage));
        }, (registerApple) {
          if (registerApple.isSuccess == true) {
            debugPrint('Success = true');
            emit(RegisterAppleSuccess(registerApple));
          } else {
            debugPrint('Success = false');
            errorMessage = registerApple.errors?.first.message;
            debugPrint(registerApple.errors?.first.message);
            emit(RegisterAppleError(registerApple));
          }
        }
    );
  }

}
