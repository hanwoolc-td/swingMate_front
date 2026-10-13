import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/presentation/states/member_signup_state.dart';
import 'package:swingmate/features/auth/presentation/viewmodels/member_signup_view_model.dart';

final memberSignupViewModelProvider =
    NotifierProvider<MemberSignupViewModel, MemberSignupState>(
      MemberSignupViewModel.new,
    );
