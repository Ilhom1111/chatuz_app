import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firebase/auth_service/auth_service.dart';
import '../../services/firebase/auth_service/util_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_signUp);
    on<SignInEvent>(_signIn);
    on<SignOutEvent>(_signOut);
    on<GetUserEvent>(_getUser);
    on<DeleteConfirmEvent>(_updateUI);
    on<DeleteAccountEvent>(_deleteAccount);
  }

  void _signUp(SignUpEvent event, Emitter emit) async {
    if (!Util.validateRegistration(
        event.username, event.email, event.password, event.prePassword)) {
      emit(const AuthFailure("Please check your data!"));
      return;
    }
    emit(AuthLoading());
    final result =
        await AuthService.signUp(event.email, event.password, event.username);
    if (result) {
      emit(SignUpSuccess());
    } else {
      emit(const AuthFailure("Something error, please try again later!!!"));
    }
  }

  void _signIn(SignInEvent event, Emitter emit) async {
    if (!Util.validateSingIn(event.email, event.password)) {
      emit(const AuthFailure("Please check your email or password!"));
      return;
    }

    emit(AuthLoading());
    final result = await AuthService.signIn(event.email, event.password);
    if (result) {
      emit(SignInSuccess());
    } else {
      emit(const AuthFailure("Something error, please try again later!!!"));
    }
  }

  void _signOut(SignOutEvent event, Emitter emit) async {
    emit(AuthLoading());
    final result = await AuthService.signOut();

    if (result) {
      emit(SignOutSuccess());
    } else {
      emit(const AuthFailure("Something error, please try again later!!!"));
    }
  }

  void _getUser(GetUserEvent event, Emitter emit) async {
    emit(GetUserSuccess(AuthService.user));
  }

  void _updateUI(DeleteConfirmEvent event, Emitter emit) {
    emit(const DeleteConfirmSuccess());
  }

  void _deleteAccount(DeleteAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = AuthService.user;
    final resultSignIn = await AuthService.signIn(user.email!, event.password);

    if (!resultSignIn) {
      emit(const AuthFailure("Please enter valid password!"));
      return;
    }

    final result = await AuthService.deleteAccount();
    if (result) {
      emit(const DeleteAccountSuccess("Successfully deleted your account!"));
    } else {
      emit(const AuthFailure("Something error, please try again later!!!"));
    }
  }
}
