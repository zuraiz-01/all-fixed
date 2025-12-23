import 'package:eye_buddy/app/bloc/doctor_list/doctor_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorFeeSlider extends StatefulWidget {
  @override
  _DoctorFeeSliderState createState() => _DoctorFeeSliderState();
}

class _DoctorFeeSliderState extends State<DoctorFeeSlider> {
  RangeValues _currentRangeValues = const RangeValues(1, 500);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: BlocBuilder<DoctorListCubit, DoctorListState>(
        builder: (context, state) {
          return RangeSlider(
            values: _currentRangeValues,
            min: 1,
            max: 1000,
            divisions: 100,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
              context.read<DoctorListCubit>().updateConsultationFee(
                  minConsultationFee: _currentRangeValues.start.round(), maxConsultationFee: _currentRangeValues.end.round());
            },
          );
        },
      ),
    );
  }
}
