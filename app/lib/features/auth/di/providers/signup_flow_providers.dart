import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';
import 'package:swingmate/features/auth/presentation/viewmodels/signup_flow_view_model.dart';

final signupFlowViewModelProvider =
    NotifierProvider<SignupFlowViewModel, SignupFlowState>(
      SignupFlowViewModel.new,
    );
